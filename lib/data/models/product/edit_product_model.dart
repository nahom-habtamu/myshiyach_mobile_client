class EditProductModel {
  final String? title;
  final String? description;
  final double? price;
  final String? mainCategory;
  final String? subCategory;
  final String? brand;
  final String? state;
  final String? city;
  List<String>? productImages;
  Map<String, dynamic>? other;

  EditProductModel({
    this.title,
    this.description,
    this.price,
    this.mainCategory,
    this.subCategory,
    this.brand,
    this.state,
    this.city,
    this.productImages,
    this.other,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "price": price,
        "mainCategory": mainCategory,
        "subCategory": subCategory,
        "brand": brand,
        "state": state,
        "city": city,
        "productImages": productImages,
        "other": other
      };
}
