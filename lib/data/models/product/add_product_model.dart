class AddProductModel {
  final String title;
  final String description;
  final double price;
  final String mainCategory;
  final String subCategory;
  final String contactPhone;
  final String city;
  List<String> productImages;
  Map<String, dynamic>? productDetail;

  AddProductModel({
    required this.title,
    required this.description,
    required this.price,
    required this.mainCategory,
    required this.subCategory,
    required this.city,
    required this.contactPhone,
    required this.productImages,
    this.productDetail,
  });

  factory AddProductModel.fromJson(Map<String, dynamic> json) {
    return AddProductModel(
      title: json["title"],
      description: json["description"],
      price: json["price"],
      mainCategory: json["mainCategory"],
      subCategory: json["subCategory"],
      city: json["city"],
      contactPhone: json["contactPhone"],
      productImages: [],
      productDetail: Map<String, dynamic>.from(json["productDetail"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title.trim(),
        "description": description.trim(),
        "price": price,
        "mainCategory": mainCategory,
        "subCategory": subCategory,
        "contactPhone": contactPhone,
        "city": city.trim(),
        "productImages": productImages,
        "productDetail": productDetail
      };
}
