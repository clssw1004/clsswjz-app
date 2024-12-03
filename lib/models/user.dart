class User {
  final String id;
  final String username;
  final String? nickname;
  final String? email;
  final String? phone;
  final String? inviteCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    this.nickname,
    this.email,
    this.phone,
    this.inviteCode,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    String? id,
    String? username,
    String? nickname,
    String? email,
    String? phone,
    String? inviteCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      inviteCode: inviteCode ?? this.inviteCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'nickname': nickname,
        'email': email,
        'phone': phone,
        'inviteCode': inviteCode,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        nickname: json['nickname'],
        email: json['email'],
        phone: json['phone'],
        inviteCode: json['inviteCode'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}
