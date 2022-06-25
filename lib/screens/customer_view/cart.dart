import 'package:ccr_multistore_app/models/cart.dart';
import 'package:ccr_multistore_app/screens/customer_view/place_order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double total = context.watch<Cart>().totalPrice;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Cart"),
        centerTitle: true,
        actions: [
          context.watch<Cart>().getItems.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          "Warning",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        ),
                        content: const Text(
                            "Are you sure you want to clear your cart?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              context.read<Cart>().clearCart();
                              Navigator.pop(context);
                            },
                            child: const Text("Yes"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("No"),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_forever),
                )
              : Container(width: 0),
        ],
      ),
      body: context.watch<Cart>().getItems.isNotEmpty
          ? const CartItem()
          : const EmptyCart(),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Your shopping cart is empty!",
            style: TextStyle(fontSize: 27),
          ),
          Text(
            "Visit the shop to add some items.",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, cart, child) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: cart.count,
                itemBuilder: (context, i) {
                  final product = cart.getItems[i];
                  return SingleChildScrollView(
                    child: Card(
                      child: SizedBox(
                        height: 100,
                        child: Row(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 120,
                              child: Image.network(
                                product.imageUrl,
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(product.title),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "EGP ${product.price.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            color: Colors.teal,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        product.quantity == 1
                                            ? IconButton(
                                                onPressed: () {
                                                  cart.removeItem(product);
                                                },
                                                icon: const Icon(
                                                    Icons.delete_forever),
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  cart.decrement(product);
                                                },
                                                icon: const Icon(Icons.remove),
                                              ),
                                        Text(
                                          product.quantity.toString(),
                                          style: product.quantity ==
                                                  product.inStock
                                              ? const TextStyle(
                                                  color: Colors.red)
                                              : const TextStyle(),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            product.quantity == product.inStock
                                                ? null
                                                : cart.increment(product);
                                          },
                                          icon: Icon(Icons.add,
                                              color: product.quantity ==
                                                      product.inStock
                                                  ? Colors.grey
                                                  : null),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total:"),
                Text(
                  "EGP ${context.watch<Cart>().totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                context.watch<Cart>().totalPrice == 0
                    ? const SizedBox(
                        width: 0,
                        height: 0,
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PlaceOrderScreen()));
                        },
                        child: const Text("Checkout"),
                      ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
