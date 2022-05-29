class AddProductModel {
  final String title;
  final String description;
  final double price;
  final String mainCategory;
  final String subCategory;
  final String brand;
  final String state;
  final List<String> productImages;
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
      productImages: [
        "https://images.unsplash.com/photo-1653655205981-84fa6d15e551?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60",
        "https://images.unsplash.com/photo-1653731448468-823d9eb59a87?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60"
      ],
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
        "other" : other
      };
}
