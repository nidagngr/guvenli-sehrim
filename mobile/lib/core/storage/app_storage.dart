import 'package:hive_flutter/hive_flutter.dart';

import '../network/app_api_client.dart';

class AppStorage {
  AppStorage._();

  static final AppStorage instance = AppStorage._();

  final apiClient = AppApiClient();

  late final Box<dynamic> depremBox;
  late final Box<dynamic> havaBox;
  late final Box<dynamic> aqiBox;
  late final Box<dynamic> namazBox;
  late final Box<dynamic> dovizBox;

  Future<void> initialize() async {
    depremBox = await Hive.openBox<dynamic>('deprem_box');
    havaBox = await Hive.openBox<dynamic>('hava_box');
    aqiBox = await Hive.openBox<dynamic>('aqi_box');
    namazBox = await Hive.openBox<dynamic>('namaz_box');
    dovizBox = await Hive.openBox<dynamic>('doviz_box');
  }

  Future<void> clearAll() async {
    await Future.wait([
      depremBox.clear(),
      havaBox.clear(),
      aqiBox.clear(),
      namazBox.clear(),
      dovizBox.clear(),
    ]);
  }
}
