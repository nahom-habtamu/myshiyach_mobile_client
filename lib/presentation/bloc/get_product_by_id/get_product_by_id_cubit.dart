import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/enitites/product.dart';
import '../../../domain/usecases/get_product_by_id.dart';

class GetProductByIdCubit extends Cubit<Product?> {
  final GetProductById getProductById;
  GetProductByIdCubit(this.getProductById) : super(null);

  Future<Product?> call(String id, String token) async {
    try {
      var product = await getProductById.call(id, token);
      return product;
    } catch (e) {
      return null;
    }
  }
}
