import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/models/repository_response.dart';
import '../../../core/network/app_api_client.dart';
import '../domain/entities/hava_durumu.dart';
import '../domain/repositories/hava_repository.dart';

class HavaRepositoryImpl implements HavaRepository {
  HavaRepositoryImpl({required AppApiClient client, required Box<dynamic> box})
      : _client = client,
        _box = box;

  final AppApiClient _client;
  final Box<dynamic> _box;

  @override
  Future<RepositoryResponse<HavaDurumu>> fetchWeather(String city) async {
    final cacheKey = 'hava_$city';
    try {
      final response = await _client.dio.get<Map<String, dynamic>>('/hava', queryParameters: {'city': city});
      final data = HavaDurumu.fromMap(response.data ?? {});
      await _box.put(cacheKey, {'updatedAt': DateTime.now().toIso8601String(), 'data': data.toMap()});
      return RepositoryResponse(data: data, fromCache: false, lastUpdated: DateTime.now());
    } on DioException {
      final cached = _box.get(cacheKey);
      if (cached is Map) {
        return RepositoryResponse(
          data: HavaDurumu.fromMap(Map<String, dynamic>.from(cached['data'] as Map)),
          fromCache: true,
          lastUpdated: DateTime.tryParse(cached['updatedAt']?.toString() ?? '') ?? DateTime.now(),
        );
      }
      rethrow;
    }
  }
}
