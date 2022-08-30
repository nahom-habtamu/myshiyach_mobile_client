class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String mainCategory;
  final String subCategory;
  final String city;
  final String contactPhone;
  final String createdAt;
  final String refreshedAt;
  final String createdBy;
  final List<String> productImages;
  Map<String, dynamic>? productDetail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.mainCategory,
    required this.subCategory,
    required this.city,
    required this.contactPhone,
    required this.createdAt,
    required this.refreshedAt,
    required this.createdBy,
    required this.productImages,
    this.productDetail,
  });

  @override
  bool operator ==(other) {
    if (other is! Product) {
      return false;
    }
    return id == other.id;
  }

  @override
  int get hashCode => (id).hashCode;
}
