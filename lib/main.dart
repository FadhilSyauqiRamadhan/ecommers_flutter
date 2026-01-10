import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/product_service.dart';
import 'services/cart_service.dart';
import 'services/review_service.dart';
import 'services/user_service.dart';

import 'screens/product_list_screen.dart';
import 'screens/user_list_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ProductService()),
        Provider(create: (_) => CartService()),
        Provider(create: (_) => ReviewService()),
        Provider(create: (_) => UserService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int idx = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ProductListScreen(),
      const UserListScreen(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: pages[idx],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: idx,
          onTap: (v) => setState(() => idx = v),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Produk'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Pengguna'),
          ],
        ),
      ),
    );
  }
}
