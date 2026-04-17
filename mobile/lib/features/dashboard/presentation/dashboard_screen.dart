import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_keys.dart';
import '../../../core/widgets/info_card.dart';
import '../../aqi/presentation/aqi_provider.dart';
import '../../currency/presentation/doviz_provider.dart';
import '../../deprem/presentation/deprem_provider.dart';
import '../../namaz/presentation/namaz_provider.dart';
import '../../weather/presentation/hava_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({required this.onNavigate, super.key});

  final ValueChanged<int> onNavigate;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await Future.wait([
        context.read<DepremProvider>().load(),
        context.read<HavaProvider>().load(),
        context.read<AqiProvider>().load(),
        context.read<NamazProvider>().load(),
        context.read<DovizProvider>().load(),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final deprem = context.watch<DepremProvider>();
    final hava = context.watch<HavaProvider>();
    final aqi = context.watch<AqiProvider>();
    final namaz = context.watch<NamazProvider>();
    final doviz = context.watch<DovizProvider>();
    final offline = deprem.isFromCache || hava.isFromCache || aqi.isFromCache || namaz.isFromCache || doviz.isFromCache;
    final lastUpdated = [
      deprem.lastUpdated,
      hava.lastUpdated,
      aqi.lastUpdated,
      namaz.lastUpdated,
      doviz.lastUpdated,
    ].whereType<DateTime>().fold<DateTime?>(null, (previous, current) {
      if (previous == null) return current;
      return current.isAfter(previous) ? current : previous;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guvenli Sehirim'),
        actions: [
          IconButton(
            key: AppKeys.dashboardRefresh,
            onPressed: () async {
              await Future.wait([
                deprem.load(),
                hava.load(),
                aqi.load(),
                namaz.load(),
                doviz.load(),
              ]);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([deprem.load(), hava.load(), aqi.load(), namaz.load(), doviz.load()]);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              hava.weather?.city ?? namaz.selectedCity,
              key: AppKeys.dashboardKonumText,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (offline)
              Container(
                key: AppKeys.dashboardOfflineBanner,
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  lastUpdated == null
                      ? 'Offline veri gosteriliyor. Son kayitli veriler kullanildi.'
                      : 'Offline veri gosteriliyor. Son guncelleme ${DateFormat('dd.MM HH:mm').format(lastUpdated)}.',
                ),
              ),
            const SizedBox(height: 16),
            InfoCard(
              cardKey: AppKeys.dashboardDepremCard,
              title: 'Deprem',
              subtitle: 'AFAD son olaylar',
              onTap: () => widget.onNavigate(1),
              child: Text(
                deprem.filtered.isEmpty
                    ? deprem.items.isEmpty
                        ? 'Veri yok'
                        : 'Son 24 saatte kayit yok'
                    : 'Son ${deprem.filtered.length} kayit, en buyuk M${deprem.filtered.first.magnitude.toStringAsFixed(1)}',
              ),
            ),
            InfoCard(
              cardKey: AppKeys.dashboardHavaCard,
              title: 'Hava',
              subtitle: hava.lastUpdated != null ? 'Guncel: ${DateFormat.Hm().format(hava.lastUpdated!)}' : null,
              onTap: () => widget.onNavigate(2),
              child: Text(
                hava.weather == null ? 'Veri yok' : '${hava.weather!.temperature.toStringAsFixed(0)} C | ${hava.weather!.description}',
              ),
            ),
            InfoCard(
              cardKey: AppKeys.dashboardAqiCard,
              title: 'AQI',
              subtitle: 'Istanbul istasyonlari',
              onTap: () => widget.onNavigate(3),
              child: Text(aqi.data == null ? 'Veri yok' : '${aqi.data!.aqi} | ${aqi.data!.category}'),
            ),
            InfoCard(
              cardKey: AppKeys.dashboardNamazCard,
              title: 'Namaz',
              subtitle: namaz.data?.city ?? 'Istanbul',
              onTap: () => widget.onNavigate(4),
              child: Text(namaz.data == null ? 'Veri yok' : '${namaz.data!.nextPrayer} icin ${namaz.formattedRemaining}'),
            ),
            InfoCard(
              cardKey: AppKeys.dashboardDovizCard,
              title: 'Doviz',
              subtitle: doviz.data?.date,
              onTap: () => widget.onNavigate(5),
              child: Text(
                doviz.data == null || doviz.data!.rates.isEmpty
                    ? 'Veri yok'
                    : 'USD ${doviz.data!.rates.first.sell.toStringAsFixed(2)} TL',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
