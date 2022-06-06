class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String mainCategory;
  final String subCategory;
  final String brand;
  final String state;
  final String city;
  final String createdAt;
  final String createdBy;
  final List<String> productImages;
  Map<String, dynamic>? other;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.mainCategory,
    required this.subCategory,
    required this.brand,
    required this.state,
    required this.city,
    required this.createdAt,
    required this.createdBy,
    required this.productImages,
    this.other,
  });
}
