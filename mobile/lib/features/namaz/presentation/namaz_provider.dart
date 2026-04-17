import 'dart:async';

import 'package:flutter/material.dart';

import '../../settings/presentation/settings_provider.dart';
import '../domain/entities/namaz_gunu.dart';
import '../domain/repositories/namaz_repository.dart';

class NamazProvider extends ChangeNotifier {
  NamazProvider({
    required NamazRepository repository,
    required SettingsProvider settingsProvider,
  }) : _repository = repository {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        notifyListeners();
      }
    });
    load();
  }

  late NamazRepository _repository;
  late final Timer _ticker;

  NamazGunu? data;
  bool isLoading = false;
  bool isFromCache = false;
  String selectedCity = 'Istanbul';
  String? error;
  DateTime? lastUpdated;
  int remainingSeconds = 0;

  void bind({
    required NamazRepository repository,
    required SettingsProvider settingsProvider,
  }) {
    _repository = repository;
  }

  Future<void> load([String? city]) async {
    isLoading = true;
    error = null;
    if (city != null) selectedCity = city;
    notifyListeners();
    try {
      final response = await _repository.fetchPrayerTimes(selectedCity);
      data = response.data;
      remainingSeconds = data?.remainingSeconds ?? 0;
      isFromCache = response.fromCache;
      lastUpdated = response.lastUpdated;
    } catch (_) {
      error = 'Namaz verisi alinamadi.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String get formattedRemaining {
    final duration = Duration(seconds: remainingSeconds);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }
}
