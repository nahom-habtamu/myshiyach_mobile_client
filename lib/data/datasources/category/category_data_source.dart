import '../../models/category/main_category_model.dart';

abstract class CategoryDataSource {
  Future<List<MainCategoryModel>> getAllCategories();
}
