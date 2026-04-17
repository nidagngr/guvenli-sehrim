import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_keys.dart';
import '../../aqi/presentation/aqi_screen.dart';
import '../../currency/presentation/doviz_screen.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../../deprem/presentation/deprem_screen.dart';
import '../../namaz/presentation/namaz_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../weather/presentation/hava_screen.dart';
import 'shell_provider.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late final List<Widget> _pages = [
    DashboardScreen(onNavigate: _goTo),
    const DepremScreen(),
    const HavaScreen(),
    const AqiScreen(),
    const NamazScreen(),
    const DovizScreen(),
    const SettingsScreen(),
  ];

  void _goTo(int index) {
    context.read<ShellProvider>().setIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final shell = context.watch<ShellProvider>();
    return Scaffold(
      body: IndexedStack(index: shell.currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: _goTo,
        destinations: const [
          NavigationDestination(
            key: AppKeys.navDashboard,
            icon: Icon(Icons.dashboard_outlined),
            label: 'Panel',
          ),
          NavigationDestination(
            key: AppKeys.navDeprem,
            icon: Icon(Icons.public),
            label: 'Deprem',
          ),
          NavigationDestination(
            key: AppKeys.navHava,
            icon: Icon(Icons.wb_sunny_outlined),
            label: 'Hava',
          ),
          NavigationDestination(
            key: AppKeys.navAqi,
            icon: Icon(Icons.air),
            label: 'AQI',
          ),
          NavigationDestination(
            key: AppKeys.navNamaz,
            icon: Icon(Icons.schedule),
            label: 'Namaz',
          ),
          NavigationDestination(
            key: AppKeys.navDoviz,
            icon: Icon(Icons.currency_exchange),
            label: 'Doviz',
          ),
          NavigationDestination(
            key: AppKeys.navAyarlar,
            icon: Icon(Icons.settings_outlined),
            label: 'Ayarlar',
          ),
        ],
      ),
    );
  }
}
