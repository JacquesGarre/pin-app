import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {

  static const String _settingsStorageKey = 'settings';

  Future<ThemeMode> themeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final String? theme = prefs.getString(_settingsStorageKey);
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    String themeString = 'system';
    switch (theme) {
      case ThemeMode.light:
        themeString = 'light';
      case ThemeMode.dark:
        themeString = 'dark';
      case ThemeMode.system:
      default:
        themeString = 'system';
    }
    await prefs.setString(_settingsStorageKey, themeString);
  }

}
