import '../../domain/contracts/category_service.dart';
import '../datasources/category/category_data_source.dart';
import '../models/category/main_category_model.dart';

class CategoryRepository extends CategoryService {
  final CategoryDataSource remoteDataSource;

  CategoryRepository({required this.remoteDataSource});
  @override
  Future<List<MainCategoryModel>> getAllCategories() {
    return remoteDataSource.getAllCategories();
  }
}
