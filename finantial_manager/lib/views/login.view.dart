import 'package:finantial_manager/Models/user.model.dart';
import 'package:finantial_manager/controllers/user.controller.dart';
import 'package:finantial_manager/main.dart';
import 'package:finantial_manager/view-models/login.viewmodel.dart';
import 'package:finantial_manager/views/home.view.dart';
import 'package:finantial_manager/views/signup.view.dart';
import 'package:finantial_manager/widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../helpers/constantes.dart';
import '../widgets/dialogs.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController txtUsername = TextEditingController(text: "yasmin");
  TextEditingController txtPassword = TextEditingController(text: "123");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextInputField(
                controller: txtUsername,
                label: "Username",
              ),
              TextInputField(
                controller: txtPassword,
                label: "Password",
                obscure: true,
              ),
              FilledButton(
                  onPressed: () async {
                    await UserController.login(LoginViewModel(
                        username: txtUsername.text,
                        password: txtPassword.text));
                    if (errorMessage != "") {
                      print(errorMessage);
                      Dialogs.show(
                          title: "Error",
                          content: errorMessage,
                          context: context);
                      errorMessage = "";
                    } else {
                      print(UserModel().token);

                      localStorage.setString('username', txtUsername.text);
                      localStorage.setString('password', txtPassword.text);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeView(),
                          ));
                    }
                  },
                  child: const Text("Login")),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an Acount?",
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      child: const Text("Sing in now",
                          style: TextStyle(color: Colors.blue)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpView(),
                            ));
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
