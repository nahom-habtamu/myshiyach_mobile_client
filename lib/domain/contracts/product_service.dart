import '../../data/models/filter/filter_criteria_model.dart';
import '../../data/models/product/add_product_model.dart';
import '../../data/models/product/edit_product_model.dart';
import '../../data/models/product/get_paginated_products_result_model.dart';
import '../../data/models/product/page_and_limit_model.dart';
import '../../data/models/product/product_model.dart';

abstract class ProductService {
  Future<GetPaginatedProductsResultModel> getPaginatedProducts(
    PageAndLimitModel pageAndLimit,
    FilterCriteriaModel? filterCriteriaModel,
  );
  Future<ProductModel> getProductById(String id, String token);
  Future<List<ProductModel>> getAllProducts();
  Future<List<ProductModel>> getAllFavoriteProducts();
  Future<void> setFavoriteProducts(List<ProductModel> products);
  Future<ProductModel> createProduct(
      AddProductModel addProductModel, String token);
  Future<String> deleteProduct(String id, String token);
  Future<ProductModel> updateProduct(
    String id,
    EditProductModel editProductModel,
    String token,
  );
  Future<List<ProductModel>> getProductsByCreatorId(String userId);
  Future<ProductModel> refreshProduct(String id, String token);
  Future<ProductModel> reportProduct(String id, String token);
  Future<String> generateShareLink(String id);
}
