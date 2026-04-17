class Deprem {
  const Deprem({
    required this.id,
    required this.location,
    required this.province,
    required this.district,
    required this.magnitude,
    required this.depth,
    required this.latitude,
    required this.longitude,
    required this.date,
  });

  final String id;
  final String location;
  final String province;
  final String district;
  final double magnitude;
  final double depth;
  final double latitude;
  final double longitude;
  final DateTime date;

  factory Deprem.fromMap(Map<String, dynamic> map) => Deprem(
        id: map['id'].toString(),
        location: map['location'] as String? ?? '',
        province: map['province'] as String? ?? '',
        district: map['district'] as String? ?? '',
        magnitude: (map['magnitude'] as num?)?.toDouble() ?? 0,
        depth: (map['depth'] as num?)?.toDouble() ?? 0,
        latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
        longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
        date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'location': location,
        'province': province,
        'district': district,
        'magnitude': magnitude,
        'depth': depth,
        'latitude': latitude,
        'longitude': longitude,
        'date': date.toIso8601String(),
      };
}
