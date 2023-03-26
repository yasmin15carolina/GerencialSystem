import 'package:finantial_manager/controllers/user.controller.dart';
import 'package:finantial_manager/view-models/singin.viewmodel.dart';
import 'package:finantial_manager/widgets/dialogs.dart';
import 'package:finantial_manager/widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SingInView extends StatefulWidget {
  const SingInView({super.key});

  @override
  State<SingInView> createState() => _SingInViewState();
}

class _SingInViewState extends State<SingInView> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sing In"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextInputField(
              controller: txtName,
              label: "Name",
            ),
            TextInputField(
              controller: txtUsername,
              label: "Username",
            ),
            TextInputField(
              controller: txtEmail,
              label: "Email",
            ),
            TextInputField(
              obscure: true,
              controller: txtPassword,
              label: "Password",
            ),
            TextInputField(
              obscure: true,
              controller: txtConfirmPassword,
              label: "Confim Password",
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Register",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                onPressed: () {
                  UserController.register(SingInViewModel(
                    name: txtName.text,
                    email: txtEmail.text,
                    username: txtUsername.text,
                    password: txtPassword.text,
                    confirmPassword: txtConfirmPassword.text,
                  ));
                  Navigator.pop(context);
                  Dialogs.showSucess(
                      title: "Sing In",
                      content: "Account Created!",
                      context: context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
