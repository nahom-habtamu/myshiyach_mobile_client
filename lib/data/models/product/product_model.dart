import '../../../domain/enitites/product.dart';

class ProductModel extends Product {
  ProductModel({
    required String id,
    required String title,
    required String description,
    required int price,
    required String mainCategory,
    required String subCategory,
    required String brand,
    required String state,
    required String createdAt,
    required String createdBy,
    required List<String> productImages,
    Map<String, dynamic>? other,
  }) : super(
          id: id,
          title: title,
          description: description,
          price: price,
          mainCategory: mainCategory,
          subCategory: subCategory,
          brand: brand,
          state: state,
          createdAt: createdAt,
          createdBy: createdBy,
          productImages: productImages,
          other: other,
        );

  factory ProductModel.fromJson(dynamic jsonProduct) {
    return ProductModel(
      id: jsonProduct["_id"],
      title: jsonProduct["title"],
      description: jsonProduct["description"],
      price: jsonProduct["price"],
      mainCategory: jsonProduct["mainCategory"],
      subCategory: jsonProduct["subCategory"],
      brand: jsonProduct["brand"],
      createdAt: jsonProduct["createdAt"],
      createdBy: jsonProduct["createdBy"],
      state: jsonProduct["state"],
      productImages: List<String>.from(jsonProduct["productImages"]),
      other: Map<String, dynamic>.from(jsonProduct["other"]),
    );
  }

  factory ProductModel.fromProduct(Product p) {
    return ProductModel(
      id: p.id,
      title: p.title,
      description: p.description,
      price: p.price,
      mainCategory: p.mainCategory,
      subCategory: p.subCategory,
      brand: p.brand,
      createdAt: p.createdAt,
      createdBy: p.createdBy,
      state: p.state,
      productImages: p.productImages,
      other: p.other,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "price": price,
        "mainCategory": mainCategory,
        "subCategory": subCategory,
        "brand": brand,
        "createdAt": createdAt,
        "createdBy": createdBy,
        "state": state,
        "productImages": productImages,
        "other": other,
      };

  static List<ProductModel> parseProductsFromJson(dynamic jsonList) {
    var products = <ProductModel>[];
    if (jsonList.length > 0) {
      jsonList.forEach((e) => {products.add(ProductModel.fromJson(e))});
    }
    return products;
  }
}
