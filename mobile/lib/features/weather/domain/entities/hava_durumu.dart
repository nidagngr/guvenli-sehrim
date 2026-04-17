class SaatlikTahmin {
  const SaatlikTahmin({required this.hour, required this.temperature, required this.icon});

  final String hour;
  final double temperature;
  final String icon;

  factory SaatlikTahmin.fromMap(Map<String, dynamic> map) => SaatlikTahmin(
        hour: map['saat'] as String? ?? '',
        temperature: (map['sicaklik'] as num?)?.toDouble() ?? 0,
        icon: map['icon'] as String? ?? 'sunny',
      );

  Map<String, dynamic> toMap() => {'saat': hour, 'sicaklik': temperature, 'icon': icon};
}

class GunlukTahmin {
  const GunlukTahmin({required this.day, required this.min, required this.max, required this.icon});

  final String day;
  final double min;
  final double max;
  final String icon;

  factory GunlukTahmin.fromMap(Map<String, dynamic> map) => GunlukTahmin(
        day: map['gun'] as String? ?? '',
        min: (map['min'] as num?)?.toDouble() ?? 0,
        max: (map['max'] as num?)?.toDouble() ?? 0,
        icon: map['icon'] as String? ?? 'sunny',
      );

  Map<String, dynamic> toMap() => {'gun': day, 'min': min, 'max': max, 'icon': icon};
}

class HavaDurumu {
  const HavaDurumu({
    required this.city,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.description,
    required this.icon,
    required this.hourly,
    required this.daily,
    required this.favorites,
  });

  final String city;
  final double temperature;
  final double feelsLike;
  final double humidity;
  final double windSpeed;
  final double pressure;
  final String description;
  final String icon;
  final List<SaatlikTahmin> hourly;
  final List<GunlukTahmin> daily;
  final List<String> favorites;

  factory HavaDurumu.fromMap(Map<String, dynamic> map) => HavaDurumu(
        city: map['city'] as String? ?? 'Ankara',
        temperature: (map['current']?['sicaklik'] as num?)?.toDouble() ?? 0,
        feelsLike: (map['current']?['hissedilen'] as num?)?.toDouble() ?? 0,
        humidity: (map['current']?['nem'] as num?)?.toDouble() ?? 0,
        windSpeed: (map['current']?['ruzgarHizi'] as num?)?.toDouble() ?? 0,
        pressure: (map['current']?['basinc'] as num?)?.toDouble() ?? 0,
        description: map['current']?['aciklama'] as String? ?? 'Bilinmiyor',
        icon: map['current']?['icon'] as String? ?? 'sunny',
        hourly: ((map['hourly'] as List?) ?? [])
            .map((item) => SaatlikTahmin.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList(),
        daily: ((map['daily'] as List?) ?? [])
            .map((item) => GunlukTahmin.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList(),
        favorites: ((map['favorites'] as List?) ?? []).map((item) => item.toString()).toList(),
      );

  Map<String, dynamic> toMap() => {
        'city': city,
        'current': {
          'sicaklik': temperature,
          'hissedilen': feelsLike,
          'nem': humidity,
          'ruzgarHizi': windSpeed,
          'basinc': pressure,
          'aciklama': description,
          'icon': icon,
        },
        'hourly': hourly.map((item) => item.toMap()).toList(),
        'daily': daily.map((item) => item.toMap()).toList(),
        'favorites': favorites,
      };
}
