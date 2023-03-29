import 'package:finantial_manager/Models/user.model.dart';
import 'package:finantial_manager/views/login.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../main.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      // Thumb icon when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.nights_stay);
      }
      return const Icon(Icons.sunny);
    },
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        leading: Center(),
      ),
      body: ListView(
        children: [
          setCardUser("Name", UserModel().name),
          setCardUser("Username", UserModel().username),
          setCardUser("Email", UserModel().email),
          setCardTheme(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  child: const Text("Logout"),
                  onPressed: () {
                    UserModel.destroy();
                    localStorage.clear();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginView(),
                    ));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget setCardUser(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "$label: $value",
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget setCardTheme() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Theme Mode",
                style: const TextStyle(fontSize: 20),
              ),
              Switch(
                thumbIcon: thumbIcon,
                value: themeManager.themeMode == ThemeMode.dark,
                onChanged: (bool value) {
                  setState(() {
                    themeManager.toggleTheme(value);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
