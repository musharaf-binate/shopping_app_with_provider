import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/core/models/products_model.dart';
import 'package:shopping_app/core/providers/cart.dart';
import 'package:shopping_app/utils/app_colors.dart';
import 'package:shopping_app/utils/utils.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cart"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<Cart>(
              builder: (context, cart, child) => Flexible(
                flex: 8,
                child: cart.cartLength == 0
                    ? const Text("Cart is Empty")
                    : ListView(
                        children: List.generate(cart.cartLength, (index) {
                        ProductModel cartItem = cart.items[index];
                        return ListTile(
                          leading: Image(image: NetworkImage(cartItem.image)),
                          subtitle: Text("Qty: ${cartItem.quantity}"),
                          title: Text(
                            Utils.shortenTitle(cartItem.title),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    cart.removeItemFromCart(cartItem.id);
                                  },
                                  icon: const Icon(Icons.remove)),
                              Text("${cartItem.quantity}"),
                              IconButton(
                                  onPressed: () {
                                    cart.addItemToCart(cartItem);
                                  },
                                  icon: const Icon(Icons.add)),
                            ],
                          ),
                        );
                      })),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(color: AppColors.primaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        "Total: \$${context.select((Cart cart) => cart.totalPrice).toStringAsFixed(2)}"),
                    TextButton(
                      onPressed: () {
                        Provider.of<Cart>(context, listen: false)
                            .removeAllItemsFromCart();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => AppColors.secondaryColor)),
                      child: const Text("Buy"),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
