import 'package:finantial_manager/Models/user.model.dart';
import 'package:finantial_manager/Repositories/user.repository.dart';
import 'package:finantial_manager/helpers/constantes.dart';
import 'package:finantial_manager/main.dart';
import 'package:finantial_manager/view-models/login.viewmodel.dart';
import 'package:finantial_manager/view-models/singin.viewmodel.dart';

class UserController {
  static void register(SingInViewModel user) async {
    final res = await UserRepository.register(user);
  }

  static Future login(LoginViewModel user) async {
    final res = await UserRepository.login(user);
    if (res.statusCode == 200) {
      localStorage.setString(
          'set-cookie', res.headers['set-cookie']![0].toString());
      UserModel.fromJson(res.data);
    } else {
      errorMessage = res.data['message'];
    }
  }
}
