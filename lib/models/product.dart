class Product {
  final String id;
  final String name;
  final String description;
  final double price;

  Product({required this.id, required this.name, required this.description, required this.price});

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id']?.toString() ?? '',
        name: j['name'] ?? '',
        description: j['description'] ?? '',
        price: (j['price'] is num) ? (j['price'] as num).toDouble() : double.tryParse('${j['price']}') ?? 0.0,
      );
}
