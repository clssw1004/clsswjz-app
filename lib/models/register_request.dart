import '../constants/language.dart';

class RegisterRequest {
  final String username;
  final String password;
  final String? nickname;
  final String? email;
  final String? phone;
  final Language? language;
  final String? timezone;

  RegisterRequest({
    required this.username,
    required this.password,
    this.nickname,
    this.email,
    this.phone,
    this.language,
    this.timezone,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        if (nickname != null) 'nickname': nickname,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (language != null) 'language': language!.code,
        if (timezone != null) 'timezone': timezone,
      };
}
