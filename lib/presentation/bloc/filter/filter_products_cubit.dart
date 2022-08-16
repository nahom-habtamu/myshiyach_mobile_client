import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/filter/filter_criteria_model.dart';
import '../../../domain/enitites/product.dart';
import '../../../domain/usecases/filter_products.dart';

class FilterProductsCubit extends Cubit<List<Product>> {
  final FilterProducts filterProducts;
  FilterProductsCubit(
    this.filterProducts,
  ) : super([]);

  List<Product> call(
    List<Product> products,
    FilterCriteriaModel? filterCriteria,
  ) {
    return filterProducts.call(products, filterCriteria);
  }
}
