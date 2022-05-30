import '../../../domain/enitites/sub_category.dart';

class SubCategoryModel extends SubCategory {
  SubCategoryModel({
    required String id,
    required String title,
    required List<String> additionalData,
  }) : super(
          id: id,
          title: title,
          additionalData: additionalData,
        );

  factory SubCategoryModel.fromJson(dynamic subCategoryJson) {
    return SubCategoryModel(
      id: subCategoryJson["_id"],
      title: subCategoryJson["title"],
      additionalData: List<String>.from(subCategoryJson["additionalData"]),
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
