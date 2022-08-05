import '../../../domain/enitites/get_paginate_products_result.dart';
import 'page_and_limit_model.dart';
import 'product_model.dart';

class GetPaginatedProductsResultModel extends GetPaginatedProductsResult {
  GetPaginatedProductsResultModel({
    PageAndLimitModel? prev,
    PageAndLimitModel? next,
    required List<ProductModel> products,
  }) : super(
          products: products,
          next: next,
          prev: prev,
        );

  factory GetPaginatedProductsResultModel.fromJson(dynamic json) {
    var productsJson = json["results"];
    var prevJson = json["prev"];
    var nextJson = json["next"];
    return GetPaginatedProductsResultModel(
      products: ProductModel.parseProductsFromJson(productsJson),
      next: nextJson != null ? PageAndLimitModel.fromJson(nextJson) : null,
      prev: prevJson != null ? PageAndLimitModel.fromJson(prevJson) : null,
    );
  }
}
