import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartItemDetailScreen extends StatelessWidget {
  final CartItem item;
  const CartItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final subtotal = item.price * item.quantity;

    Widget infoRow(String label, String value, {bool bold = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: Colors.grey[700])),
            Text(
              value,
              style: TextStyle(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Cart Item'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.12),
                      child: Icon(Icons.shopping_bag, color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Cart Item #${item.id}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                infoRow('User ID', '${item.userId}'),
                infoRow('Product ID', '${item.productId}'),
                infoRow('Quantity', '${item.quantity}'),
                infoRow('Price', item.price.toStringAsFixed(0)),
                const Divider(),
                infoRow('Subtotal', subtotal.toStringAsFixed(0), bold: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
