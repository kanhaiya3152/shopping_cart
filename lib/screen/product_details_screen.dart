import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_cart/product_model.dart';
import 'package:shopping_cart/provider.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final cart = ref.watch(cartProvider);
    final isInCart = cart.any((p) => p.id == product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                    height: 250,
                    width: double.infinity,
                    child: Image.network(product.thumbnail, fit: BoxFit.cover),
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: product.images.map((image) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(image, width: 70, height: 70, fit: BoxFit.cover),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("Brand: ${product.brand}", style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  Text("Category: ${product.category}", style: const TextStyle(fontSize: 16, color: Colors.grey)),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "₹${product.price.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 16, color: Colors.grey, decoration: TextDecoration.lineThrough),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "₹${product.discountedPrice.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Text("${product.discountPercentage}% OFF", style: const TextStyle(fontSize: 16, color: Colors.red)),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text("${product.rating}", style: const TextStyle(fontSize: 16)),
                      const Spacer(),
                      Text(
                        product.stock > 0 ? "In Stock (${product.stock} left)" : "Out of Stock",
                        style: TextStyle(fontSize: 16, color: product.stock > 0 ? Colors.green : Colors.red),
                      ),
                    ],
                  ),

                  const Divider(height: 30, color: Colors.grey),

                  // Additional Information
                  _buildInfoRow("Weight", "${product.weight} kg"),
                  _buildInfoRow("Warranty", product.warrantyInformation),
                  _buildInfoRow("Shipping", product.shippingInformation),
                  _buildInfoRow("Availability", product.availabilityStatus),
                  _buildInfoRow("Return Policy", product.returnPolicy),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    ),
                    onPressed: isInCart ? null : () => cartNotifier.addToCart(product),
                    child: Text(isInCart ? "Already in Cart" : "Add to Cart", style: const TextStyle(color: Colors.white)),
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
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}
