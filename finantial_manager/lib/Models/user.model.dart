import '../helpers/constantes.dart';

class UserModel {
  static UserModel? _instance;

  String? name;
  String? email;
  String? username;
  String? token;
  String? refreshToken;
  DateTime? expiresAt;

  UserModel._internal(
    this.name,
    this.email,
    this.username,
    this.token,
    this.refreshToken,
    this.expiresAt,
  );

  factory UserModel({
    String? name,
    String? email,
    String? username,
    String? token,
    String? refreshToken,
    DateTime? expiresAt,
  }) {
    _instance ??= UserModel._internal(
      name,
      email,
      username,
      token,
      refreshToken,
      expiresAt,
    );
    return _instance!;
  }

  static destroy() {
    _instance = null;
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    UserModel(
      name: json['name'],
      email: json['email'],
      username: json['username'],
      token: json['token'],
      refreshToken: json['refreshToken'],
      expiresAt: formatFromJson.parse(json['expiresAt']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['username'] = username;
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    data['expiresAt'] = expiresAt;
    return data;
  }
}
