import '../../core/services/network_info.dart';
import '../../domain/contracts/product_service.dart';
import '../datasources/product/product_remote_data_source.dart';
import '../models/product/product_model.dart';

class ProductRepository extends ProductService {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductRepository({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<ProductModel>> getAllProducts() {
    return remoteDataSource.getAllProducts();
  }
}
