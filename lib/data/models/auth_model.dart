import './user_model.dart';

class Auth {
  String accessToken;
  String refreshToken;
  User user;

  Auth(
      {  required this.accessToken,
        required this.refreshToken,
        required this.user});

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      accessToken: json['access'],
      refreshToken: json['refresh'],
      user: User.fromJson(json['user']),
    );
  }
}
