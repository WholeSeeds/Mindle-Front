class RegionInfo {
  final String si; // 시 (필수)
  final String? gu; // 구 (nullable)
  final String dong; // 동 (필수)
  final String? doroName; // 도로명 (nullable)
  final String? doroNumber; // 도로명 번호 (nullable)

  RegionInfo({
    required this.si,
    required this.dong,
    this.gu,
    this.doroName,
    this.doroNumber,
  });

  factory RegionInfo.fromNaverJson(Map<String, dynamic> data) {
    final results = data['results'] as List<dynamic>;

    // 시/구
    final siguStr = results[0]['region']['area2']['name'] as String;
    String si;
    String? gu;

    if (siguStr.contains(' ')) {
      final parts = siguStr.split(' ');
      si = parts[0];
      gu = parts[1];
    } else {
      si = siguStr;
      gu = null;
    }

    // 동
    final dong = results[0]['region']['area3']['name'] as String;

    // 도로명, 도로번호 (results 길이에 따라 존재할 수도, 없을 수도 있음)
    String? doroName;
    String? doroNumber;

    if (results.length >= 2) {
      doroName = results[1]['land']['name'] as String?;
      doroNumber = results[1]['land']['number1'] as String?;
    }

    return RegionInfo(
      si: si,
      gu: gu,
      dong: dong,
      doroName: doroName,
      doroNumber: doroNumber,
    );
  }

  @override
  String toString() {
    return 'RegionInfo(si: $si, gu: $gu, dong: $dong, doroName: $doroName, doroNumber: $doroNumber)';
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
