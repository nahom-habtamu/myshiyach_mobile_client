import '../../core/utils/date_time_formatter.dart';
import '../../data/models/filter/filter_criteria_model.dart';
import '../enitites/product.dart';

class FilterProducts {
  List<Product> call(
    List<Product> products,
    FilterCriteriaModel? filterCriteria,
  ) {
    if (filterCriteria == null || filterCriteria.areAllValuesNull()) {
      products.sort(((a, b) => _compareRefreshedAt(a, b)));
      return products.toSet().toList();
    }

    var filteredByMainCategory = _filterByMainCategory(
      filterCriteria,
      products,
    );
    var filteredBySubCategory = filteredByMainCategory.isEmpty
        ? <Product>[]
        : _filterBySubCategory(filterCriteria, filteredByMainCategory);

    var filteredByBrand = filteredBySubCategory.isEmpty
        ? <Product>[]
        : _filterByBrand(filterCriteria, filteredBySubCategory);

    var filteredByCity = filteredByBrand.isEmpty
        ? <Product>[]
        : _filterByCity(filterCriteria, filteredByBrand);

    var filteredByPrice = filteredByCity.isEmpty
        ? <Product>[]
        : _filterByPrice(filterCriteria, filteredByCity);

    var filteredByKeyword = filteredByPrice.isEmpty
        ? <Product>[]
        : _filterByKeyword(filterCriteria, filteredByPrice);

    var sortedProduct = filteredByKeyword.isEmpty
        ? <Product>[]
        : _sortProduct(filterCriteria, filteredByKeyword);

    return sortedProduct.toSet().toList();
  }

  List<Product> _filterByMainCategory(
      FilterCriteriaModel filterCriteria, List<Product> products) {
    return filterCriteria.mainCategory == null
        ? products
        : products
            .where((p) => p.mainCategory == filterCriteria.mainCategory!.id)
            .toList();
  }

  List<Product> _filterBySubCategory(
      FilterCriteriaModel filterCriteria, List<Product> products) {
    return filterCriteria.subCategory == null
        ? products
        : products
            .where((p) => p.subCategory == filterCriteria.subCategory!.id)
            .toList();
  }

  List<Product> _filterByBrand(
      FilterCriteriaModel filterCriteria, List<Product> products) {
    return filterCriteria.brand == null
        ? products
        : products.where((p) => _matchByBrand(p, filterCriteria)).toList();
  }

  List<Product> _filterByCity(
      FilterCriteriaModel filterCriteria, List<Product> products) {
    return filterCriteria.city == null
        ? products
        : products.where((p) => p.city == filterCriteria.city).toList();
  }

  bool _matchByBrand(Product p, FilterCriteriaModel filterCriteria) {
    if (p.productDetail == null || p.productDetail!["brand"]["value"] == null) {
      return false;
    }
    return p.productDetail!["brand"]["value"] == filterCriteria.brand;
  }

  List<Product> _filterByPrice(
      FilterCriteriaModel filterCriteria, List<Product> products) {
    return isPriceNullOrEmpty(filterCriteria.maxPrice) ||
            isPriceNullOrEmpty(filterCriteria.minPrice)
        ? products
        : products
            .where(
              (p) =>
                  p.price <= filterCriteria.maxPrice! &&
                  p.price >= filterCriteria.minPrice!,
            )
            .toList();
  }

  bool isPriceNullOrEmpty(double? price) => price == null || price == 0.0;

  int _compareRefreshedAt(Product a, Product b) {
    var firstDate = DateFormatterUtil.parseProductCreatedDate(a.refreshedAt);
    var secondDate = DateFormatterUtil.parseProductCreatedDate(b.refreshedAt);
    return secondDate.compareTo(firstDate);
  }

  List<Product> _sortProduct(
    FilterCriteriaModel filterCriteria,
    List<Product> products,
  ) {
    if (filterCriteria.sortByPriceAscending != null) {
      products.sort(
        ((a, b) => filterCriteria.sortByPriceAscending!
            ? a.price.compareTo(b.price)
            : b.price.compareTo(a.price)),
      );
    }

    if (filterCriteria.sortByCreatedByAscending != null) {
      products.sort(((a, b) => filterCriteria.sortByCreatedByAscending!
          ? _compareRefreshedAt(a, b)
          : _compareRefreshedAt(b, a)));
    }

    return [...products];
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
