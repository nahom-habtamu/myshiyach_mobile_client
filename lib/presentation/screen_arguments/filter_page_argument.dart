import '../../domain/enitites/main_category.dart';

class FilterPageArgument {
  final List<MainCategory> categories;
  final double minValue;
  final double maxValue;
  final bool orderByAscending;

  FilterPageArgument({
    required this.categories,
    required this.minValue,
    required this.maxValue,
    this.orderByAscending = false,
  });
}
