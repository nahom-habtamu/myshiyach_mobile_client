class AddProductModel {
  final String title;
  final String description;
  final double price;
  final String mainCategory;
  final String subCategory;
  final String brand;
  final String state;
  List<String> productImages;
  Map<String, dynamic>? other;

  AddProductModel({
    required this.title,
    required this.description,
    required this.price,
    required this.mainCategory,
    required this.subCategory,
    required this.brand,
    required this.state,
    required this.productImages,
    this.other,
  });

  factory AddProductModel.fromJson(Map<String, dynamic> json) {
    return AddProductModel(
      title: json["title"],
      description: json["description"],
      price: double.parse(json["price"]),
      mainCategory: json["mainCategory"],
      subCategory: json["subCategory"],
      brand: json["brand"],
      state: json["state"],
      productImages: [],
      other: json["other"],
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "price": price,
        "mainCategory": mainCategory,
        "subCategory": subCategory,
        "brand": brand,
        "state": state,
        "productImages": productImages,
        "other": other
      };
}
