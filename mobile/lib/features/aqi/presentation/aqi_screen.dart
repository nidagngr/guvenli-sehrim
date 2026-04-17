import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_keys.dart';
import 'aqi_provider.dart';

class AqiScreen extends StatelessWidget {
  const AqiScreen({super.key});

  Color _parseColor(String hex) => Color(int.parse(hex.replaceFirst('#', '0xFF')));

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AqiProvider>();
    final data = provider.data;
    return Scaffold(
      appBar: AppBar(title: const Text('Hava Kalitesi')),
      body: provider.isLoading && data == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          key: AppKeys.aqiColorIndicator,
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: _parseColor(data?.color ?? '#22C55E')),
                          alignment: Alignment.center,
                          child: Text('${data?.aqi ?? 0}', key: AppKeys.aqiValueText, style: Theme.of(context).textTheme.headlineMedium),
                        ),
                        const SizedBox(height: 12),
                        Text(data?.category ?? '-', key: AppKeys.aqiCategoryText, style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                ),
                Card(
                  key: AppKeys.aqiAdviceCard,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(data?.advice ?? 'Veri bekleniyor'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  key: AppKeys.aqiTrendChart,
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            for (var i = 0; i < (data?.trend.length ?? 0); i++) FlSpot(i.toDouble(), data!.trend[i].value),
                          ],
                          isCurved: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  key: AppKeys.aqiStationMap,
                  height: 220,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: FlutterMap(
                      options: const MapOptions(initialCenter: LatLng(41.0082, 28.9784), initialZoom: 10),
                      children: [
                        TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                        MarkerLayer(
                          markers: (data?.stations ?? [])
                              .map(
                                (item) => Marker(
                                  point: LatLng(item.lat, item.lon),
                                  width: 40,
                                  height: 40,
                                  child: Tooltip(
                                    message: item.name,
                                    child: const Icon(Icons.place, color: Colors.red),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
