import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class ProductService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.18.38:8000', // host PC dari Android Emulator
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<void> addProduct({
    required String name,
    required String storage,
    required String price,
    required Uint8List imageBytes,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'storage': storage,
      'price': price,
      'image': MultipartFile.fromBytes(
        imageBytes,
        filename: 'product.jpg',
        contentType: MediaType('image', 'jpeg'),
      ),
    });

    await _dio.post('/api/products', data: formData); // path dan metode tepat
  }
}
