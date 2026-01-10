import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../services/review_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final int userId;
  const ProductDetailScreen({super.key, required this.product, required this.userId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<List<dynamic>> _reviewsFuture;

  final ratingCtrl = TextEditingController();
  final commentCtrl = TextEditingController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _reloadReviews();
  }

  void _reloadReviews() {
    final reviewSvc = Provider.of<ReviewService>(context, listen: false);
    setState(() {
      _reviewsFuture = reviewSvc.fetchReviews(int.parse(widget.product.id));
    });
  }

  @override
  void dispose() {
    ratingCtrl.dispose();
    commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartSvc = Provider.of<CartService>(context, listen: false);
    final reviewSvc = Provider.of<ReviewService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text(widget.product.description, style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(.10),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Rp ${widget.product.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () async {
                        try {
                          await cartSvc.addToCart(
                            userId: widget.userId,
                            productId: int.parse(widget.product.id),
                            quantity: 1,
                            price: widget.product.price,
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal add cart: $e')));
                        }
                      },
                      label: const Text('Add to cart'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),
          const Text('Ulasan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),

          const SizedBox(height: 10),
          FutureBuilder<List<dynamic>>(
            future: _reviewsFuture,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Padding(padding: EdgeInsets.all(8), child: Center(child: CircularProgressIndicator()));
              }
              if (snap.hasError) return Text('Error: ${snap.error}');
              final list = snap.data ?? [];
              if (list.isEmpty) {
                return Text('Belum ada ulasan', style: TextStyle(color: Colors.grey[700]));
              }

              return Column(
                children: list.map((r) {
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.withOpacity(.12),
                        child: const Icon(Icons.star),
                      ),
                      title: Text('Rating: ${r['rating']}', style: const TextStyle(fontWeight: FontWeight.w800)),
                      subtitle: Text('${r['review']}'),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 8),

          const Text('Tambah Ulasan', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),

          TextField(
            controller: ratingCtrl,
            decoration: const InputDecoration(
              labelText: 'Rating (1-5)',
              prefixIcon: Icon(Icons.star),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: commentCtrl,
            decoration: const InputDecoration(
              labelText: 'Komentar',
              prefixIcon: Icon(Icons.chat_bubble_outline),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _sending
                  ? null
                  : () async {
                      final rating = int.tryParse(ratingCtrl.text) ?? 5;
                      final comment = commentCtrl.text.trim();

                      if (comment.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Komentar tidak boleh kosong')));
                        return;
                      }

                      setState(() => _sending = true);

                      try {
                        await reviewSvc.postReview(int.parse(widget.product.id), rating, comment);
                        await Future.delayed(const Duration(milliseconds: 250));
                        ratingCtrl.clear();
                        commentCtrl.clear();
                        _reloadReviews();
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal kirim ulasan: $e')));
                      } finally {
                        if (mounted) setState(() => _sending = false);
                      }
                    },
              child: Text(_sending ? 'Mengirim...' : 'Kirim Ulasan'),
            ),
          ),
        ],
      ),
    );
  }
}
