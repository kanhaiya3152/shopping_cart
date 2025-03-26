import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_cart/product_model.dart';
import 'package:shopping_cart/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    // Calculate total price
    double totalPrice = cart.fold(0, (sum, item) => sum + (item.price * (1 - item.discountPercentage / 100) * item.quantity));

    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
          style: TextStyle(
            fontSize: screenWidth * 0.06, 
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: screenWidth * 0.06, 
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Text(
                      "Your cart is empty",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05, 
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final product = cart[index];
                      return Card(
                        margin: EdgeInsets.all(screenWidth * 0.03), 
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.03), 
                          child: Row(
                            children: [
                              Image.network(
                                product.thumbnail,
                                width: screenWidth * 0.2,
                                height: screenWidth * 0.2, 
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: screenWidth * 0.03), 
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.045, 
                                      ),
                                    ),
                                    Text(
                                      product.brand,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: screenWidth * 0.035,
                                      ),
                                    ),
                                    Text(
                                      "₹${(product.price * (1 - product.discountPercentage / 100)).toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04, 
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${product.discountPercentage}% OFF",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: screenWidth * 0.035, 
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: screenWidth * 0.04, 
                                        ),
                                        Text(
                                          product.rating.toString(),
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.035, 
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.remove,
                                      size: screenWidth * 0.05, 
                                    ),
                                    onPressed: () => cartNotifier.decreaseQuantity(product),
                                  ),
                                  Text(
                                    product.quantity.toString(),
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.04, // Responsive font size
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      size: screenWidth * 0.05, // Responsive icon size
                                    ),
                                    onPressed: () => cartNotifier.increaseQuantity(product),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.all(screenWidth * 0.04), 
            decoration: BoxDecoration(
              color: const Color(0xFFF8D7DA),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(screenWidth * 0.05), 
                topRight: Radius.circular(screenWidth * 0.05), 
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Price",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₹${totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.03), 
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(
                      vertical: screenWidth * 0.03, 
                      horizontal: screenWidth * 0.1, 
                    ),
                  ),
                  onPressed: () {
                    if (cart.isNotEmpty) {
                      _showCheckoutDialog(context, cartNotifier);
                    }
                  },
                  child: Text(
                    "Check Out (${cart.length})",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045, 
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context, CartNotifier cartNotifier) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Checkout"),
          content: const Text("Are you sure you want to checkout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                cartNotifier.clearCart(); 
                Navigator.pop(context); 
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Checkout successful! Your cart is now empty.")),
                );
              },
              child: const Text("Yes, Checkout"),
            ),
          ],
        );
      },
    );
  }
}
