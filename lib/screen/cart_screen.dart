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
            fontSize: screenWidth * 0.06, // Responsive font size
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: screenWidth * 0.06, // Responsive icon size
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
                        fontSize: screenWidth * 0.05, // Responsive font size
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final product = cart[index];
                      return Card(
                        margin: EdgeInsets.all(screenWidth * 0.03), // Responsive margin
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.03), // Responsive padding
                          child: Row(
                            children: [
                              // Product Image
                              Image.network(
                                product.thumbnail,
                                width: screenWidth * 0.2, // Responsive width
                                height: screenWidth * 0.2, // Responsive height
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: screenWidth * 0.03), // Responsive spacing
                              // Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.045, // Responsive font size
                                      ),
                                    ),
                                    Text(
                                      product.brand,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: screenWidth * 0.035, // Responsive font size
                                      ),
                                    ),
                                    Text(
                                      "₹${(product.price * (1 - product.discountPercentage / 100)).toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04, // Responsive font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${product.discountPercentage}% OFF",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: screenWidth * 0.035, // Responsive font size
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: screenWidth * 0.04, // Responsive icon size
                                        ),
                                        Text(
                                          product.rating.toString(),
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.035, // Responsive font size
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Quantity Controls
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.remove,
                                      size: screenWidth * 0.05, // Responsive icon size
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
          // Total Price and Checkout Button
          Container(
            padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
            decoration: BoxDecoration(
              color: const Color(0xFFF8D7DA),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(screenWidth * 0.05), // Responsive radius
                topRight: Radius.circular(screenWidth * 0.05), // Responsive radius
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
                        fontSize: screenWidth * 0.05, // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₹${totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05, // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.03), // Responsive spacing
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(
                      vertical: screenWidth * 0.03, // Responsive vertical padding
                      horizontal: screenWidth * 0.1, // Responsive horizontal padding
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
                      fontSize: screenWidth * 0.045, // Responsive font size
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

  // Function to show a confirmation dialog before checkout
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
                cartNotifier.clearCart(); // Clear the cart
                Navigator.pop(context); // Close the dialog
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
