import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode =
      SchedulerBinding.instance.window.platformBrightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light;

  get themeMode => _themeMode;

  toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
