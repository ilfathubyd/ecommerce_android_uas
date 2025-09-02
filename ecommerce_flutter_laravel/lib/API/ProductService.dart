import 'dart:convert';

import 'package:ecommerce_flutter_laravel/model/modelBACKUP.dart';
import 'package:http/http.dart' as http;

class Productservice {
  static final String _baseUrl = 'http://192.168.18.38:8000/api/products';

  Future<List<Product>> getProduct() async {
    Uri UrlApi = Uri.parse(_baseUrl);

    final response = await http.get(UrlApi);

    if (response.statusCode == 200) {
      // 1. Decode response body menjadi Map
      final Map<String, dynamic> decodedJson = json.decode(response.body);

      // 2. Baris yang Anda minta untuk ditambahkan
      final List<dynamic> productListJson = decodedJson['data']['data'];

      // 3. Kembalikan hasil parsing dari list yang sudah benar
      return productListJson.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load data product!");
    }
  }

  Future<Product> getProductById(int productId) async {
    final response = await http.get(Uri.parse('$_baseUrl/$productId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body);
      // Asumsi endpoint show mengembalikan { "data": {...} }
      return Product.fromJson(decodedJson['data']);
    } else {
      throw Exception('Gagal memuat detail produk.');
    }
  }

  Future<void> addProduct({
    required String name,
    required String storage,
    required String price,
    required String imagePath, // Tambahkan parameter path gambar
  }) async {
    // Buat multipart request
    var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

    // Tambahkan field-field text
    request.fields['name'] = name;
    request.fields['storage'] = storage;
    request.fields['price'] = price;

    // Tambahkan file gambar
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    // Kirim request
    var response = await request.send();

    // Cek status code
    if (response.statusCode != 201) {
      // Baca detail error jika ada untuk debugging
      final respStr = await response.stream.bytesToString();
      throw Exception(
        'Gagal membuat produk. Status: ${response.statusCode}, Body: $respStr',
      );
    }
  }

  Future<void> updateProduct({
    required int productId,
    required int variantId,
    required String name,
    required String storage,
    required String price,
    String? imagePath, // Gambar bersifat opsional saat update
  }) async {
    final targetUrl = '$_baseUrl/$productId/variants/$variantId';

    // --- debugging ---
    print('--- DEBUG PROSES UPDATE ---');
    print('Target URL: $targetUrl');
    print('Data Fields: {name: $name, storage: $storage, price: $price}');
    print('Image Path: $imagePath');
    print('---------------------------');
    // ------------------------------------

    // Buat multipart request ke URL update
    var request = http.MultipartRequest(
      'POST', // Kita pakai POST untuk "method spoofing"
      Uri.parse('$_baseUrl/$productId/variants/$variantId'),
    );

    // Tambahkan field untuk method spoofing PUT
    request.fields['_method'] = 'PUT';
    request.fields['name'] = name;
    // request.fields['variant_id'] = variantId;
    request.fields['storage'] = storage;
    request.fields['price'] = price;

    // Jika ada gambar baru yang dipilih, tambahkan ke request
    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    // Kirim request
    var response = await request.send();

    // 200 adalah status code untuk "OK" (update sukses)
    if (response.statusCode != 200) {
      final respStr = await response.stream.bytesToString();
      throw Exception(
        'Gagal memperbarui produk. Status: ${response.statusCode}, Body: $respStr',
      );
    }
  }

  Future<void> deleteProduct({required int productId}) async {
    print('--- DEBUG PROSES UPDATE ---');
    print('Data Fields: {id: $productId}');
    print('---------------------------');

    final response = await http.delete(
      Uri.parse('$_baseUrl/$productId'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus produk.');
    }
  }
}
