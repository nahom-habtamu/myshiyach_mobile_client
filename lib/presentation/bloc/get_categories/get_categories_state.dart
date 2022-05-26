import '../../../domain/enitites/main_category.dart';

abstract class GetAllCategoriesState {}

class Empty extends GetAllCategoriesState {}

class Loading extends GetAllCategoriesState {}

class Loaded extends GetAllCategoriesState {
  final List<MainCategory> categories;
  Loaded(this.categories);
}

class Error extends GetAllCategoriesState {
  final String message;
  Error({required this.message});
}
