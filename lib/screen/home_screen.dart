import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_cart/provider.dart';
import 'package:shopping_cart/screen/cart_screen.dart';
import 'package:shopping_cart/screen/product_details_screen.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsyncValue = ref.watch(productProvider);
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.black),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartScreen()));
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 5,
                  top: 5,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 8,
                    child: Text(
                      cart.length.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.pink[50], // Light pink background
      body: productAsyncValue.when(
        data: (products) {
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two items per row
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.65, // Adjust height-to-width ratio
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final isInCart = cart.any(
                  (p) => p.id == product.id); // Check if product is in cart

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(product: product)),
                  );
                },
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.network(
                              product.thumbnail,
                              width: double.infinity,
                              height: 120, // Fixed height for uniformity
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                minimumSize: const Size(40, 30),
                              ),
                              onPressed: isInCart
                                  ? null // Disable button if already in cart
                                  : () => cartNotifier.addToCart(product),
                              child: const Text("Add",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(product.brand,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  "₹${product.price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    decoration: TextDecoration
                                        .lineThrough, // Strike-through original price
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "₹${product.discountedPrice.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              "${product.discountPercentage}% OFF",
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            const Center(child: Text("Error loading products")),
      ),
    );
  }
}
