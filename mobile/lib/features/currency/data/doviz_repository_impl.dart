import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/models/repository_response.dart';
import '../../../core/network/app_api_client.dart';
import '../domain/entities/doviz_gunu.dart';
import '../domain/repositories/doviz_repository.dart';

class DovizRepositoryImpl implements DovizRepository {
  DovizRepositoryImpl({required AppApiClient client, required Box<dynamic> box})
      : _client = client,
        _box = box;

  final AppApiClient _client;
  final Box<dynamic> _box;

  @override
  Future<RepositoryResponse<DovizGunu>> fetchRates() async {
    const cacheKey = 'doviz';
    try {
      final response = await _client.dio.get<Map<String, dynamic>>('/doviz');
      final data = DovizGunu.fromMap(response.data ?? {});
      await _box.put(cacheKey, {'updatedAt': DateTime.now().toIso8601String(), 'data': data.toMap()});
      return RepositoryResponse(data: data, fromCache: false, lastUpdated: DateTime.now());
    } on DioException {
      final cached = _box.get(cacheKey);
      if (cached is Map) {
        return RepositoryResponse(
          data: DovizGunu.fromMap(Map<String, dynamic>.from(cached['data'] as Map)),
          fromCache: true,
          lastUpdated: DateTime.tryParse(cached['updatedAt']?.toString() ?? '') ?? DateTime.now(),
        );
      }
      rethrow;
    }
  }
}
