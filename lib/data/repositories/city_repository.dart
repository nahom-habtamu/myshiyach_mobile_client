import '../../domain/contracts/city_service.dart';
import '../datasources/city/city_data_source.dart';

class CityRepository extends CityService {
  final CityDataSource cityDataSource;

  CityRepository(this.cityDataSource);

  @override
  Future<List<String>> getAllCities() {
    return cityDataSource.getAllCities();
  }
}
