import '../../../domain/enitites/main_category.dart';

abstract class GetAllCategoriesState {}

class GetAllCategoriesEmpty extends GetAllCategoriesState {}

class GetAllCategoriesLoading extends GetAllCategoriesState {}

class GetAllCategoriesLoaded extends GetAllCategoriesState {
  final List<MainCategory> categories;
  GetAllCategoriesLoaded(this.categories);
}

class GetAllCategoriesError extends GetAllCategoriesState {
  final String message;
  GetAllCategoriesError({required this.message});
}
