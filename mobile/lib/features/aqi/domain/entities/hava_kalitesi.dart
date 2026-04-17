class TrendPoint {
  const TrendPoint({required this.label, required this.value});

  final String label;
  final double value;

  factory TrendPoint.fromMap(Map<String, dynamic> map) => TrendPoint(
        label: map['label'] as String? ?? '',
        value: (map['value'] as num?)?.toDouble() ?? 0,
      );

  Map<String, dynamic> toMap() => {'label': label, 'value': value};
}

class Istasyon {
  const Istasyon({required this.name, required this.lat, required this.lon, required this.aqi});

  final String name;
  final double lat;
  final double lon;
  final int aqi;

  factory Istasyon.fromMap(Map<String, dynamic> map) => Istasyon(
        name: map['name'] as String? ?? '',
        lat: (map['lat'] as num?)?.toDouble() ?? 0,
        lon: (map['lon'] as num?)?.toDouble() ?? 0,
        aqi: (map['aqi'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toMap() => {'name': name, 'lat': lat, 'lon': lon, 'aqi': aqi};
}

class HavaKalitesi {
  const HavaKalitesi({
    required this.station,
    required this.aqi,
    required this.category,
    required this.color,
    required this.advice,
    required this.pm25,
    required this.pm10,
    required this.trend,
    required this.stations,
  });

  final String station;
  final int aqi;
  final String category;
  final String color;
  final String advice;
  final double pm25;
  final double pm10;
  final List<TrendPoint> trend;
  final List<Istasyon> stations;

  factory HavaKalitesi.fromMap(Map<String, dynamic> map) => HavaKalitesi(
        station: map['station'] as String? ?? 'Kadikoy',
        aqi: (map['current']?['aqi'] as num?)?.toInt() ?? 0,
        category: map['current']?['category'] as String? ?? '',
        color: map['current']?['color'] as String? ?? '#22C55E',
        advice: map['current']?['advice'] as String? ?? '',
        pm25: (map['current']?['pm25'] as num?)?.toDouble() ?? 0,
        pm10: (map['current']?['pm10'] as num?)?.toDouble() ?? 0,
        trend: ((map['trend'] as List?) ?? [])
            .map((item) => TrendPoint.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList(),
        stations: ((map['stations'] as List?) ?? [])
            .map((item) => Istasyon.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'station': station,
        'current': {
          'aqi': aqi,
          'category': category,
          'color': color,
          'advice': advice,
          'pm25': pm25,
          'pm10': pm10,
        },
        'trend': trend.map((item) => item.toMap()).toList(),
        'stations': stations.map((item) => item.toMap()).toList(),
      };
}
