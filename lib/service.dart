import 'package:dio/dio.dart';
import 'package:shopping_cart/product_model.dart';

class ProductService {
  final Dio _dio = Dio();

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _dio.get('https://dummyjson.com/products');
      
      if (response.statusCode == 200) {
        final List data = response.data['products']; // Extract "products" list
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products - Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Error fetching products: $e"); // Debugging
      throw Exception('Error fetching products: $e'); 
    }
  }
}
