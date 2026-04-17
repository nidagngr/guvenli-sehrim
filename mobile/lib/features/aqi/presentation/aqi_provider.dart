import 'package:flutter/material.dart';

import '../../../core/notifications/app_notification_service.dart';
import '../../settings/presentation/settings_provider.dart';
import '../domain/entities/hava_kalitesi.dart';
import '../domain/repositories/aqi_repository.dart';

class AqiProvider extends ChangeNotifier {
  AqiProvider({
    required AqiRepository repository,
    required SettingsProvider settingsProvider,
  })  : _repository = repository,
        _settingsProvider = settingsProvider {
    load();
  }

  late AqiRepository _repository;
  late SettingsProvider _settingsProvider;

  HavaKalitesi? data;
  bool isLoading = false;
  bool isFromCache = false;
  String? error;
  DateTime? lastUpdated;

  void bind({
    required AqiRepository repository,
    required SettingsProvider settingsProvider,
  }) {
    _repository = repository;
    _settingsProvider = settingsProvider;
  }

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final response = await _repository.fetchAqi();
      data = response.data;
      isFromCache = response.fromCache;
      lastUpdated = response.lastUpdated;
      if (_settingsProvider.aqiNotificationEnabled && (data?.aqi ?? 0) >= _settingsProvider.aqiThreshold.round()) {
        await AppNotificationService.instance.showThresholdNotification(
          id: 2,
          title: 'AQI esigi asildi',
          body: 'Hava kalitesi indeksi ${data?.aqi} olarak olculdu.',
        );
      }
    } catch (_) {
      error = 'AQI verisi alinamadi.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
