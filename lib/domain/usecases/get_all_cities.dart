import '../contracts/city_service.dart';

class GetAllCities {
  final CityService repository;

  GetAllCities(this.repository);

  Future<List<String>> call() {
    return repository.getAllCities();
  }
}
