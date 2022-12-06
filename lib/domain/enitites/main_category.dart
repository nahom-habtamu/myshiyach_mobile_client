import 'sub_category.dart';

class MainCategory {
  final String id;
  final String title;
  final List<SubCategory> subCategories;
  final List<RequiredMainCategoryField> requiredFeilds;

  MainCategory({
    required this.id,
    required this.title,
    required this.subCategories,
    this.requiredFeilds = const [],
  });
}

class RequiredMainCategoryField {
  final String objectKey;
  final String title;
  final bool isDropDown;
  final List<String> dropDownValues;

  RequiredMainCategoryField({
    required this.objectKey,
    required this.title,
    required this.isDropDown,
    this.dropDownValues = const [],
  });
}
