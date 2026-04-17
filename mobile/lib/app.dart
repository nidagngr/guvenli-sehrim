import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/settings/presentation/settings_provider.dart';
import 'features/shell/presentation/home_shell.dart';

class GuvenliSehirimApp extends StatelessWidget {
  const GuvenliSehirimApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return MaterialApp(
      title: 'Guvenli Sehirim',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomeShell(),
    );
  }
}
