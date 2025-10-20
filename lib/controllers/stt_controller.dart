import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:mindle/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mindle/controllers/complaint_controller.dart';
import 'package:mindle/controllers/location_controller.dart';
import 'package:mindle/services/naver_maps_service.dart';
import 'dart:convert';

/// STT(Speech-to-Text) 컨트롤러
/// LiveKit을 사용한 실시간 음성 스트리밍 관리
class SttController extends GetxController {
  // 상태 관리
  final isListening = false.obs;
  final isConnecting = false.obs;
  final statusMessage = '버튼을 눌러 말씀해 주세요'.obs;

  // AI와의 대화 내용 수집
  final transcribedText = ''.obs; // 전체 대화 내용
  final complaintData = <String, String>{}.obs; // 수집된 민원 정보

  // Controller 참조
  ComplaintController get _complaintController =>
      Get.find<ComplaintController>();
  LocationController get _locationController => Get.find<LocationController>();

  // LiveKit 관련
  Room? _room;
  LocalAudioTrack? _localAudioTrack;
  EventsListener<RoomEvent>? _roomListener;

  @override
  void onInit() {
    super.onInit();
    _requestPermissions();
  }

  @override
  void onClose() {
    _cleanupLiveKit();
    super.onClose();
  }

  /// 마이크 권한 요청
  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
  }

  /// LiveKit 리소스 정리
  Future<void> _cleanupLiveKit() async {
    await _localAudioTrack?.stop();
    _localAudioTrack = null;

    _roomListener?.dispose();
    _roomListener = null;

    await _room?.disconnect();
    await _room?.dispose();
    _room = null;
  }

  /// 음성 인식 시작
  Future<void> startListening() async {
    if (isConnecting.value) return;

    isConnecting.value = true;
    statusMessage.value = '연결 중...';

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
          statusMessage.value = '듣고 있어요...';
        })
        ..on<RoomDisconnectedEvent>((_) {
          print('❌ LiveKit Room 연결 해제');
        })
        ..on<TrackPublishedEvent>((event) {
          print('✅ 트랙 발행됨: ${event.publication.sid}');
        })
        ..on<DataReceivedEvent>((event) {
          // Agent로부터 데이터 수신 (STT 결과 및 민원 정보)
          try {
            // UTF-8 디코딩 (한글 깨짐 방지)
            final dataString = utf8.decode(event.data);
            print('📥 데이터 수신: $dataString');

            // 전체 대화 내용 누적
            transcribedText.value += dataString + '\n';

            // JSON 형식으로 파싱 시도
            try {
              final jsonData = jsonDecode(dataString);
              _processComplaintData(jsonData);
            } catch (e) {
              // JSON이 아니면 일반 텍스트로 처리
              _processTextData(dataString);
            }
          } catch (e) {
            print('❌ 데이터 처리 오류: $e');
          }
        });

      // TODO: 실제 LiveKit 서버 URL과 토큰으로 변경 필요
      // 환경 변수나 백엔드 API에서 토큰 받아오기
      // const serverUrl = 'ws://your-livekit-server.com';
      // const token = 'your-token-here';
      // await _room!.connect(serverUrl, token);

      // 로컬 오디오 트랙 생성
      _localAudioTrack = await LocalAudioTrack.create(
        AudioCaptureOptions(
          echoCancellation: true,
          noiseSuppression: true,
          autoGainControl: true,
        ),
      );

      // 오디오 트랙 발행 (서버 연결 시)
      // await _room!.localParticipant?.publishAudioTrack(_localAudioTrack!);

      // 임시: 로컬에서만 마이크 활성화
      await _localAudioTrack?.start();

      isListening.value = true;
      isConnecting.value = false;
      statusMessage.value = '듣고 있어요...';

      print('🎤 음성 인식 시작');
    } catch (e) {
      print('❌ LiveKit 연결 실패: $e');
      isConnecting.value = false;
      statusMessage.value = '연결 실패: ${e.toString()}';

      // 3초 후 원래 메시지로 복구
      Future.delayed(const Duration(seconds: 3), () {
        statusMessage.value = '버튼을 눌러 말씀해 주세요';
      });
    }
  }

  /// 음성 인식 중지
  Future<void> stopListening() async {
    print('🎤 음성 인식 중지');

    isListening.value = false;
    statusMessage.value = '처리 중...';

    await _cleanupLiveKit();

    statusMessage.value = '버튼을 눌러 말씀해 주세요';
  }

  /// 음성 인식 토글
  void toggleListening() {
    if (isConnecting.value) return;

    if (isListening.value) {
      stopListening();
    } else {
      startListening();
    }
  }

  /// JSON 데이터 처리 (Agent가 구조화된 데이터를 보낼 경우)
  void _processComplaintData(Map<String, dynamic> data) {
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

    statusMessage.value = '민원 정보가 수집되었습니다';
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

    // 현재 위치 정보 가져오기
    final currentPosition = _locationController.currentPosition.value;

    if (currentPosition == null) {
      Get.snackbar('알림', '위치 정보를 가져올 수 없습니다');
      return;
    }

    print(
      '📍 현재 위치: ${currentPosition.latitude}, ${currentPosition.longitude}',
    );

    try {
      // Naver Maps API로 역지오코딩 (위도/경도 → 주소)
      statusMessage.value = '주소를 가져오는 중...';
      final regionInfo = await Get.find<NaverMapsService>().reverseGeoCode(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      print('🏠 주소 정보: ${regionInfo.fullAddressString()}');

      // ComplaintController에 데이터가 이미 설정되어 있으므로
      // 위치 정보와 함께 submitComplaint 호출
      _complaintController.submitComplaint(regionInfo: regionInfo);

      statusMessage.value = '민원이 제출되었습니다';

      Get.offAll(() => RootPage());
      Get.snackbar('알림', '민원이 제출되었습니다');
    } catch (e) {
      print('❌ 주소 변환 실패: $e');
      Get.snackbar('오류', '주소 정보를 가져올 수 없습니다');
      statusMessage.value = '버튼을 눌러 말씀해 주세요';
    }
  }

  /// 데이터 초기화
  void resetData() {
    transcribedText.value = '';
    complaintData.clear();
  }
}
