import 'package:finantial_manager/Models/user.model.dart';
import 'package:finantial_manager/views/login.view.dart';
import 'package:flutter/material.dart';
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
  bool teste = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Profile"),
        leading: Center(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            setCard("Name", UserModel().name),
            setCard("Username", UserModel().username),
            setCard("Email", UserModel().email),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget setCard(String label, String? value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          "$label: $value",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget setCardTheme() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Theme Mode",
              style: TextStyle(fontSize: 20),
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
    );
  }
}
