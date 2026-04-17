import '../../../../core/models/repository_response.dart';
import '../entities/deprem.dart';

abstract class DepremRepository {
  Future<RepositoryResponse<List<Deprem>>> fetchEarthquakes();
}
