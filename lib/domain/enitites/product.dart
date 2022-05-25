class Product {
  final String id;
  final String title;
  final String description;
  final int price;
  final String mainCategory;
  final String subCategory;
  final String brand;
  Map<String, dynamic>? other;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.mainCategory,
    required this.subCategory,
    required this.brand,
    this.other,
  });
}
