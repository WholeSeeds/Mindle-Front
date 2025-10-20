import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:mindle/config/livekit_config.dart';

/// LiveKit JWT Token을 생성하는 서비스
/// 
/// ⚠️ 주의: 실제 프로덕션 환경에서는 반드시 백엔드에서 토큰을 생성해야 합니다!
/// API Secret을 클라이언트에 노출하면 안 됩니다.
class LiveKitTokenService {
  /// 임시 토큰 생성 (개발/테스트용)
  /// 
  /// 실제 배포 시에는 백엔드 API를 통해 토큰을 받아와야 합니다.
  static Future<String> generateToken({
    String? roomName,
    String? participantName,
    Duration? ttl,
  }) async {
    final apiKey = LiveKitConfig.apiKey;
    final apiSecret = LiveKitConfig.apiSecret;
    
    if (apiKey.isEmpty || apiSecret.isEmpty) {
      throw Exception('LiveKit API Key 또는 Secret이 설정되지 않았습니다');
    }

    final room = roomName ?? 'mindle-complaint-${DateTime.now().millisecondsSinceEpoch}';
    final identity = participantName ?? 'user-${DateTime.now().millisecondsSinceEpoch}';
    final expiration = DateTime.now().add(ttl ?? const Duration(hours: 1));

    // JWT Header
    final header = {
      'alg': 'HS256',
      'typ': 'JWT',
    };

    // JWT Payload
    final payload = {
      'iss': apiKey,
      'sub': identity,
      'exp': expiration.millisecondsSinceEpoch ~/ 1000,
      'nbf': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'video': {
        'room': room,
        'roomJoin': true,
        'canPublish': true,
        'canSubscribe': true,
        'canPublishData': true,
      },
    };

    // Base64URL 인코딩
    final headerBase64 = base64Url
        .encode(utf8.encode(json.encode(header)))
        .replaceAll('=', '');
    final payloadBase64 = base64Url
        .encode(utf8.encode(json.encode(payload)))
        .replaceAll('=', '');

    // 서명 생성
    final signatureInput = '$headerBase64.$payloadBase64';
    final hmac = Hmac(sha256, utf8.encode(apiSecret));
    final digest = hmac.convert(utf8.encode(signatureInput));
    final signatureBase64 = base64Url.encode(digest.bytes).replaceAll('=', '');

    // JWT 토큰 조합
    final token = '$headerBase64.$payloadBase64.$signatureBase64';

    print('🔑 토큰 생성 완료');
    print('   Room: $room');
    print('   Identity: $identity');
    print('   Expiration: $expiration');

    return token;
  }

  /// 백엔드 API에서 토큰 받아오기 (추후 구현)
  static Future<String> fetchTokenFromBackend({
    required String roomName,
    String? participantName,
  }) async {
    // TODO: 백엔드 API 호출
    // final response = await http.post(
    //   Uri.parse('https://your-backend.com/api/livekit/token'),
    //   body: {
    //     'room': roomName,
    //     'identity': participantName ?? 'user-${DateTime.now().millisecondsSinceEpoch}',
    //   },
    // );
    // return response.body;
    
    throw UnimplementedError('백엔드 API 연동 필요');
  }
}
