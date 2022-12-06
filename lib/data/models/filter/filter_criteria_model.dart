import '../../../domain/enitites/main_category.dart';
import '../../../domain/enitites/sub_category.dart';

class FilterCriteriaModel {
  final double? maxPrice;
  final double? minPrice;
  final MainCategory? mainCategory;
  final SubCategory? subCategory;
  final String? brand;
  final String? city;
  final bool? sortByPriceAscending;
  final bool? sortByCreatedByAscending;
  String? keyword;

  FilterCriteriaModel({
    required this.maxPrice,
    required this.minPrice,
    required this.mainCategory,
    required this.subCategory,
    required this.brand,
    required this.city,
    required this.sortByPriceAscending,
    required this.sortByCreatedByAscending,
    required this.keyword,
  });

  FilterCriteriaModel.empty({
    this.maxPrice = 0.0,
    this.minPrice = 0.0,
    this.mainCategory,
    this.subCategory,
    this.brand,
    this.city,
    this.sortByPriceAscending,
    this.sortByCreatedByAscending,
    this.keyword,
  });

  static FilterCriteriaModel addKeyWord(
      FilterCriteriaModel? original, String? keyword) {
    return FilterCriteriaModel(
      maxPrice: original?.maxPrice ?? 0.0,
      minPrice: original?.minPrice ?? 0.0,
      mainCategory: original?.mainCategory,
      subCategory: original?.subCategory,
      brand: original?.brand,
      city: original?.city,
      sortByPriceAscending: original?.sortByPriceAscending,
      sortByCreatedByAscending: original?.sortByCreatedByAscending,
      keyword: keyword,
    );
  }

  static FilterCriteriaModel addMainCategory(
      FilterCriteriaModel? original, MainCategory? mainCategory) {
    return FilterCriteriaModel(
      maxPrice: original?.maxPrice ?? 0.0,
      minPrice: original?.minPrice ?? 0.0,
      mainCategory: mainCategory,
      subCategory: null,
      brand: original?.brand,
      city: original?.city,
      sortByPriceAscending: original?.sortByPriceAscending,
      sortByCreatedByAscending: original?.sortByCreatedByAscending,
      keyword: original?.keyword,
    );
  }

  static FilterCriteriaModel addSubCategory(
      FilterCriteriaModel? original, SubCategory? subCategory) {
    return FilterCriteriaModel(
      maxPrice: original?.maxPrice ?? 0.0,
      minPrice: original?.minPrice ?? 0.0,
      mainCategory: original?.mainCategory,
      subCategory: subCategory,
      brand: original?.brand,
      city: original?.city,
      sortByPriceAscending: original?.sortByPriceAscending,
      sortByCreatedByAscending: original?.sortByCreatedByAscending,
      keyword: original?.keyword,
    );
  }

  bool areAllValuesNull() {
    return (maxPrice == null || maxPrice == 0.0) &&
        (minPrice == null || minPrice == 0.0) &&
        mainCategory == null &&
        subCategory == null &&
        brand == null &&
        city == null &&
        sortByPriceAscending == null &&
        sortByCreatedByAscending == null &&
        keyword == null;
  }

  @override
  String toString() {
    return '''{ 
      MaxPrice : $maxPrice , 
      MinPrice : $minPrice , 
      MainCategory : ${mainCategory?.title} ,  
      SubCategory : ${subCategory?.title},  
      brand : $brand,  
      city : $city,  
      sortByPriceAscending : $sortByPriceAscending,  
      sortByCreatedByAscending : $sortByCreatedByAscending,  
    }''';
  }

  Map<String, dynamic> toJson() {
    return {
      "maxPrice": maxPrice,
      "minPrice": minPrice,
      "mainCategory": mainCategory?.id,
      "subCategory": subCategory?.id,
      "brand": brand,
      "city": city,
      "sortByPriceAscending": sortByPriceAscending,
      "sortByCreatedByAscending": sortByCreatedByAscending,
      "keyword": keyword
    };
  }
}
