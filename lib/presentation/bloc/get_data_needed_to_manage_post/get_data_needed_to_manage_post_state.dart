import '../../../domain/enitites/main_category.dart';

abstract class GetDataNeededToManagePostState {}

class Empty extends GetDataNeededToManagePostState {}

class Loading extends GetDataNeededToManagePostState {}

class NoNetwork extends GetDataNeededToManagePostState {}

class Loaded extends GetDataNeededToManagePostState {
  final List<MainCategory> categories;
  final List<String> cities;
  Loaded(this.categories, this.cities);
}

class Error extends GetDataNeededToManagePostState {
  final String message;
  Error({required this.message});
}
