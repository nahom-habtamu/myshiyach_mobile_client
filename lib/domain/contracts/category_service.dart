import '../../data/models/category/main_category_model.dart';

abstract class CategoryService {
  Future<List<MainCategoryModel>> getAllCategories();
}
