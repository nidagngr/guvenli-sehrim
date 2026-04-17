import '../../../../core/models/repository_response.dart';
import '../entities/hava_durumu.dart';

abstract class HavaRepository {
  Future<RepositoryResponse<HavaDurumu>> fetchWeather(String city);
}
