class NamazVakti {
  const NamazVakti({required this.name, required this.time});

  final String name;
  final String time;

  factory NamazVakti.fromMap(Map<String, dynamic> map) => NamazVakti(
        name: map['name'] as String? ?? '',
        time: map['time'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {'name': name, 'time': time};
}

class HaftalikNamaz {
  const HaftalikNamaz({required this.date, required this.times});

  final DateTime date;
  final List<NamazVakti> times;

  factory HaftalikNamaz.fromMap(Map<String, dynamic> map) => HaftalikNamaz(
        date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
        times: ((map['times'] as List?) ?? [])
            .map((item) => NamazVakti.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'date': date.toIso8601String(),
        'times': times.map((item) => item.toMap()).toList(),
      };
}

class NamazGunu {
  const NamazGunu({
    required this.city,
    required this.date,
    required this.nextPrayer,
    required this.remainingSeconds,
    required this.times,
    required this.weekly,
  });

  final String city;
  final DateTime date;
  final String nextPrayer;
  final int remainingSeconds;
  final List<NamazVakti> times;
  final List<HaftalikNamaz> weekly;

  factory NamazGunu.fromMap(Map<String, dynamic> map) => NamazGunu(
        city: map['city'] as String? ?? 'Istanbul',
        date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
        nextPrayer: map['nextPrayer'] as String? ?? 'ogle',
        remainingSeconds: (map['remainingSeconds'] as num?)?.toInt() ?? 0,
        times: ((map['times'] as List?) ?? [])
            .map((item) => NamazVakti.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList(),
        weekly: ((map['weekly'] as List?) ?? [])
            .map((item) => HaftalikNamaz.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'city': city,
        'date': date.toIso8601String(),
        'nextPrayer': nextPrayer,
        'remainingSeconds': remainingSeconds,
        'times': times.map((item) => item.toMap()).toList(),
        'weekly': weekly.map((item) => item.toMap()).toList(),
      };
}
