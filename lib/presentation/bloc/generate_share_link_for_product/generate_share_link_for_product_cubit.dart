import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/generate_share_link_for_product.dart';

class GenerateShareLinkForProductCubit extends Cubit<String?> {
  final GenerateShareLinkForProduct generateShareLinkForProduct;
  GenerateShareLinkForProductCubit(
    this.generateShareLinkForProduct,
  ) : super(null);

  Future<String?> call(String productId) async {
    try {
      var result = await generateShareLinkForProduct.call(productId);
      return result;
    } catch (e) {
      return null;
    }
  }
}
