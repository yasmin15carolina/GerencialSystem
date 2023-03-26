import 'package:finantial_manager/Models/user.model.dart';
import 'package:finantial_manager/Repositories/user.repository.dart';
import 'package:finantial_manager/main.dart';
import 'package:finantial_manager/view-models/login.viewmodel.dart';
import 'package:finantial_manager/view-models/singin.viewmodel.dart';

class UserController {
  static void register(SingInViewModel user) async {
    final res = await UserRepository.register(user);
  }

  static Future<UserModel> login(LoginViewModel user) async {
    final res = await UserRepository.login(user);
    localStorage.setString(
        'set-cookie', res.headers['set-cookie']![0].toString());
    return UserModel.fromJson(res.data);
  }
}
