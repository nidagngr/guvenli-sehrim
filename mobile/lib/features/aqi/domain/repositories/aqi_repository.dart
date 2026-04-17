import '../../../../core/models/repository_response.dart';
import '../entities/hava_kalitesi.dart';

abstract class AqiRepository {
  Future<RepositoryResponse<HavaKalitesi>> fetchAqi();
}
