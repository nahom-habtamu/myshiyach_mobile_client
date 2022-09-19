import '../contracts/user_service.dart';

class SetIsAppOpenedFirstTime {
  final UserService repository;

  SetIsAppOpenedFirstTime(this.repository);

  Future<void> call() async {
    await repository.storeIsAppOpenedFirstTime();
  }
}
