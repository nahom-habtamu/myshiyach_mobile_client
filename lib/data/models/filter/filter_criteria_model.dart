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

  FilterCriteriaModel({
    required this.maxPrice,
    required this.minPrice,
    required this.mainCategory,
    required this.subCategory,
    required this.brand,
    required this.city,
    required this.sortByPriceAscending,
    required this.sortByCreatedByAscending,
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
  });

  bool isFilterCriteriaNull() {
    return (maxPrice == null || maxPrice == 0.0) &&
        (minPrice == null || minPrice == 0.0) &&
        mainCategory == null &&
        subCategory == null &&
        brand == null &&
        city == null &&
        sortByPriceAscending == null &&
        sortByCreatedByAscending == null;
  }

  @override
  String toString() {
    return '''{ 
      MaxPrice : $maxPrice , 
      MinPrice : $minPrice , 
      MainCategory : ${mainCategory!.title} ,  
      SubCategory : ${subCategory!.title},  
      brand : $brand,  
      city : $city,  
      sortByPriceAscending : $sortByPriceAscending,  
      sortByCreatedByAscending : $sortByCreatedByAscending,  
    }''';
  }
}