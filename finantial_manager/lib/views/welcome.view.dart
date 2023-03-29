import 'package:finantial_manager/Models/user.model.dart';
import 'package:finantial_manager/main.dart';
import 'package:finantial_manager/views/home.view.dart';
import 'package:finantial_manager/views/login.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/user.controller.dart';
import '../view-models/login.viewmodel.dart';

class WelcomeView extends StatefulWidget {
  @override
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () async {
      bool logged = localStorage.getString('username') != null &&
          localStorage.getString('username') != null;
      if (logged) {
        await UserController.login(LoginViewModel(
            username: localStorage.getString('username')!,
            password: localStorage.getString('password')!));
      }
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return Align(
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            pageBuilder: (context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                logged ? const HomeView() : const LoginView()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: const Center(
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.attach_money_outlined,
              size: 100,
            )
            // child: Text(
            //   "Welcome to the Finantial Manager APP",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 50),
            // ),
            ),
        // color: Colors.white,
        // child: Image.asset(
        //   "assets/images/logo.png",
        //   scale: 2,
        // ),
      ),
    );
  }
}
