import '../../core/services/network_info.dart';
import '../../domain/contracts/product_service.dart';
import '../datasources/dynamic_link/firebase_dynamic_link_data_souce.dart';
import '../datasources/product/product_local_data_source.dart';
import '../datasources/product/product_remote_data_source.dart';
import '../datasources/storage/storage_data_source.dart';
import '../models/filter/filter_criteria_model.dart';
import '../models/product/add_product_model.dart';
import '../models/product/edit_product_model.dart';
import '../models/product/get_paginated_products_result_model.dart';
import '../models/product/page_and_limit_model.dart';
import '../models/product/product_model.dart';

class ProductRepository extends ProductService {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final StorageDataSource storageService;
  final DynamicLinkDataSource dynamicLinkDataSource;

  ProductRepository({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
    required this.storageService,
    required this.dynamicLinkDataSource,
  });

  @override
  Future<GetPaginatedProductsResultModel> getPaginatedProducts(
    PageAndLimitModel pageAndLimit,
    FilterCriteriaModel? filterCriteriaModel,
  ) {
    return remoteDataSource.getPaginatedProducts(
        pageAndLimit, filterCriteriaModel);
  }

  @override
  Future<ProductModel> createProduct(
      AddProductModel addProductModel, String token) {
    return remoteDataSource.createProduct(addProductModel, token);
  }

  @override
  Future<String> deleteProduct(String id, String token) {
    return remoteDataSource.deleteProduct(id, token);
  }

  @override
  Future<ProductModel> updateProduct(
    String id,
    EditProductModel editProductModel,
    String token,
  ) {
    return remoteDataSource.updateProduct(id, editProductModel, token);
  }

  @override
  Future<List<ProductModel>> getProductsByCreatorId(String userId) {
    return remoteDataSource.getProductsByCreatorId(userId);
  }

  @override
  Future<ProductModel> getProductById(String id, String token) {
    return remoteDataSource.getProductById(id, token);
  }

  @override
  Future<ProductModel> refreshProduct(String id, String token) {
    return remoteDataSource.refreshProduct(id, token);
  }

  @override
  Future<String> generateShareLink(String id) {
    return dynamicLinkDataSource.generateDynamicLink(id);
  }

  @override
  Future<List<ProductModel>> getAllProducts() {
    return remoteDataSource.getAllProducts();
  }

  @override
  Future<ProductModel> reportProduct(String id, String token) {
    return remoteDataSource.reportProduct(id, token);
  }

  @override
  Future<List<ProductModel>> getAllFavoriteProducts(
      String token, List<String> favoriteProducts) async {
    List<ProductModel> products = [];

    for (var fav in favoriteProducts) {
      var productDetail = await getProduct(fav, token);
      if (productDetail != null) {
        products = [...products, productDetail];
      }
    }
    return products;
  }

  Future<ProductModel?> getProduct(String id, String token) async {
    try {
      return await remoteDataSource.getProductById(id, token);
    } catch (e) {
      return null;
    }
  }
}
