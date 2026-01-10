class CartItem {
  final String id;
  final String userId;
  final String productId;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> j) => CartItem(
        id: j['id']?.toString() ?? '',
        userId: j['userId']?.toString() ?? '',
        productId: j['productId']?.toString() ?? '',
        quantity: (j['quantity'] is int)
            ? j['quantity'] as int
            : int.tryParse('${j['quantity']}') ?? 1,
        price: (j['price'] is num)
            ? (j['price'] as num).toDouble()
            : double.tryParse('${j['price']}') ?? 0.0,
      );
}
