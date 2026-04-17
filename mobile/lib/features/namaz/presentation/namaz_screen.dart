import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_keys.dart';
import 'namaz_provider.dart';

class NamazScreen extends StatelessWidget {
  const NamazScreen({super.key});

  String _timeByName(NamazProvider provider, String name) {
    for (final item in provider.data?.times ?? const []) {
      if (item.name == name) {
        return item.time;
      }
    }
    return '--:--';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NamazProvider>();
    final data = provider.data;
    const cities = ['Istanbul', 'Ankara', 'Izmir', 'Bursa'];

    return Scaffold(
      appBar: AppBar(title: const Text('Namaz Vakitleri')),
      body: provider.isLoading && data == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<String>(
                  key: AppKeys.namazCityDropdown,
                  initialValue: provider.selectedCity,
                  items: cities.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                  onChanged: (value) => provider.load(value ?? 'Istanbul'),
                  decoration: const InputDecoration(labelText: 'Sehir'),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Yaklasan vakit: ${data?.nextPrayer ?? '-'}', key: AppKeys.namazYaklasanVakit),
                        const SizedBox(height: 8),
                        Text(
                          provider.formattedRemaining,
                          key: AppKeys.namazKalanSure,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(key: AppKeys.namazImsakText, title: const Text('Imsak'), trailing: Text(_timeByName(provider, 'imsak'))),
                ListTile(key: AppKeys.namazGunesText, title: const Text('Gunes'), trailing: Text(_timeByName(provider, 'gunes'))),
                ListTile(key: AppKeys.namazOgleText, title: const Text('Ogle'), trailing: Text(_timeByName(provider, 'ogle'))),
                ListTile(key: AppKeys.namazIkindiText, title: const Text('Ikindi'), trailing: Text(_timeByName(provider, 'ikindi'))),
                ListTile(key: AppKeys.namazAksamText, title: const Text('Aksam'), trailing: Text(_timeByName(provider, 'aksam'))),
                ListTile(key: AppKeys.namazYatsiText, title: const Text('Yatsi'), trailing: Text(_timeByName(provider, 'yatsi'))),
                const SizedBox(height: 16),
                ListView.builder(
                  key: AppKeys.namazHaftalikList,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data?.weekly.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = data!.weekly[index];
                    return ListTile(
                      title: Text(DateFormat('dd.MM.yyyy').format(item.date)),
                      subtitle: Text(item.times.map((time) => '${time.name}: ${time.time}').join(' | ')),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
