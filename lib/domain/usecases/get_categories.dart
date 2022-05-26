import '../../data/models/category/main_category_model.dart';
import '../contracts/category_service.dart';

class GetAllCategories {
  final CategoryService repository;

  GetAllCategories(this.repository);

  Future<List<MainCategoryModel>> call() async {
    return await repository.getAllCategories();
  }
}
