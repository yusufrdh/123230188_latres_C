import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com/products'; //

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List productsJson = data['products'] ?? [];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data produk dari server');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }
}