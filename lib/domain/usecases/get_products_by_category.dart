import 'package:mnale_client/data/models/filter/filter_criteria_model.dart';
import 'package:mnale_client/data/models/product/page_and_limit_model.dart';
import 'package:mnale_client/domain/enitites/main_category.dart';
import 'package:mnale_client/domain/enitites/page_and_limit.dart';
import 'package:mnale_client/domain/enitites/sub_category.dart';

import '../../core/utils/date_time_formatter.dart';
import '../contracts/product_service.dart';
import '../enitites/product.dart';

class GetProductsByCategory {
  final ProductService repository;

  GetProductsByCategory(this.repository);

  Future<List<Product>> call(String mainCategory, String subCategory) async {
    var parsedResult = await repository.getPaginatedProducts(
      PageAndLimitModel(limit: 60, page: 1),
      FilterCriteriaModel(
        maxPrice: 0,
        minPrice: 0,
        mainCategory:
            MainCategory(id: mainCategory, title: "", subCategories: []),
        subCategory: SubCategory(id: subCategory, title: ""),
        brand: null,
        city: null,
        sortByPriceAscending: null,
        sortByCreatedByAscending: null,
        keyword: null,
      ),
    );

    var products = parsedResult.products;

    products.sort(((a, b) => _compareRefreshedAt(a, b)));
    return products
        .where((element) =>
            element.mainCategory == mainCategory &&
            element.subCategory == subCategory)
        .toList();
  }

  int _compareRefreshedAt(Product a, Product b) {
    var firstDate = DateFormatterUtil.parseProductCreatedDate(a.refreshedAt);
    var secondDate = DateFormatterUtil.parseProductCreatedDate(b.refreshedAt);
    return secondDate.compareTo(firstDate);
  }
}
