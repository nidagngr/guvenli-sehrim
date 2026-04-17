import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../settings/presentation/settings_provider.dart';
import '../domain/entities/hava_durumu.dart';
import '../domain/repositories/hava_repository.dart';

class HavaProvider extends ChangeNotifier {
  HavaProvider({
    required HavaRepository repository,
    required SettingsProvider settingsProvider,
  }) : _repository = repository {
    _loadRecentSearches();
    load();
  }

  static const List<String> supportedCities = [
    'Adana',
    'Adiyaman',
    'Afyonkarahisar',
    'Agri',
    'Aksaray',
    'Amasya',
    'Ankara',
    'Antalya',
    'Ardahan',
    'Artvin',
    'Aydin',
    'Balikesir',
    'Bartin',
    'Batman',
    'Bayburt',
    'Bilecik',
    'Bingol',
    'Bitlis',
    'Bolu',
    'Burdur',
    'Bursa',
    'Canakkale',
    'Cankiri',
    'Corum',
    'Denizli',
    'Diyarbakir',
    'Duzce',
    'Edirne',
    'Elazig',
    'Erzincan',
    'Erzurum',
    'Eskisehir',
    'Gaziantep',
    'Giresun',
    'Gumushane',
    'Hakkari',
    'Hatay',
    'Igdir',
    'Isparta',
    'Istanbul',
    'Izmir',
    'Kahramanmaras',
    'Karabuk',
    'Karaman',
    'Kars',
    'Kastamonu',
    'Kayseri',
    'Kilis',
    'Kirikkale',
    'Kirklareli',
    'Kirsehir',
    'Kocaeli',
    'Konya',
    'Kutahya',
    'Malatya',
    'Manisa',
    'Mardin',
    'Mersin',
    'Mugla',
    'Mus',
    'Nevsehir',
    'Nigde',
    'Ordu',
    'Osmaniye',
    'Rize',
    'Sakarya',
    'Samsun',
    'Sanliurfa',
    'Siirt',
    'Sinop',
    'Sirnak',
    'Sivas',
    'Tekirdag',
    'Tokat',
    'Trabzon',
    'Tunceli',
    'Usak',
    'Van',
    'Yalova',
    'Yozgat',
    'Zonguldak',
  ];

  late HavaRepository _repository;
  Timer? _debounce;

  HavaDurumu? weather;
  bool isLoading = false;
  bool isFromCache = false;
  String selectedCity = 'Ankara';
  String searchQuery = 'Ankara';
  String? error;
  DateTime? lastUpdated;
  List<String> recentSearches = [];
  List<String> searchSuggestions = const [];

  void bind({
    required HavaRepository repository,
    required SettingsProvider settingsProvider,
  }) {
    _repository = repository;
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    recentSearches = prefs.getStringList('recent_weather_searches') ?? ['Istanbul', 'Bitlis', 'Izmir'];
    notifyListeners();
  }

  Future<void> _persistRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_weather_searches', recentSearches);
  }

  void onSearchChanged(String query) {
    searchQuery = query;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final normalized = query.trim().toLowerCase();
      if (normalized.isEmpty) {
        searchSuggestions = recentSearches.take(5).toList();
      } else {
        searchSuggestions = supportedCities
            .where((city) => city.toLowerCase().contains(normalized))
            .take(6)
            .toList();
      }
      notifyListeners();
    });
  }

  Future<void> search([String? rawCity]) async {
    final city = _normalizeCity(rawCity ?? searchQuery);
    if (city.isEmpty) {
      error = 'Lutfen bir sehir girin.';
      notifyListeners();
      return;
    }
    await load(city);
  }

  Future<void> load([String? city]) async {
    isLoading = true;
    error = null;
    if (city != null) {
      selectedCity = _normalizeCity(city);
      searchQuery = selectedCity;
    }
    notifyListeners();
    try {
      final response = await _repository.fetchWeather(selectedCity);
      weather = response.data;
      isFromCache = response.fromCache;
      lastUpdated = response.lastUpdated;
      _rememberSearch(selectedCity);
    } catch (_) {
      error = 'Hava verisi alinamadi.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _rememberSearch(String city) {
    recentSearches = [
      city,
      ...recentSearches.where((item) => item != city),
    ].take(5).toList();
    searchSuggestions = recentSearches;
    unawaited(_persistRecentSearches());
  }

  Future<void> useCurrentLocation() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        error = 'Konum izni verilmedi.';
        notifyListeners();
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      final city = placemarks.first.locality ?? placemarks.first.administrativeArea ?? 'Ankara';
      await load(city);
    } catch (_) {
      await load('Ankara');
    }
  }

  void toggleFavorite() {
    final city = selectedCity;
    if (weather == null) return;
    final favorites = [...weather!.favorites];
    if (favorites.contains(city)) {
      favorites.remove(city);
    } else {
      favorites.insert(0, city);
    }
    weather = HavaDurumu(
      city: weather!.city,
      temperature: weather!.temperature,
      feelsLike: weather!.feelsLike,
      humidity: weather!.humidity,
      windSpeed: weather!.windSpeed,
      pressure: weather!.pressure,
      description: weather!.description,
      icon: weather!.icon,
      hourly: weather!.hourly,
      daily: weather!.daily,
      favorites: favorites,
    );
    notifyListeners();
  }

  String _normalizeCity(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    final lower = trimmed.toLowerCase();
    for (final city in supportedCities) {
      if (city.toLowerCase() == lower) {
        return city;
      }
    }
    return '${trimmed[0].toUpperCase()}${trimmed.substring(1).toLowerCase()}';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
