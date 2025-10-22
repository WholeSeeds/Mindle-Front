import 'package:flutter_dotenv/flutter_dotenv.dart';

/// LiveKit 서버 설정
///
/// 환경 변수(.env 파일)에서 설정을 읽어옵니다.
/// .env.example 파일을 참고하여 .env 파일을 생성하세요.
class LiveKitConfig {
  /// LiveKit 서버 URL (.env에서 로드)
  /// 예: wss://your-project.livekit.cloud
  static String get serverUrl =>
      dotenv.env['LIVEKIT_SERVER_URL'] ?? 'ws://localhost:7880';

  /// LiveKit API 키 (.env에서 로드)
  static String get apiKey => dotenv.env['LIVEKIT_API_KEY'] ?? 'your-api-key';

  /// LiveKit API Secret (.env에서 로드)
  static String get apiSecret =>
      dotenv.env['LIVEKIT_API_SECRET'] ?? 'your-api-secret';

  // 개발 모드 플래그
  static const bool isDevelopment = true;

  /// LiveKit 서버가 설정되었는지 확인
  static bool get isConfigured {
    return serverUrl != 'ws://localhost:7880' &&
        apiKey != 'your-api-key' &&
        apiSecret != 'your-api-secret';
  }

  /// 설정 상태 출력
  static void printStatus() {
    print('🔧 LiveKit 설정 상태:');
    print('  - Server URL: $serverUrl');
    if (apiKey.length > 10) {
      print('  - API Key: ${apiKey.substring(0, 10)}...');
    } else {
      print('  - API Key: $apiKey');
    }
    print('  - Configured: ${isConfigured ? "✅" : "❌"}');
  }
}
