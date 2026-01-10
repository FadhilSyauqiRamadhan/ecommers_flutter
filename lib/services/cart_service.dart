import '../config.dart';
import 'api_client.dart';
import '../models/cart_item.dart';

class CartService {
  final ApiClient _api = ApiClient();

  Future<List<CartItem>> fetchCart(int userId) async {
    final res = await _api.get('${Config.cartBase}/carts/user/$userId');
    final data = (res is Map<String, dynamic>) ? res['data'] : null;

    if (data is List) {
      return data.map((e) => CartItem.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<void> addToCart({
    required int userId,
    required int productId,
    required int quantity,
    required double price,
  }) async {
    await _api.post('${Config.cartBase}/carts', {
      'userId': userId,
      'productId': productId,
      'quantity': quantity,
      'price': price,
    });
  }

  Future<void> updateCartItem(int cartItemId, int quantity) async {
    await _api.put('${Config.cartBase}/carts/$cartItemId', {
      'quantity': quantity,
    });
  }

  Future<void> deleteCartItem(int cartItemId) async {
    await _api.delete('${Config.cartBase}/carts/$cartItemId');
  }

  Future<void> clearCart(int userId) async {
    await _api.delete('${Config.cartBase}/carts/user/$userId');
  }
}
