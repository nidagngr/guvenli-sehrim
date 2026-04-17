import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/models/repository_response.dart';
import '../../../../core/network/app_api_client.dart';
import '../domain/entities/deprem.dart';
import '../domain/repositories/deprem_repository.dart';

class DepremRepositoryImpl implements DepremRepository {
  DepremRepositoryImpl({required AppApiClient client, required Box<dynamic> box})
      : _client = client,
        _box = box;

  final AppApiClient _client;
  final Box<dynamic> _box;

  @override
  Future<RepositoryResponse<List<Deprem>>> fetchEarthquakes() async {
    const cacheKey = 'deprem';
    try {
      final response = await _client.dio.get<Map<String, dynamic>>('/deprem');
      final items = ((response.data?['items'] as List?) ?? [])
          .map((item) => Deprem.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList();
      await _box.put(cacheKey, {
        'updatedAt': DateTime.now().toIso8601String(),
        'items': items.map((item) => item.toMap()).toList(),
      });
      return RepositoryResponse(
        data: items,
        fromCache: false,
        lastUpdated: DateTime.now(),
      );
    } on DioException {
      final cached = _box.get(cacheKey);
      if (cached is Map) {
        final items = ((cached['items'] as List?) ?? [])
            .map((item) => Deprem.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList();
        return RepositoryResponse(
          data: items,
          fromCache: true,
          lastUpdated: DateTime.tryParse(cached['updatedAt']?.toString() ?? '') ?? DateTime.now(),
        );
      }
      rethrow;
    }
  }
}
