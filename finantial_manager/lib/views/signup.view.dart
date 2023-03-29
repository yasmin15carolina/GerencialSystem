import 'package:finantial_manager/controllers/user.controller.dart';
import 'package:finantial_manager/view-models/singin.viewmodel.dart';
import 'package:finantial_manager/widgets/dialogs.dart';
import 'package:finantial_manager/widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? validator(String? value) {
    return value!.isEmpty ? "Required Field" : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sing In"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextInputField(
                controller: txtName,
                label: "Name",
                validator: validator,
              ),
              TextInputField(
                controller: txtUsername,
                label: "Username",
                validator: validator,
              ),
              TextInputField(
                controller: txtEmail,
                label: "Email",
                validator: validator,
              ),
              TextInputField(
                obscure: true,
                controller: txtPassword,
                label: "Password",
                validator: (value) => value != txtConfirmPassword.text
                    ? "Different passwords"
                    : validator(value),
              ),
              TextInputField(
                obscure: true,
                controller: txtConfirmPassword,
                label: "Confim Password",
                validator: (value) => value != txtPassword.text
                    ? "Different passwords"
                    : validator(value),
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
                    if (_formKey.currentState!.validate()) {
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
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
