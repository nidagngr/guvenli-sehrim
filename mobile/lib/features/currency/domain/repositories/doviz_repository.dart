import '../../../../core/models/repository_response.dart';
import '../entities/doviz_gunu.dart';

abstract class DovizRepository {
  Future<RepositoryResponse<DovizGunu>> fetchRates();
}
