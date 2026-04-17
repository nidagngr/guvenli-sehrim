import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_keys.dart';
import 'settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<ThemeMode>(
            key: AppKeys.ayarlarThemeDropdown,
            initialValue: provider.themeMode,
            decoration: const InputDecoration(labelText: 'Tema'),
            items: const [
              DropdownMenuItem(value: ThemeMode.system, child: Text('Sistem')),
              DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
              DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
            ],
            onChanged: (value) => provider.setThemeMode(value ?? ThemeMode.system),
          ),
          SwitchListTile(
            key: AppKeys.ayarlarDepremSwitch,
            value: provider.depremNotificationEnabled,
            onChanged: provider.setDepremNotification,
            title: const Text('Deprem bildirimi'),
          ),
          Slider(
            key: AppKeys.ayarlarDepremSlider,
            value: provider.depremThreshold,
            min: 3,
            max: 7,
            divisions: 8,
            label: provider.depremThreshold.toStringAsFixed(1),
            onChanged: provider.setDepremThreshold,
          ),
          SwitchListTile(
            key: AppKeys.ayarlarAqiSwitch,
            value: provider.aqiNotificationEnabled,
            onChanged: provider.setAqiNotification,
            title: const Text('AQI bildirimi'),
          ),
          Slider(
            key: AppKeys.ayarlarAqiSlider,
            value: provider.aqiThreshold,
            min: 50,
            max: 250,
            divisions: 8,
            label: provider.aqiThreshold.toStringAsFixed(0),
            onChanged: provider.setAqiThreshold,
          ),
          DropdownButtonFormField<String>(
            key: AppKeys.ayarlarRefreshDropdown,
            initialValue: provider.refreshInterval,
            decoration: const InputDecoration(labelText: 'Yenileme sikligi'),
            items: const ['5 dk', '15 dk', '30 dk', '60 dk']
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) => provider.setRefreshInterval(value ?? '15 dk'),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            key: AppKeys.ayarlarCacheClear,
            onPressed: provider.clearCache,
            child: const Text('Onbellek Temizle'),
          ),
        ],
      ),
    );
  }
}
