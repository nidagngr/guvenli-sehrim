import '../../../../core/models/repository_response.dart';
import '../entities/namaz_gunu.dart';

abstract class NamazRepository {
  Future<RepositoryResponse<NamazGunu>> fetchPrayerTimes(String city);
}
