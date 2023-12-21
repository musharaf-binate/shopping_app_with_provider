import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/core/providers/cart.dart';
import 'package:shopping_app/core/providers/products_list.dart';
import 'package:shopping_app/core/screens/products_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ProductList()),
          ChangeNotifierProvider(create: (context) => Cart()),
        ],
        builder: (context, child) => const MaterialApp(
            debugShowCheckedModeBanner: false, home: ProductsScreen()));
  }
}
