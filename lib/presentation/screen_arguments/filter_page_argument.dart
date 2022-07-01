import '../../data/models/filter/filter_criteria_model.dart';
import '../../domain/enitites/main_category.dart';

class FilterPageArgument {
  final List<MainCategory> allCategories;
  final List<String> cities;
  final FilterCriteriaModel? initialFilterCriteria;

  FilterPageArgument({
    required this.allCategories,
    required this.initialFilterCriteria,
    required this.cities,
  });

  FilterPageArgument.empty({
    this.allCategories = const [],
    this.initialFilterCriteria,
    this.cities = const [],
  });

  @override
  String toString() {
    return "CategoriesCount : ${allCategories.length} , CitiesCount : ${cities.length}";
  }
}
