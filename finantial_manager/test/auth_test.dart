import 'dart:io';

import 'package:finantial_manager/Models/user.model.dart';
import 'package:finantial_manager/controllers/user.controller.dart';
import 'package:finantial_manager/view-models/login.viewmodel.dart';
import 'package:finantial_manager/view-models/singin.viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  group("Auth", () {
    UserModel teste;
    test('Login', () async {
      teste = await UserController.login(
          LoginViewModel(username: "yasmin", password: "123"));
      print(teste.token);
      print(teste.email);
    });

    // test('Register', () {
    //   RegisterUserViewModel user = RegisterUserViewModel(
    //     name: "Carol",
    //     email: "carolina@gmail.com",
    //     username: "carolina",
    //     password: "123",
    //     confirmPassword: "123",
    //   );
    //   UserController.register(user);
    // });
  });
}

//apenas para rodar a api local
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
