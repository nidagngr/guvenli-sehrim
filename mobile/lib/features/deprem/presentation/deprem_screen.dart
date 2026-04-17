import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_keys.dart';
import 'deprem_provider.dart';

class DepremScreen extends StatelessWidget {
  const DepremScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DepremProvider>();
    final regions = ['Tum', ...provider.items.map((item) => item.province).toSet()];
    return Scaffold(
      appBar: AppBar(title: const Text('Deprem')),
      body: provider.isLoading && provider.items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        key: AppKeys.depremFilterRegion,
                        initialValue: provider.region,
                        items: regions.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                        onChanged: (value) => provider.setRegion(value ?? 'Tum'),
                        decoration: const InputDecoration(labelText: 'Bolge'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        key: AppKeys.depremFilterTime,
                        initialValue: provider.timeRange,
                        items: const ['6 Saat', '12 Saat', '24 Saat']
                            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                            .toList(),
                        onChanged: (value) => provider.setTimeRange(value ?? '24 Saat'),
                        decoration: const InputDecoration(labelText: 'Zaman'),
                      ),
                    ),
                  ],
                ),
                Slider(
                  key: AppKeys.depremFilterMagnitude,
                  value: provider.minMagnitude,
                  min: 0,
                  max: 7,
                  divisions: 14,
                  label: provider.minMagnitude.toStringAsFixed(1),
                  onChanged: provider.setMinMagnitude,
                ),
                Card(
                  key: AppKeys.depremStats,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Filtreli kayit: ${provider.filtered.length} • Son guncelleme: ${provider.lastUpdated != null ? DateFormat.Hm().format(provider.lastUpdated!) : '-'}'),
                  ),
                ),
                SizedBox(
                  key: AppKeys.depremMap,
                  height: 220,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: provider.filtered.isEmpty
                            ? const LatLng(39.0, 35.0)
                            : LatLng(provider.filtered.first.latitude, provider.filtered.first.longitude),
                        initialZoom: 5.2,
                      ),
                      children: [
                        TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                        MarkerLayer(
                          markers: provider.filtered
                              .map(
                                (item) => Marker(
                                  point: LatLng(item.latitude, item.longitude),
                                  width: 36,
                                  height: 36,
                                  child: Icon(
                                    Icons.location_on,
                                    color: item.magnitude >= 5 ? Colors.red : item.magnitude >= 4 ? Colors.orange : Colors.green,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  key: AppKeys.depremList,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.filtered.length,
                  itemBuilder: (context, index) {
                    final item = provider.filtered[index];
                    return ListTile(
                      key: Key('deprem_item_$index'),
                      title: Text('${item.province} ${item.district}'.trim()),
                      subtitle: Text(DateFormat('dd.MM.yyyy HH:mm').format(item.date)),
                      trailing: Text('M${item.magnitude.toStringAsFixed(1)}'),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
