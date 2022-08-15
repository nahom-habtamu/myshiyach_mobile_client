import '../../../domain/enitites/product.dart';

class ProductModel extends Product {
  ProductModel({
    required String id,
    required String title,
    required String description,
    required double price,
    required String mainCategory,
    required String subCategory,
    required String city,
    required String contactPhone,
    required String createdAt,
    required String refreshedAt,
    required String createdBy,
    required List<String> productImages,
    Map<String, dynamic>? productDetail,
  }) : super(
          id: id,
          title: title,
          description: description,
          price: price,
          mainCategory: mainCategory,
          subCategory: subCategory,
          city: city,
          contactPhone: contactPhone,
          createdAt: createdAt,
          refreshedAt: refreshedAt,
          createdBy: createdBy,
          productImages: productImages,
          productDetail: productDetail,
        );

  factory ProductModel.fromJson(dynamic jsonProduct) {
    return ProductModel(
      id: jsonProduct["_id"],
      title: jsonProduct["title"],
      description: jsonProduct["description"],
      price: (jsonProduct["price"] as num).toDouble(),
      mainCategory: jsonProduct["mainCategory"],
      subCategory: jsonProduct["subCategory"],
      createdAt: jsonProduct["createdAt"],
      refreshedAt: jsonProduct["refreshedAt"],
      createdBy: jsonProduct["createdBy"],
      city: jsonProduct["city"],
      contactPhone: jsonProduct["contactPhone"],
      productDetail: jsonProduct["productDetail"] == null
          ? null
          : Map<String, dynamic>.from(jsonProduct["productDetail"]),
      productImages: List<String>.from(jsonProduct["productImages"]),
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
      createdAt: p.createdAt,
      refreshedAt: p.refreshedAt,
      createdBy: p.createdBy,
      city: p.city,
      contactPhone: p.contactPhone,
      productImages: p.productImages,
      productDetail: p.productDetail,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "price": price,
        "mainCategory": mainCategory,
        "subCategory": subCategory,
        "createdAt": createdAt,
        "refreshedAt": refreshedAt,
        "createdBy": createdBy,
        "city": city,
        "contactPhone": contactPhone,
        "productImages": productImages,
        "productDetail": productDetail,
      };

  static List<ProductModel> parseProductsFromJson(dynamic jsonList) {
    var products = <ProductModel>[];
    if (jsonList.length > 0) {
      jsonList.forEach((e) => {products.add(ProductModel.fromJson(e))});
    }
    return products;
  }
}
