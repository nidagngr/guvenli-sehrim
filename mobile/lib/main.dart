import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/notifications/app_notification_service.dart';
import 'core/storage/app_storage.dart';
import 'features/aqi/data/aqi_repository_impl.dart';
import 'features/aqi/domain/repositories/aqi_repository.dart';
import 'features/aqi/presentation/aqi_provider.dart';
import 'features/currency/data/doviz_repository_impl.dart';
import 'features/currency/domain/repositories/doviz_repository.dart';
import 'features/currency/presentation/doviz_provider.dart';
import 'features/deprem/data/deprem_repository_impl.dart';
import 'features/deprem/domain/repositories/deprem_repository.dart';
import 'features/deprem/presentation/deprem_provider.dart';
import 'features/namaz/data/namaz_repository_impl.dart';
import 'features/namaz/domain/repositories/namaz_repository.dart';
import 'features/namaz/presentation/namaz_provider.dart';
import 'features/settings/presentation/settings_provider.dart';
import 'features/shell/presentation/shell_provider.dart';
import 'features/weather/data/hava_repository_impl.dart';
import 'features/weather/domain/repositories/hava_repository.dart';
import 'features/weather/presentation/hava_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await AppNotificationService.instance.initialize();
  await AppStorage.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShellProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()..initialize()),
        Provider<DepremRepository>(
          create: (_) => DepremRepositoryImpl(
            client: AppStorage.instance.apiClient,
            box: AppStorage.instance.depremBox,
          ),
        ),
        Provider<HavaRepository>(
          create: (_) => HavaRepositoryImpl(
            client: AppStorage.instance.apiClient,
            box: AppStorage.instance.havaBox,
          ),
        ),
        Provider<AqiRepository>(
          create: (_) => AqiRepositoryImpl(
            client: AppStorage.instance.apiClient,
            box: AppStorage.instance.aqiBox,
          ),
        ),
        Provider<NamazRepository>(
          create: (_) => NamazRepositoryImpl(
            client: AppStorage.instance.apiClient,
            box: AppStorage.instance.namazBox,
          ),
        ),
        Provider<DovizRepository>(
          create: (_) => DovizRepositoryImpl(
            client: AppStorage.instance.apiClient,
            box: AppStorage.instance.dovizBox,
          ),
        ),
        ChangeNotifierProxyProvider2<DepremRepository, SettingsProvider, DepremProvider>(
          create: (context) => DepremProvider(
            repository: context.read<DepremRepository>(),
            settingsProvider: context.read<SettingsProvider>(),
          ),
          update: (_, repository, settings, provider) =>
              provider!..bind(repository: repository, settingsProvider: settings),
        ),
        ChangeNotifierProxyProvider2<HavaRepository, SettingsProvider, HavaProvider>(
          create: (context) => HavaProvider(
            repository: context.read<HavaRepository>(),
            settingsProvider: context.read<SettingsProvider>(),
          ),
          update: (_, repository, settings, provider) =>
              provider!..bind(repository: repository, settingsProvider: settings),
        ),
        ChangeNotifierProxyProvider2<AqiRepository, SettingsProvider, AqiProvider>(
          create: (context) => AqiProvider(
            repository: context.read<AqiRepository>(),
            settingsProvider: context.read<SettingsProvider>(),
          ),
          update: (_, repository, settings, provider) =>
              provider!..bind(repository: repository, settingsProvider: settings),
        ),
        ChangeNotifierProxyProvider2<NamazRepository, SettingsProvider, NamazProvider>(
          create: (context) => NamazProvider(
            repository: context.read<NamazRepository>(),
            settingsProvider: context.read<SettingsProvider>(),
          ),
          update: (_, repository, settings, provider) =>
              provider!..bind(repository: repository, settingsProvider: settings),
        ),
        ChangeNotifierProxyProvider2<DovizRepository, SettingsProvider, DovizProvider>(
          create: (context) => DovizProvider(
            repository: context.read<DovizRepository>(),
            settingsProvider: context.read<SettingsProvider>(),
          ),
          update: (_, repository, settings, provider) =>
              provider!..bind(repository: repository, settingsProvider: settings),
        ),
      ],
      child: const GuvenliSehirimApp(),
    ),
  );
}
