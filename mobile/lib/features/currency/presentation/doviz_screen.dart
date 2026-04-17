import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_keys.dart';
import '../domain/entities/doviz_gunu.dart';
import 'doviz_provider.dart';

class DovizScreen extends StatelessWidget {
  const DovizScreen({super.key});

  Kur? _find(List<Kur> rates, String code) {
    for (final rate in rates) {
      if (rate.code == code) return rate;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DovizProvider>();
    final rates = provider.data?.rates ?? [];
    final usd = _find(rates, 'USD');
    final eur = _find(rates, 'EUR');
    final xau = _find(rates, 'XAU');
    return Scaffold(
      appBar: AppBar(title: const Text('Doviz')),
      body: provider.isLoading && provider.data == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  key: AppKeys.dovizUsdCard,
                  child: ListTile(title: const Text('USD'), subtitle: Text('Alis ${usd?.buy.toStringAsFixed(2) ?? '--'}'), trailing: Text(usd?.sell.toStringAsFixed(2) ?? '--')),
                ),
                Card(
                  key: AppKeys.dovizEurCard,
                  child: ListTile(title: const Text('EUR'), subtitle: Text('Alis ${eur?.buy.toStringAsFixed(2) ?? '--'}'), trailing: Text(eur?.sell.toStringAsFixed(2) ?? '--')),
                ),
                Card(
                  key: AppKeys.dovizAltinCard,
                  child: ListTile(title: const Text('Altin'), subtitle: Text('Alis ${xau?.buy.toStringAsFixed(2) ?? '--'}'), trailing: Text(xau?.sell.toStringAsFixed(2) ?? '--')),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.tonalIcon(
                    key: AppKeys.dovizFavoriteButton,
                    onPressed: () => provider.setFavorite(provider.favorite == 'USD' ? 'EUR' : 'USD'),
                    icon: const Icon(Icons.star_border),
                    label: Text('Favori: ${provider.favorite}'),
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  key: AppKeys.dovizRatesList,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rates.length,
                  itemBuilder: (context, index) {
                    final rate = rates[index];
                    return ListTile(
                      title: Text('${rate.code} • ${rate.name}'),
                      subtitle: Text('Alis ${rate.buy.toStringAsFixed(2)} • Satis ${rate.sell.toStringAsFixed(2)}'),
                      trailing: Text('%${rate.change.toStringAsFixed(2)}'),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
