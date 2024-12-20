class User {
  final String id;
  final String username;
  final String? nickname;
  final String? email;
  final String? phone;
  final String? inviteCode;
  final String? language;
  final String? timezone;
  final UserStats stats;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    this.nickname,
    this.email,
    this.phone,
    this.inviteCode,
    this.language,
    this.timezone,
    required this.createdAt,
    required this.updatedAt,
    required this.stats,
  });

  User copyWith({
    String? id,
    String? username,
    String? nickname,
    String? email,
    String? phone,
    String? inviteCode,
    String? language,
    String? timezone,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserStats? stats,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      inviteCode: inviteCode ?? this.inviteCode,
      language: language ?? this.language,
      timezone: timezone ?? this.timezone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stats: stats ?? this.stats,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'nickname': nickname,
        'email': email,
        'phone': phone,
        'inviteCode': inviteCode,
        'language': language,
        'timezone': timezone,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'stats': stats.toJson(),
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        nickname: json['nickname'],
        email: json['email'],
        phone: json['phone'],
        inviteCode: json['inviteCode'],
        language: json['language'],
        timezone: json['timezone'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        stats: UserStats.fromJson(json['stats']),
      );
}

class UserStats {
  final int totalItems;
  final int totalDays;
  final double totalFunds;

  UserStats({
    required this.totalItems,
    required this.totalDays,
    required this.totalFunds,
  });
  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats(
        totalItems: json['totalItems'],
        totalDays: json['totalDays'],
        totalFunds: json['totalFunds'],
      );
  Map<String, dynamic> toJson() => {
        'totalItems': totalItems,
        'totalDays': totalDays,
        'totalFunds': totalFunds,
      };
}
