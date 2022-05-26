import '../../../domain/enitites/main_category.dart';
import 'sub_category_model.dart';

class MainCategoryModel extends MainCategory {
  MainCategoryModel(
      {required String id,
      required String title,
      required List<SubCategoryModel> subCategories})
      : super(
          id: id,
          title: title,
          subCategories: subCategories,
        );

  factory MainCategoryModel.fromJson(dynamic jsonMainCategory) {
    return MainCategoryModel(
      id: jsonMainCategory["_id"],
      title: jsonMainCategory["title"],
      subCategories: SubCategoryModel.parseProductsFromJson(
        jsonMainCategory["subCategories"],
      ),
    );
  }

  static List<MainCategoryModel> parseCategoriesFromJson(dynamic jsonList) {
    var mainCategories = <MainCategoryModel>[];
    if (jsonList.length > 0) {
      jsonList
          .forEach((e) => {mainCategories.add(MainCategoryModel.fromJson(e))});
    }
    return mainCategories;
  }
}
