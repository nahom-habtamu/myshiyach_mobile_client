import '../../../domain/enitites/main_category.dart';

abstract class GetDataNeededToAddPostState {}

class Empty extends GetDataNeededToAddPostState {}

class Loading extends GetDataNeededToAddPostState {}

class Loaded extends GetDataNeededToAddPostState {
  final List<MainCategory> categories;
  final List<String> cities;
  Loaded(this.categories, this.cities);
}

class Error extends GetDataNeededToAddPostState {
  final String message;
  Error({required this.message});
}
