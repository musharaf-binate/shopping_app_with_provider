import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/core/models/products_model.dart';
import 'package:shopping_app/core/providers/products_list.dart';
import 'package:shopping_app/core/screens/cart_screen.dart';
import 'package:shopping_app/utils/app_colors.dart';
import 'package:shopping_app/utils/utils.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/cart.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("Products Screen screen was rebuilt");
    return Scaffold(
        appBar: AppBar(
          title: const Text("Exclusive Products"),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: badges.Badge(
                  badgeStyle: const badges.BadgeStyle(
                      badgeColor: AppColors.primaryColor),
                  badgeContent: Consumer<Cart>(
                    builder: (context, cart, child) =>
                        Text("${cart.cartLength}"),
                  ),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CartScreen()));
                      },
                      child: const Icon(Icons.shopping_cart)),
                  onTap: () {},
                ))
          ],
        ),
        body: Consumer<ProductList>(
          builder: (context, productsList, child) {
            return Center(
                child: productsList.isDateLoading
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text("(Fetching Products)")
                        ],
                      )
                    : ListView(
                        children: List.generate(productsList.products.length,
                            (index) {
                          ProductModel product = productsList.products[index];
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            height: 310,
                            width: 200,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blueAccent, width: 2),
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              children: [
                                Image(
                                  image: NetworkImage(product.image),
                                  loadingBuilder: (context, child,
                                          loadingProgress) =>
                                      loadingProgress != null
                                          ? const SizedBox(
                                              height: 200,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircularProgressIndicator(),
                                                  Text("loading Image"),
                                                ],
                                              ))
                                          : child,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.fill,
                                ),
                                Text(Utils.shortenTitle(product.title)),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Price: \$${product.price}"),
                                      Text(
                                          "Rating: ${product.rating.rate} (${product.rating.count})")
                                    ],
                                  ),
                                ),
                                AddItemButton(product: product)
                              ],
                            ),
                          );
                        }),
                      ));
          },
        ));
  }
}

class AddItemButton extends StatelessWidget {
  const AddItemButton({
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    debugPrint("Add Item Button Widget was rebuilt");

    // bool isInCar = context
    //     .select<Cart, bool>((value) => value.getItemQuantity(product.id) <= 0);
    return
        //  isInCar
        //     ?
        Consumer<Cart>(
            builder: (context, cart, child) => cart.getItemQuantity(product) <=
                    0
                ? TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => AppColors.primaryColor)),
                    onPressed: () {
                      context.read<Cart>().addItemToCart(product);
                    },
                    child: const Text("Add to Cart"),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            context.read<Cart>().removeItemFromCart(product.id);
                          },
                          icon: const Icon(Icons.remove)),
                      Text("${product.quantity}"),
                      IconButton(
                          onPressed: () {
                            context.read<Cart>().addItemToCart(product);
                            // cart.addItemToCart(cartItem);
                          },
                          icon: const Icon(Icons.add)),
                    ],
                  ));
  }
}
