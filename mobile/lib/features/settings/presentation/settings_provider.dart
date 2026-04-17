import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/storage/app_storage.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  bool depremNotificationEnabled = true;
  bool aqiNotificationEnabled = true;
  double depremThreshold = 4.0;
  double aqiThreshold = 100.0;
  String refreshInterval = '15 dk';

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? ThemeMode.system.index];
    depremNotificationEnabled = prefs.getBool('depremNotificationEnabled') ?? true;
    aqiNotificationEnabled = prefs.getBool('aqiNotificationEnabled') ?? true;
    depremThreshold = prefs.getDouble('depremThreshold') ?? 4.0;
    aqiThreshold = prefs.getDouble('aqiThreshold') ?? 100.0;
    refreshInterval = prefs.getString('refreshInterval') ?? '15 dk';
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode value) async {
    themeMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', value.index);
  }

  Future<void> setDepremNotification(bool value) async {
    depremNotificationEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('depremNotificationEnabled', value);
  }

  Future<void> setAqiNotification(bool value) async {
    aqiNotificationEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('aqiNotificationEnabled', value);
  }

  Future<void> setDepremThreshold(double value) async {
    depremThreshold = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('depremThreshold', value);
  }

  Future<void> setAqiThreshold(double value) async {
    aqiThreshold = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('aqiThreshold', value);
  }

  Future<void> setRefreshInterval(String value) async {
    refreshInterval = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refreshInterval', value);
  }

  Future<void> clearCache() async {
    await AppStorage.instance.clearAll();
  }
}
