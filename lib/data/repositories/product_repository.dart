import '../../core/services/network_info.dart';
import '../../domain/contracts/product_service.dart';
import '../datasources/product/product_remote_data_source.dart';
import '../datasources/product/product_local_data_source.dart';
import '../models/product/add_product_model.dart';
import '../models/product/product_model.dart';

class ProductRepository extends ProductService {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepository({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
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
  Future<ProductModel> createProduct(AddProductModel addProductModel) {
    return remoteDataSource.createProduct(addProductModel);
  }
}
