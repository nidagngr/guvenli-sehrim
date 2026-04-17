class Kur {
  const Kur({
    required this.code,
    required this.name,
    required this.buy,
    required this.sell,
    required this.change,
  });

  final String code;
  final String name;
  final double buy;
  final double sell;
  final double change;

  factory Kur.fromMap(Map<String, dynamic> map) => Kur(
        code: map['kod'] as String? ?? '',
        name: map['ad'] as String? ?? '',
        buy: (map['alis'] as num?)?.toDouble() ?? 0,
        sell: (map['satis'] as num?)?.toDouble() ?? 0,
        change: (map['degisim'] as num?)?.toDouble() ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'kod': code,
        'ad': name,
        'alis': buy,
        'satis': sell,
        'degisim': change,
      };
}

class DovizGunu {
  const DovizGunu({required this.date, required this.rates});

  final String date;
  final List<Kur> rates;

  factory DovizGunu.fromMap(Map<String, dynamic> map) => DovizGunu(
        date: map['tarih'] as String? ?? '',
        rates: ((map['kurlar'] as List?) ?? [])
            .map((item) => Kur.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'tarih': date,
        'kurlar': rates.map((item) => item.toMap()).toList(),
      };
}
