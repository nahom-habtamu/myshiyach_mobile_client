class EditProductModel {
  final String? title;
  final String? description;
  final double? price;
  final String? mainCategory;
  final String? subCategory;
  final String? city;
  List<String>? productImages;
  Map<String, dynamic>? productDetail;

  EditProductModel({
    this.title,
    this.description,
    this.price,
    this.mainCategory,
    this.subCategory,
    this.city,
    this.productImages,
    this.productDetail,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "price": price,
        "mainCategory": mainCategory,
        "subCategory": subCategory,
        "city": city,
        "productImages": productImages,
        "productDetail": productDetail
      };
}
