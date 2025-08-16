class RegionInfo {
  final String si; // 시 (필수)
  final String? gu; // 구 (nullable)
  final String dong; // 동 (필수)
  final String? doroName; // 도로명 (nullable)
  final String? doroNumber; // 도로명 번호 (nullable)
  final double latitude; // 위도 (필수)
  final double longitude; // 경도 (필수)

  RegionInfo({
    required this.si,
    required this.dong,
    this.gu,
    this.doroName,
    this.doroNumber,
    required this.latitude,
    required this.longitude,
  });

  factory RegionInfo.empty() {
    return RegionInfo(
      si: '',
      gu: null,
      dong: '',
      doroName: null,
      doroNumber: null,
      latitude: 0.0,
      longitude: 0.0,
    );
  }

  factory RegionInfo.fromNaverJson(
    Map<String, dynamic> data, {
    required double latitude,
    required double longitude,
  }) {
    try {
      final results = data['results'];
      if (results is! List || results.isEmpty) {
        return RegionInfo.empty();
      }
      // 시/구
      final area2 = results[0]['region']?['area2'];
      final siguStr = area2 is Map ? area2['name'] as String? : null;
      String si = '';
      String? gu;
      if (siguStr != null && siguStr.contains(' ')) {
        final parts = siguStr.split(' ');
        si = parts[0];
        gu = parts[1];
      } else if (siguStr != null) {
        si = siguStr;
      }

      // 동
      final area3 = results[0]['region']?['area3'];
      final dong = area3 is Map ? area3['name'] as String? ?? '' : '';

      // 도로명, 도로번호 (results 길이에 따라 존재할 수도, 없을 수도 있음)
      String? doroName;
      String? doroNumber;
      if (results.length >= 2) {
        final land = results[1]['land'];
        if (land is Map) {
          doroName = land['name'] as String?;
          doroNumber = land['number1'] as String?;
        }
      }

      return RegionInfo(
        si: si,
        gu: gu,
        dong: dong,
        doroName: doroName,
        doroNumber: doroNumber,
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e) {
      print('RegionInfo.fromNaverJson 파싱 실패: $e');
      return RegionInfo.empty();
    }
  }

  @override
  String toString() {
    return 'RegionInfo(si: $si, gu: $gu, dong: $dong, doroName: $doroName, doroNumber: $doroNumber, latitude: $latitude, longitude: $longitude)';
  }

  String fullAddressString() {
    final parts = [si];
    if (gu != null) {
      parts.add(gu!);
    }
    parts.add(dong);
    if (doroName != null) {
      parts.add(doroName!);
    }
    if (doroNumber != null) {
      parts.add(doroNumber!);
    }
    return parts.join(' ');
  }
}
