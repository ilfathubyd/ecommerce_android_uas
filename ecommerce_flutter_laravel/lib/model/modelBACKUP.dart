import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  int id;
  String name;
  String image;
  DateTime createdAt;
  DateTime updatedAt;
  List<Specification> specification;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.specification,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    specification: List<Specification>.from(
      json["specification"].map((x) => Specification.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "specification": List<dynamic>.from(specification.map((x) => x.toJson())),
  };
}

class Specification {
  int id;
  int productId;
  String storage;
  String price;
  DateTime createdAt;
  DateTime updatedAt;

  Specification({
    required this.id,
    required this.productId,
    required this.storage,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Specification.fromJson(Map<String, dynamic> json) => Specification(
    id: json["id"],
    productId: json["product_id"],
    storage: json["storage"],
    price: json["price"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "storage": storage,
    "price": price,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class CheckoutItem {
  final Product product;
  final Specification spec;
  int qty;

  CheckoutItem({required this.product, required this.spec, this.qty = 1});

  /// Harga satuan (int) – bersihkan jika ada titik/koma/dll.
  int get pricePerPiece =>
      int.tryParse(spec.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  int get subtotal => pricePerPiece * qty;
}
