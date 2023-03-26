import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:finantial_manager/Models/user.model.dart';
import 'package:finantial_manager/main.dart';
import 'package:finantial_manager/view-models/singin.viewmodel.dart';

import '../helpers/constantes.dart';
import '../view-models/login.viewmodel.dart';

class UserRepository {
  static Dio userDio = Dio();
  static Future<Response> register(SingInViewModel user) async {
    String url = "$urlAPI/api/Auth/register";
    print(jsonEncode(user.toJson()));
    return userDio.post(url, data: user.toJson());
  }

  static Future<Response> login(LoginViewModel user) async {
    String url = "$urlAPI/api/Auth/login";
    print(jsonEncode(user.toJson()));
    return userDio.post(url, data: user.toJson());
  }

  static verifyToken() {
    if (UserModel().expiresAt!.compareTo(DateTime.now()) < 0) {
      refreshToken();
    }
  }

  static refreshToken() async {
    String url = "$urlAPI/api/Auth/refreshToken";
    var cookies = localStorage.getString('set-cookie');
    var username = UserModel().username;
    var res = await userDio.post(url,
        data: jsonEncode(username),
        options: Options(
          headers: {"Cookie": cookies, "Content-Type": "application/json"},
        ));

    localStorage.setString(
        'set-cookie', res.headers['set-cookie']![0].toString());
    UserModel.destroy();
    UserModel.fromJson(res.data);
  }
}
