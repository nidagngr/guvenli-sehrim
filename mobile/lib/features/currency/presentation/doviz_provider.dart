import 'package:flutter/material.dart';

import '../../settings/presentation/settings_provider.dart';
import '../domain/entities/doviz_gunu.dart';
import '../domain/repositories/doviz_repository.dart';

class DovizProvider extends ChangeNotifier {
  DovizProvider({
    required DovizRepository repository,
    required SettingsProvider settingsProvider,
  }) : _repository = repository {
    load();
  }

  late DovizRepository _repository;

  DovizGunu? data;
  bool isLoading = false;
  bool isFromCache = false;
  String? error;
  DateTime? lastUpdated;
  String favorite = 'USD';

  void bind({
    required DovizRepository repository,
    required SettingsProvider settingsProvider,
  }) {
    _repository = repository;
  }

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final response = await _repository.fetchRates();
      data = response.data;
      isFromCache = response.fromCache;
      lastUpdated = response.lastUpdated;
    } catch (_) {
      error = 'Doviz verisi alinamadi.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setFavorite(String value) {
    favorite = value;
    notifyListeners();
  }
}
