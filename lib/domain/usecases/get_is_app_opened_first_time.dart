import '../contracts/user_service.dart';

class GetIsAppOpenedFirstTime {
  final UserService repository;

  GetIsAppOpenedFirstTime(this.repository);

  Future<bool> call() async {
    return await repository.getIsAppOpenedFirstTime();
  }
}