import 'package:flutter/material.dart';

import '../../../core/notifications/app_notification_service.dart';
import '../../settings/presentation/settings_provider.dart';
import '../domain/entities/deprem.dart';
import '../domain/repositories/deprem_repository.dart';

class DepremProvider extends ChangeNotifier {
  DepremProvider({
    required DepremRepository repository,
    required SettingsProvider settingsProvider,
  })  : _repository = repository,
        _settingsProvider = settingsProvider {
    load();
  }

  late DepremRepository _repository;
  late SettingsProvider _settingsProvider;

  List<Deprem> items = [];
  bool isLoading = false;
  bool isFromCache = false;
  String? error;
  DateTime? lastUpdated;
  double minMagnitude = 0;
  String region = 'Tum';
  String timeRange = '24 Saat';

  void bind({
    required DepremRepository repository,
    required SettingsProvider settingsProvider,
  }) {
    _repository = repository;
    _settingsProvider = settingsProvider;
  }

  List<Deprem> get filtered {
    final cutoff = switch (timeRange) {
      '6 Saat' => DateTime.now().subtract(const Duration(hours: 6)),
      '12 Saat' => DateTime.now().subtract(const Duration(hours: 12)),
      _ => DateTime.now().subtract(const Duration(hours: 24)),
    };
    return items.where((item) {
      final regionPass = region == 'Tum' || item.province == region;
      return item.magnitude >= minMagnitude && regionPass && item.date.isAfter(cutoff);
    }).toList();
  }

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final response = await _repository.fetchEarthquakes();
      items = response.data;
      isFromCache = response.fromCache;
      lastUpdated = response.lastUpdated;
      final strongest = items.isEmpty ? 0.0 : items.map((item) => item.magnitude).reduce((a, b) => a > b ? a : b);
      if (_settingsProvider.depremNotificationEnabled && strongest >= _settingsProvider.depremThreshold) {
        await AppNotificationService.instance.showThresholdNotification(
          id: 1,
          title: 'Deprem esigi asildi',
          body: 'En yuksek deprem ${strongest.toStringAsFixed(1)} olarak goruldu.',
        );
      }
    } catch (err) {
      error = 'Deprem verisi alinamadi.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setMinMagnitude(double value) {
    minMagnitude = value;
    notifyListeners();
  }

  void setRegion(String value) {
    region = value;
    notifyListeners();
  }

  void setTimeRange(String value) {
    timeRange = value;
    notifyListeners();
  }
}
