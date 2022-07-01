import '../../../domain/enitites/main_category.dart';
import '../../../domain/enitites/sub_category.dart';

class FilterCriteriaModel {
  final double? maxPrice;
  final double? minPrice;
  final MainCategory? mainCategory;
  final SubCategory? subCategory;
  final String? brand;
  final bool? sortByPriceAscending;
  final bool? sortByCreatedByAscending;

  FilterCriteriaModel({
    this.maxPrice,
    this.minPrice,
    this.mainCategory,
    this.subCategory,
    this.brand,
    this.sortByPriceAscending,
    this.sortByCreatedByAscending,
  });

  @override
  String toString() {
    return '''{ 
      MaxPrice : $maxPrice , 
      MinPrice : $minPrice , 
      MainCategory : ${mainCategory!.title} ,  
      SubCategory : ${subCategory!.title},  
      brand : $brand,  
      sortByPriceAscending : $sortByPriceAscending,  
      sortByCreatedByAscending : $sortByCreatedByAscending,  
    }''';
  }
}
