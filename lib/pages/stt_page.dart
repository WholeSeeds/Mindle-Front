import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/complaint_controller.dart';
import 'package:mindle/controllers/location_controller.dart';
import 'package:mindle/designs.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:mindle/main.dart';
import 'package:mindle/services/naver_maps_service.dart';
import 'package:mindle/widgets/mindle_top_appbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mindle/config/livekit_config.dart';
import 'package:mindle/services/livekit_token_service.dart';

class SttPage extends StatefulWidget {
  const SttPage({super.key});

  @override
  State<SttPage> createState() => SttPageState();
}

class SttPageState extends State<SttPage> with SingleTickerProviderStateMixin {
  ComplaintController get _complaintController =>
      Get.find<ComplaintController>();
  LocationController get _locationController => Get.find<LocationController>();

  bool isListening = false;
  bool isConnecting = false;
  String statusMessage = '버튼을 눌러 말씀해 주세요';
  String transcribedText = ''; // 인식된 텍스트

  Map<String, String> complaintData = {}; // 수집된 민원 정보

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // LiveKit 관련
  Room? _room;
  LocalAudioTrack? _localAudioTrack;
  EventsListener<RoomEvent>? _roomListener;

  @override
  void initState() {
    super.initState();

    // 펄스 애니메이션 설정
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);

    // 권한 요청
    _requestPermissions();
    _startListening();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _cleanupLiveKit();
    super.dispose();
  }

  // 권한 요청
  Future<void> _requestPermissions() async {
    final status = await Permission.microphone.status;

    if (status.isDenied) {
      final result = await Permission.microphone.request();
      if (result.isPermanentlyDenied) {
        // 권한이 영구적으로 거부된 경우 설정으로 이동
        print('⚠️ 마이크 권한이 거부되었습니다. 설정에서 권한을 허용해주세요.');
      }
    } else if (status.isPermanentlyDenied) {
      print('⚠️ 마이크 권한이 영구적으로 거부되었습니다.');
      // 설정 앱으로 이동하도록 안내
      await openAppSettings();
    }
  }

  // LiveKit 정리
  Future<void> _cleanupLiveKit() async {
    await _localAudioTrack?.stop();
    _localAudioTrack = null;

    _roomListener?.dispose();
    _roomListener = null;

    await _room?.disconnect();
    await _room?.dispose();
    _room = null;
  }

  // LiveKit 연결 및 음성 스트리밍 시작
  Future<void> _startListening() async {
    if (isConnecting) return;

    setState(() {
      isConnecting = true;
      statusMessage = '연결 중...';
    });

    try {
      // 마이크 권한 확인
      final micStatus = await Permission.microphone.status;
      if (!micStatus.isGranted) {
        final result = await Permission.microphone.request();
        if (!result.isGranted) {
          throw Exception('마이크 권한이 필요합니다');
        }
      }

      // Room 생성
      _room = Room();

      // 이벤트 리스너 설정
      _roomListener = _room!.createListener();
      _roomListener!
        ..on<RoomConnectedEvent>((_) {
          print('✅ LiveKit Room 연결 성공');
          setState(() {
            statusMessage = 'AI와 대화 중...';
          });
        })
        ..on<RoomDisconnectedEvent>((_) {
          print('❌ LiveKit Room 연결 해제');
        })
        ..on<TrackPublishedEvent>((event) {
          print('✅ 트랙 발행됨: ${event.publication.sid}');
        })
        ..on<TrackSubscribedEvent>((event) {
          print('✅ 트랙 구독됨: ${event.track.sid}');
          // Agent의 음성 트랙 받기
          if (event.track is RemoteAudioTrack) {
            setState(() {
              statusMessage = 'AI가 응답 중...';
            });
          }
        })
        ..on<DataReceivedEvent>((event) {
          // Agent로부터 데이터 수신 (인식된 텍스트 등)
          // UTF-8 디코딩 (한글 깨짐 방지)
          final data = utf8.decode(event.data);
          print('📩 Agent 데이터: $data');
          //TODO: 데이터를 처리하는 로직 추가
          print('📥 데이터 수신: $data');

          // 전체 대화 내용 누적
          transcribedText += data + '\n';

          // JSON 형식으로 파싱 시도
          try {
            final jsonData = jsonDecode(data);
            _processComplaintData(jsonData);
          } catch (e) {
            // JSON이 아니면 일반 텍스트로 처리
            _processTextData(data);
          }
        });

      // LiveKit 서버 연결
      if (LiveKitConfig.isConfigured) {
        final serverUrl = LiveKitConfig.serverUrl;

        // 토큰 생성 (임시로 클라이언트에서 생성 - 실제로는 백엔드에서 받아와야 함)
        final token = await LiveKitTokenService.generateToken();

        print('🔧 LiveKit 연결 시작...');
        print('   Server: $serverUrl');
        print('   Token: ${token.substring(0, 20)}...');

        await _room!.connect(serverUrl, token);
        print('✅ LiveKit 서버 연결 완료');
      } else {
        throw Exception('LiveKit 서버가 설정되지 않았습니다');
      }

      // 로컬 오디오 트랙 생성 및 발행
      _localAudioTrack = await LocalAudioTrack.create(
        AudioCaptureOptions(
          echoCancellation: true,
          noiseSuppression: true,
          autoGainControl: true,
        ),
      );

      await _room!.localParticipant?.publishAudioTrack(_localAudioTrack!);
      print('🎤 오디오 트랙 발행 완료');

      setState(() {
        isListening = true;
        isConnecting = false;
        statusMessage = 'AI와 대화 중...';
      });

      print('🎤 음성 인식 시작');
    } catch (e) {
      print('❌ LiveKit 연결 실패: $e');
      setState(() {
        isConnecting = false;
        statusMessage = '연결 실패: ${e.toString()}';
      });

      await _cleanupLiveKit();

      // 3초 후 원래 메시지로 복구
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            statusMessage = '버튼을 눌러 말씀해 주세요';
          });
        }
      });
    }
  }

  /// JSON 데이터 처리 (Agent가 구조화된 데이터를 보낼 경우)
  Future<void> _processComplaintData(Map<String, dynamic> data) async {
    print('📊 민원 데이터 수신: $data');

    // title, content, category 추출
    if (data.containsKey('title')) {
      complaintData['title'] = data['title'];
      _complaintController.title.value = data['title'];
    }

    if (data.containsKey('content')) {
      complaintData['content'] = data['content'];
      _complaintController.content.value = data['content'];
    }

    if (data.containsKey('category')) {
      final category = data['category'] as String;
      complaintData['category'] = category;

      // 카테고리 매핑 (AI가 한글로 보낼 경우)
      final categoryMap = {
        '도로': '도로',
        '보도': '도로',
        '가로등': '치안',
        '신호등': '치안',
        '쓰레기': '환경',
        '환경': '환경',
        '소음': '환경',
        '진동': '환경',
        '치안': '치안',
        '기타': '기타',
      };

      // 카테고리 매칭
      String? matchedCategory;
      for (var entry in categoryMap.entries) {
        if (category.contains(entry.key)) {
          matchedCategory = entry.value;
          break;
        }
      }

      if (matchedCategory != null &&
          _complaintController.categoryList.contains(matchedCategory)) {
        _complaintController.selectedCategory.value = matchedCategory;
      }
    }

    // 위치 정보 (latitude, longitude)
    if (data.containsKey('latitude') && data.containsKey('longitude')) {
      complaintData['latitude'] = data['latitude'].toString();
      complaintData['longitude'] = data['longitude'].toString();
    }

    setState(() {
      statusMessage = '민원 정보가 수집되었습니다';
    });

    // 민원 정보 수집 완료 → 자동으로 민원 제출 및 화면 닫기
    print('✅ 민원 데이터 수신 완료 - 자동 제출 시작');
    await Future.delayed(const Duration(milliseconds: 500)); // UI 업데이트 대기
    await submitCollectedComplaint();
  }

  /// 텍스트 데이터 처리 (AI 응답 텍스트)
  void _processTextData(String text) {
    print('💬 텍스트 수신: $text');

    // 간단한 키워드 추출 로직
    // 예: "제목은 XXX입니다", "내용은 YYY입니다" 형식 감지

    // 제목 추출
    final titlePattern = RegExp(r'제목[은는]?\s*[:\"]?\s*(.+?)(?:[입이니다\"\.!\?]|$)');
    final titleMatch = titlePattern.firstMatch(text);
    if (titleMatch != null) {
      final title = titleMatch.group(1)?.trim();
      if (title != null && title.isNotEmpty) {
        complaintData['title'] = title;
        _complaintController.title.value = title;
      }
    }

    // 내용 추출
    final contentPattern = RegExp(
      r'내용[은는]?\s*[:\"]?\s*(.+?)(?:[입이니다\"\.!\?]|$)',
    );
    final contentMatch = contentPattern.firstMatch(text);
    if (contentMatch != null) {
      final content = contentMatch.group(1)?.trim();
      if (content != null && content.isNotEmpty) {
        complaintData['content'] = content;
        _complaintController.content.value = content;
      }
    }

    // 카테고리 추출
    final categoryKeywords = {
      '도로': ['도로', '보도', '포장', '파손', '균열'],
      '치안': ['가로등', '신호등', '불법주차', '안전'],
      '환경': ['쓰레기', '청소', '환경', '소음', '진동', '악취'],
      '기타': ['기타', '불편'],
    };

    for (var entry in categoryKeywords.entries) {
      for (var keyword in entry.value) {
        if (text.contains(keyword)) {
          complaintData['category'] = entry.key;
          _complaintController.selectedCategory.value = entry.key;
          break;
        }
      }
    }
  }

  /// 민원 제출
  /// AI와의 대화가 끝난 후 수집된 정보로 민원 등록
  Future<void> submitCollectedComplaint() async {
    if (complaintData.isEmpty) {
      Get.snackbar('알림', 'AI와 대화하여 민원 정보를 수집해주세요');
      return;
    }

    print('📤 수집된 민원 데이터로 제출: $complaintData');

    // LiveKit 연결 정리
    await _cleanupLiveKit();

    // 현재 위치 정보 가져오기 (권한 확인 포함)
    var currentPosition = _locationController.currentPosition.value;

    if (currentPosition == null) {
      print('⚠️ 위치 정보가 없습니다. 위치 권한을 확인합니다...');

      // 위치 권한 확인 및 요청
      final locationPermission = await Permission.location.status;

      if (locationPermission.isDenied) {
        print('📍 위치 권한 요청...');
        final result = await Permission.location.request();

        if (result.isGranted) {
          // 권한 획득 성공 → 위치 스트림이 자동으로 업데이트될 때까지 대기
          setState(() {
            statusMessage = '위치 정보를 가져오는 중...';
          });

          // LocationController의 위치 스트림이 업데이트될 때까지 대기
          await Future.delayed(const Duration(seconds: 2));
          currentPosition = _locationController.currentPosition.value;

          if (currentPosition != null) {
            print(
              '✅ 위치 획득 성공: ${currentPosition.latitude}, ${currentPosition.longitude}',
            );
          } else {
            print('⚠️ 위치 권한은 있지만 위치를 가져오지 못했습니다.');
          }
        } else if (result.isPermanentlyDenied) {
          print('⚠️ 위치 권한이 영구적으로 거부되었습니다.');
          Get.snackbar(
            '알림',
            '위치 권한이 필요합니다. 설정에서 권한을 허용해주세요.',
            duration: const Duration(seconds: 3),
          );
        }
      }
    }

    // 그래도 위치를 못 가져왔다면 서울시청 기본값 사용
    double latitude;
    double longitude;

    if (currentPosition == null) {
      print('⚠️ 위치를 가져올 수 없습니다. 서울시청을 기본값으로 사용합니다.');
      latitude = 37.5665; // 서울시청 위도
      longitude = 126.9780; // 서울시청 경도

      Get.snackbar(
        '알림',
        '위치를 가져올 수 없어 서울시청으로 설정됩니다',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } else {
      latitude = currentPosition.latitude;
      longitude = currentPosition.longitude;
    }

    print('📍 사용할 위치: $latitude, $longitude');

    try {
      // UI 업데이트
      setState(() {
        statusMessage = '주소를 가져오는 중...';
      });

      // Naver Maps API로 역지오코딩 (위도/경도 → 주소)
      final regionInfo = await Get.find<NaverMapsService>().reverseGeoCode(
        latitude,
        longitude,
      );

      print('🏠 주소 정보: ${regionInfo.fullAddressString()}');

      // UI 업데이트
      setState(() {
        statusMessage = '민원을 제출하는 중...';
      });

      // ComplaintController에 데이터가 이미 설정되어 있으므로
      // 위치 정보와 함께 submitComplaint 호출
      _complaintController.submitComplaint(regionInfo: regionInfo);

      // 화면 닫기 및 알림
      Get.offAll(() => RootPage());
      Get.snackbar(
        '성공',
        '민원이 성공적으로 제출되었습니다',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ 주소 변환 실패: $e');
      Get.snackbar('오류', '주소 정보를 가져올 수 없습니다');
      if (mounted) {
        setState(() {
          statusMessage = '버튼을 눌러 말씀해 주세요';
        });
      }
    }
  }

  /// 데이터 초기화
  void resetData() {
    transcribedText = '';
    complaintData.clear();
  }

  // 음성 스트리밍 중지
  Future<void> _stopListening() async {
    print('🎤 음성 인식 중지');

    setState(() {
      isListening = false;
      statusMessage = '처리 중...';
    });

    await _cleanupLiveKit();

    setState(() {
      statusMessage = '버튼을 눌러 말씀해 주세요';
    });
  }

  void _toggleListening() {
    if (isConnecting) return;

    if (isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // TODO: 커스텀 AppBar에도 X버튼 포함하도록 수정하기
      appBar: MindleTopAppBar(
        title: 'AI 음성 챗봇',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close).paddingOnly(right: 5),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      // AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   centerTitle: true,
      //   automaticallyImplyLeading: false, // 자동 뒤로가기 버튼 제거
      //   title: Text(
      //     'AI 음성 챗봇',
      //     style: MindleTextStyles.headline1(color: Colors.black),
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.close, color: Colors.black, size: 28),
      //       onPressed: () => Get.back(),
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          const SizedBox(height: 40),

          // 상단 텍스트
          Text(
            '반가워요.\n어떤 불편사항을 겪고 계신가요?',
            textAlign: TextAlign.center,
            style: MindleTextStyles.subtitle1(color: Colors.black),
          ),
          const Spacer(),

          // 마이크 버튼 영역
          Center(
            child: GestureDetector(
              onTap: _toggleListening,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // 바깥쪽 펄스 효과 (연한 초록색)
                      if (isListening)
                        Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 260,
                            height: 260,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MindleColors.mainGreen.withOpacity(0.1),
                            ),
                          ),
                        ),

                      // 중간 원 (더 진한 초록색)
                      if (isListening)
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: MindleColors.mainGreen.withOpacity(0.2),
                          ),
                        ),

                      // 마이크 버튼
                      Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF00D482),
                          boxShadow: [
                            BoxShadow(
                              color: MindleColors.mainGreen.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/microphone.svg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          const Spacer(),

          // 하단 안내 텍스트 (동적 상태 표시)
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                if (isConnecting)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF00D482),
                        ),
                      ),
                    ),
                  ),
                Text(
                  statusMessage,
                  style: MindleTextStyles.body3(color: MindleColors.gray8),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
