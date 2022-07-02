import '../../core/utils/date_time_formatter.dart';
import '../../data/models/filter/filter_criteria_model.dart';
import '../enitites/product.dart';

class FilterProducts {
  List<Product> call(
    List<Product> products,
    FilterCriteriaModel filterCriteria,
  ) {
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

    var sortedProduct = filteredByPrice.isEmpty
        ? <Product>[]
        : _sortProduct(filterCriteria, filteredByPrice);

    return sortedProduct;
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
        : products.where((p) => p.city != filterCriteria.city).toList();
  }

  bool _matchByBrand(Product p, FilterCriteriaModel filterCriteria) {
    if (p.productDetail == null || p.productDetail!["brand"] == null) {
      return false;
    }
    return p.productDetail!["brand"] == filterCriteria.brand;
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

  int _compareCreatedAt(Product a, Product b) {
    var firstDate = DateFormatterUtil.parseDate(a.createdAt);
    var secondDate = DateFormatterUtil.parseDate(b.createdAt);
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
          ? _compareCreatedAt(a, b)
          : _compareCreatedAt(b, a)));
    }

    return [...products];
  }
}