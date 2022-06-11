import '../../core/services/network_info.dart';
import '../../domain/contracts/product_service.dart';
import '../datasources/firebase/firebase_storage_data_source.dart';
import '../datasources/product/product_local_data_source.dart';
import '../datasources/product/product_remote_data_source.dart';
import '../models/product/add_product_model.dart';
import '../models/product/edit_product_model.dart';
import '../models/product/product_model.dart';

class ProductRepository extends ProductService {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final StorageDataSource storageService;

  ProductRepository({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
    required this.storageService,
  });

  @override
  Future<List<ProductModel>> getAllProducts() {
    return remoteDataSource.getAllProducts();
  }

  @override
  Future<List<ProductModel>> getAllFavoriteProducts() {
    return localDataSource.getFavoriteProducts();
  }

  @override
  Future<void> setFavoriteProducts(List<ProductModel> products) {
    return localDataSource.setFavoriteProducts(products);
  }

  @override
  Future<ProductModel> createProduct(
      AddProductModel addProductModel, String token) {
    return remoteDataSource.createProduct(addProductModel, token);
  }

  @override
  Future<List<String>> uploadProductPictures(List<dynamic> images) {
    return storageService.uploadFiles(images);
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
}
