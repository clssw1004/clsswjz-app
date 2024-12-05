class TimeZone {
  static const List<Map<String, String>> supportedTimeZones = [
    {'code': 'Asia/Shanghai', 'label': '中国标准时间 (UTC+8)'},
    {'code': 'Asia/Taipei', 'label': '台北时间 (UTC+8)'},
    {'code': 'Asia/Tokyo', 'label': '东京时间 (UTC+9)'},
    {'code': 'America/New_York', 'label': '纽约时间 (UTC-5)'},
    {'code': 'Europe/London', 'label': '伦敦时间 (UTC+0)'},
    {'code': 'UTC', 'label': '协调世界时 (UTC)'},
    {'code': 'GMT', 'label': '格林尼治标准时间 (GMT)'},
  ];

  static String getLabelByCode(String code) {
    return supportedTimeZones.firstWhere(
      (tz) => tz['code'] == code,
      orElse: () => {'code': 'Asia/Shanghai', 'label': '中国标准时间 (UTC+8)'},
    )['label']!;
  }

  static String getDefaultTimeZone() {
    final systemZone = DateTime.now().timeZoneName;
    final hasZone = supportedTimeZones.any((tz) => tz['code'] == systemZone);
    return hasZone ? systemZone : 'Asia/Shanghai';
  }

  static bool isValidTimeZone(String code) {
    return supportedTimeZones.any((tz) => tz['code'] == code);
  }
}
