import '../../data/models/filter/filter_criteria_model.dart';
import '../enitites/product.dart';

class FilterProducts {
  List<Product> call(
    List<Product> products,
    FilterCriteriaModel? filterCriteria,
  ) {
    if (filterCriteria == null || filterCriteria.keyword == null) {
      return products;
    } else {
      var filteredByKeyword = products.isEmpty
          ? <Product>[]
          : _filterByKeyword(filterCriteria, products);
      return filteredByKeyword;
    }
  }

  List<Product> _filterByKeyword(
    FilterCriteriaModel filterCriteria,
    List<Product> products,
  ) {
    return products.where((p) => _matchByKeyword(filterCriteria, p)).toList();
  }

  bool _matchByKeyword(
    FilterCriteriaModel filterCriteria,
    Product product,
  ) {
    return filterCriteria.keyword == null
        ? true
        : product.description.contains(
              RegExp(r'' + filterCriteria.keyword!, caseSensitive: false),
            ) ||
            product.title.contains(
              RegExp(r'' + filterCriteria.keyword!, caseSensitive: false),
            );
  }
}
