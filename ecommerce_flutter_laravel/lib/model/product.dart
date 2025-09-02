import 'dart:convert';

class Product {
  final int id;
  final String name;
  final String description;
  final double priceIdr;
  final String imageUrl;
  final List<String> tags;

  final int stock;
  final bool isWishlisted;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.priceIdr,
    required this.imageUrl,
    required this.stock,

    required this.tags,
    this.isWishlisted = false,
  });

  /// Mengubah string JSON (array of objects) menjadi List<Product>.
  static List<Product> listFromJson(String str) =>
      List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

  /// Mengubah List<Product> menjadi string JSON.
  static String listToJson(List<Product> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  /// Factory constructor: membuat instance Product dari sebuah Map (hasil decode JSON).
  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    priceIdr: (json['priceIdr'] as num).toDouble(),
    imageUrl: json['imageUrl'],
    tags: List<String>.from(json['tags']),

    stock: json['stock'],
    isWishlisted: json['isWishlisted'] ?? false,
  );

  /// Method: mengubah instance Product menjadi sebuah Map untuk konversi ke JSON.
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'priceIdr': priceIdr,
    'imageUrl': imageUrl,
    'tags': tags,

    'stock': stock,
    'isWishlisted': isWishlisted,
  };
}
