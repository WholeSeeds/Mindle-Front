import 'package:livekit_client/livekit_client.dart';
import 'package:mindle/config/livekit_config.dart';

/// LiveKit 서비스 설정 및 관리
class LiveKitService {
  // LiveKitConfig에서 서버 정보 가져오기
  static String get serverUrl => LiveKitConfig.serverUrl;
  static const String defaultToken = 'your-token-here'; // 백엔드 API에서 받아와야 함

  /// LiveKit Room 생성 및 연결
  ///
  /// [url] LiveKit 서버 URL (기본값: serverUrl)
  /// [token] 인증 토큰 (기본값: defaultToken)
  /// [roomName] 방 이름 (선택)
  static Future<Room> createAndConnectRoom({
    String? url,
    String? token,
    String? roomName,
  }) async {
    final room = Room();

    // Room 옵션 설정
    final roomOptions = RoomOptions(
      adaptiveStream: true,
      dynacast: true,
      defaultAudioCaptureOptions: const AudioCaptureOptions(
        echoCancellation: true,
        noiseSuppression: true,
        autoGainControl: true,
      ),
    );

    // 연결
    await room.connect(
      url ?? serverUrl,
      token ?? defaultToken,
      roomOptions: roomOptions,
    );

    return room;
  }

  /// 로컬 오디오 트랙 생성
  static Future<LocalAudioTrack> createAudioTrack({
    bool echoCancellation = true,
    bool noiseSuppression = true,
    bool autoGainControl = true,
  }) async {
    return await LocalAudioTrack.create(
      AudioCaptureOptions(
        echoCancellation: echoCancellation,
        noiseSuppression: noiseSuppression,
        autoGainControl: autoGainControl,
      ),
    );
  }

  /// Room 정리
  static Future<void> cleanupRoom(Room? room) async {
    await room?.disconnect();
    await room?.dispose();
  }

  /// 오디오 트랙 정리
  static Future<void> cleanupAudioTrack(LocalAudioTrack? track) async {
    await track?.stop();
  }
}
