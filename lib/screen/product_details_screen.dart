import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_cart/product_model.dart';
import 'package:shopping_cart/cart_provider.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final cart = ref.watch(cartProvider);
    final isInCart = cart.any((p) => p.id == product.id);

    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05, // Responsive font size
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Thumbnails
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.3, // Responsive height
                    width: double.infinity,
                    child: Image.network(product.thumbnail, fit: BoxFit.cover),
                  ),
                  SizedBox(
                    height: screenHeight * 0.1, // Responsive height
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: product.images.map((image) {
                        return Padding(
                          padding: EdgeInsets.all(screenWidth * 0.02), // Responsive padding
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(screenWidth * 0.02), // Responsive border radius
                            child: Image.network(
                              image,
                              width: screenWidth * 0.15, // Responsive width
                              height: screenWidth * 0.15, // Responsive height
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.06, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.02), 
                  Text(
                    "Brand: ${product.brand}",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "Category: ${product.category}",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04, 
                      color: Colors.grey,
                    ),
                  ),

                  SizedBox(height: screenWidth * 0.03), 
                  Row(
                    children: [
                      Text(
                        "₹${product.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04, 
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02), 
                      Text(
                        "₹${product.discountedPrice.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02), 
                      Text(
                        "${product.discountPercentage}% OFF",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04, 
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenWidth * 0.03), 
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: screenWidth * 0.05, 
                      ),
                      Text(
                        "${product.rating}",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04, 
                        ),
                      ),
                      const Spacer(),
                      Text(
                        product.stock > 0 ? "In Stock (${product.stock} left)" : "Out of Stock",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04, 
                          color: product.stock > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),

                  Divider(
                    height: screenWidth * 0.08, 
                    color: Colors.grey,
                  ),

                  _buildInfoRow("Weight", "${product.weight} kg", screenWidth),
                  _buildInfoRow("Warranty", product.warrantyInformation, screenWidth),
                  _buildInfoRow("Shipping", product.shippingInformation, screenWidth),
                  _buildInfoRow("Availability", product.availabilityStatus, screenWidth),
                  _buildInfoRow("Return Policy", product.returnPolicy, screenWidth),

                  SizedBox(height: screenWidth * 0.05), 
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                          vertical: screenWidth * 0.03, 
                          horizontal: screenWidth * 0.1, 
                        ),
                      ),
                      onPressed: isInCart ? null : () => cartNotifier.addToCart(product),
                      child: Text(
                        isInCart ? "Already in Cart" : "Add to Cart",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.035, 
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for additional info rows
  Widget _buildInfoRow(String title, String value, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01), // Responsive padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.04, // Responsive font size
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.04, // Responsive font size
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}