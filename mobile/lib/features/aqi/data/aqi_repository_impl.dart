import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/models/repository_response.dart';
import '../../../core/network/app_api_client.dart';
import '../domain/entities/hava_kalitesi.dart';
import '../domain/repositories/aqi_repository.dart';

class AqiRepositoryImpl implements AqiRepository {
  AqiRepositoryImpl({required AppApiClient client, required Box<dynamic> box})
      : _client = client,
        _box = box;

  final AppApiClient _client;
  final Box<dynamic> _box;

  @override
  Future<RepositoryResponse<HavaKalitesi>> fetchAqi() async {
    const cacheKey = 'aqi';
    try {
      final response = await _client.dio.get<Map<String, dynamic>>('/kalite');
      final data = HavaKalitesi.fromMap(response.data ?? {});
      await _box.put(cacheKey, {'updatedAt': DateTime.now().toIso8601String(), 'data': data.toMap()});
      return RepositoryResponse(data: data, fromCache: false, lastUpdated: DateTime.now());
    } on DioException {
      final cached = _box.get(cacheKey);
      if (cached is Map) {
        return RepositoryResponse(
          data: HavaKalitesi.fromMap(Map<String, dynamic>.from(cached['data'] as Map)),
          fromCache: true,
          lastUpdated: DateTime.tryParse(cached['updatedAt']?.toString() ?? '') ?? DateTime.now(),
        );
      }
      rethrow;
    }
  }
}
