import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_keys.dart';
import 'hava_provider.dart';

class HavaScreen extends StatefulWidget {
  const HavaScreen({super.key});

  @override
  State<HavaScreen> createState() => _HavaScreenState();
}

class _HavaScreenState extends State<HavaScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<HavaProvider>();
    if (_searchController.text != provider.searchQuery) {
      _searchController.text = provider.searchQuery;
      _searchController.selection = TextSelection.collapsed(offset: _searchController.text.length);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  IconData _iconFor(String value) {
    switch (value) {
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.grain;
      case 'storm':
        return Icons.thunderstorm;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_sunny;
    }
  }

  List<Color> _backgroundFor(String value) {
    switch (value) {
      case 'cloudy':
        return const [Color(0xFF94A3B8), Color(0xFFE2E8F0)];
      case 'rainy':
        return const [Color(0xFF0F766E), Color(0xFF67E8F9)];
      case 'storm':
        return const [Color(0xFF1E293B), Color(0xFF475569)];
      case 'snow':
        return const [Color(0xFFE0F2FE), Color(0xFFFFFFFF)];
      default:
        return const [Color(0xFFF59E0B), Color(0xFFFDE68A)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HavaProvider>();
    final weather = provider.weather;
    final colors = _backgroundFor(weather?.icon ?? 'sunny');

    return Scaffold(
      appBar: AppBar(title: const Text('Hava Durumu')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () => provider.load(provider.selectedCity),
          child: provider.isLoading && weather == null
              ? ListView(children: const [SizedBox(height: 300), Center(child: CircularProgressIndicator())])
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _searchController,
                              onChanged: provider.onSearchChanged,
                              onSubmitted: (_) => provider.search(_searchController.text),
                              decoration: InputDecoration(
                                hintText: 'Sehir ara...',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: IconButton(
                                  onPressed: () => provider.search(_searchController.text),
                                  icon: const Icon(Icons.arrow_forward),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: KeyedSubtree(
                                    key: AppKeys.havaCityDropdown,
                                    child: DropdownButtonFormField<String>(
                                      key: ValueKey('hava_city_dropdown_${provider.selectedCity}'),
                                      initialValue: provider.selectedCity,
                                      items: HavaProvider.supportedCities
                                          .take(12)
                                          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                                          .toList(),
                                      onChanged: (value) => provider.load(value ?? 'Ankara'),
                                      decoration: const InputDecoration(labelText: 'Hizli sehir secimi'),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  key: AppKeys.havaGpsButton,
                                  onPressed: provider.useCurrentLocation,
                                  icon: const Icon(Icons.my_location),
                                ),
                                IconButton(
                                  key: AppKeys.havaFavoriteButton,
                                  onPressed: provider.toggleFavorite,
                                  icon: Icon(
                                    weather?.favorites.contains(provider.selectedCity) == true
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                  ),
                                ),
                              ],
                            ),
                            if (provider.searchSuggestions.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: provider.searchSuggestions
                                    .map(
                                      (city) => ActionChip(
                                        label: Text(city),
                                        onPressed: () {
                                          _searchController.text = city;
                                          provider.search(city);
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (provider.error != null && weather == null)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(provider.error!),
                              const SizedBox(height: 8),
                              FilledButton(
                                onPressed: () => provider.load(provider.selectedCity),
                                child: const Text('Tekrar dene'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(_iconFor(weather?.icon ?? 'sunny'), size: 42),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(provider.selectedCity, style: Theme.of(context).textTheme.headlineSmall),
                                      Text(
                                        provider.lastUpdated == null
                                            ? 'Guncelleme bekleniyor'
                                            : 'Guncel: ${DateFormat('dd.MM HH:mm').format(provider.lastUpdated!)}',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${weather?.temperature.toStringAsFixed(0) ?? '--'} C',
                              key: AppKeys.havaCurrentTemp,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            Text(weather?.description ?? 'Bekleniyor'),
                            const SizedBox(height: 12),
                            Text('Nem: %${weather?.humidity.toStringAsFixed(0) ?? '--'}', key: AppKeys.havaCurrentHumidity),
                            Text('Ruzgar: ${weather?.windSpeed.toStringAsFixed(0) ?? '--'} km/s', key: AppKeys.havaCurrentWind),
                            Text('Hissedilen: ${weather?.feelsLike.toStringAsFixed(0) ?? '--'} C', key: AppKeys.havaFeelsLike),
                            Text('Basinc: ${weather?.pressure.toStringAsFixed(0) ?? '--'} hPa'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Saatlik Tahmin', style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(
                      key: AppKeys.havaSaatlikList,
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: (weather?.hourly ?? [])
                            .map(
                              (item) => Card(
                                child: SizedBox(
                                  width: 88,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(item.hour),
                                      const SizedBox(height: 6),
                                      Icon(_iconFor(item.icon)),
                                      const SizedBox(height: 6),
                                      Text('${item.temperature.toStringAsFixed(0)} C'),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('5 Gunluk Tahmin', style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(
                      key: AppKeys.hava5GunList,
                      height: 128,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: (weather?.daily ?? [])
                            .map(
                              (item) => Card(
                                child: SizedBox(
                                  width: 96,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(item.day),
                                      const SizedBox(height: 8),
                                      Icon(_iconFor(item.icon)),
                                      const SizedBox(height: 8),
                                      Text('${item.max.toStringAsFixed(0)} C'),
                                      Text('${item.min.toStringAsFixed(0)} C'),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Son Arananlar', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: provider.recentSearches
                          .map(
                            (city) => ActionChip(
                              label: Text(city),
                              onPressed: () {
                                _searchController.text = city;
                                provider.search(city);
                              },
                            ),
                          )
                          .toList(),
                    ),
                    if (provider.error != null && weather != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        provider.error!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => provider.search(_searchController.text),
        icon: const Icon(Icons.search),
        label: const Text('Ara'),
      ),
    );
  }
}
