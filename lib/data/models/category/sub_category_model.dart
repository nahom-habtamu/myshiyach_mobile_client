import '../../../domain/enitites/sub_category.dart';

class SubCategoryModel extends SubCategory {
  SubCategoryModel({
    required String id,
    required String title,
  }) : super(
          id: id,
          title: title,
        );

  factory SubCategoryModel.fromJson(dynamic subCategoryJson) {
    return SubCategoryModel(
      id: subCategoryJson["_id"],
      title: subCategoryJson["title"],
    );
  }

  static List<SubCategoryModel> parseSubCategoriesFromJson(dynamic jsonList) {
    var subCategories = <SubCategoryModel>[];
    if (jsonList.length > 0) {
      jsonList
          .forEach((e) => {subCategories.add(SubCategoryModel.fromJson(e))});
    }
    return subCategories;
  }
}
