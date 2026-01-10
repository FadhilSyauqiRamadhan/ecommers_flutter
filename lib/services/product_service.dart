import '../config.dart';
import 'api_client.dart';
import '../models/product.dart';

class ProductService {
  final ApiClient _api = ApiClient();

  Future<List<Product>> fetchProducts() async {
    final res = await _api.get('${Config.productBase}/products');
    final data = (res is Map<String, dynamic>) ? res['data'] : null;
    if (data is List) {
      return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<Product> createProduct(String name, double price, String description) async {
    final res = await _api.post('${Config.productBase}/products', {
      'name': name,
      'price': price,
      'description': description,
    });
    final data = (res is Map<String, dynamic>) ? res['data'] : null;
    return Product.fromJson(data as Map<String, dynamic>);
  }

  Future<Product> updateProduct(String id, String name, double price, String description) async {
    final res = await _api.put('${Config.productBase}/products/$id', {
      'name': name,
      'price': price,
      'description': description,
    });
    final data = (res is Map<String, dynamic>) ? res['data'] : null;
    return Product.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteProduct(String id) async {
    await _api.delete('${Config.productBase}/products/$id');
  }
}
