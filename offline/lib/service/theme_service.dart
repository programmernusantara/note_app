import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDark') ?? false;
  }

  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', isDark);
  }
}
