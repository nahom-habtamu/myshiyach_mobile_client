import 'sub_category.dart';

class MainCategory {
  final String id;
  final String title;
  final List<SubCategory> subCategories;

  MainCategory({
    required this.id,
    required this.title,
    required this.subCategories,
  });
}
