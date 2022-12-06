import '../../../domain/enitites/main_category.dart';
import 'sub_category_model.dart';

class MainCategoryModel extends MainCategory {
  MainCategoryModel({
    required String id,
    required String title,
    required List<SubCategoryModel> subCategories,
    List<RequiredMainCategoryField> requiredFeilds = const [],
  }) : super(
          id: id,
          title: title,
          subCategories: subCategories,
          requiredFeilds: requiredFeilds,
        );

  factory MainCategoryModel.fromJson(dynamic jsonMainCategory) {
    return MainCategoryModel(
      id: jsonMainCategory["_id"],
      title: jsonMainCategory["title"],
      subCategories: SubCategoryModel.parseSubCategoriesFromJson(
        jsonMainCategory["subCategories"],
      ),
      requiredFeilds:
          RequiredMainCategoryFieldModel.parseRequiredFeildsFromJson(
        jsonMainCategory["requiredFields"],
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

class RequiredMainCategoryFieldModel extends RequiredMainCategoryField {
  RequiredMainCategoryFieldModel({
    required String objectKey,
    required String title,
    required bool isDropDown,
    List<String> dropDownValues = const [],
  }) : super(
          title: title,
          objectKey: objectKey,
          isDropDown: isDropDown,
          dropDownValues: dropDownValues,
        );

  factory RequiredMainCategoryFieldModel.fromJson(dynamic requiredFeildJson) {
    return RequiredMainCategoryFieldModel(
      objectKey: requiredFeildJson["objectKey"],
      title: requiredFeildJson["title"],
      isDropDown: requiredFeildJson["isDropDown"],
      dropDownValues: List<String>.from(requiredFeildJson["dropDownValues"]),
    );
  }

  static List<RequiredMainCategoryFieldModel> parseRequiredFeildsFromJson(
      dynamic jsonList) {
    var requiredFields = <RequiredMainCategoryFieldModel>[];
    if (jsonList.length > 0) {
      jsonList.forEach((e) =>
          {requiredFields.add(RequiredMainCategoryFieldModel.fromJson(e))});
    }
    return requiredFields;
  }
}
