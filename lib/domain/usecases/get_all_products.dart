import '../../data/models/filter/filter_criteria_model.dart';
import '../../data/models/product/get_paginated_products_result_model.dart';
import '../../data/models/product/page_and_limit_model.dart';
import '../contracts/product_service.dart';

class GetAllProducts {
  final ProductService repository;

  GetAllProducts(this.repository);

  Future<GetPaginatedProductsResultModel> call(
    PageAndLimitModel pageAndLimit,
    FilterCriteriaModel? filterCriteria,
  ) async {
    var parsedResult =
        await repository.getAllProducts(pageAndLimit, filterCriteria);
    return parsedResult;
  }
}
