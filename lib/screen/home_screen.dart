import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:shopping_cart/screen/cart_screen.dart';
import 'package:shopping_cart/screen/product_details_screen.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsyncValue = ref.watch(productProvider);
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    
    final crossAxisCount = screenWidth > 600 ? 3 : 2; 
    final childAspectRatio = screenWidth / (screenHeight / 1.5);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Catalogue',
          style: TextStyle(
            color: Colors.black,
            fontSize: screenWidth * 0.067, 
          ),
        ),
        backgroundColor: Colors.pink[50],
        centerTitle: true,
        elevation: 1,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                  size: screenWidth * 0.07, 
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartScreen()));
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: screenWidth * 0.016,
                  top: screenWidth * 0.013,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: screenWidth * 0.02, 
                    child: Text(
                      cart.length.toString(),
                      style: TextStyle(
                        fontSize: screenWidth * 0.03, 
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.pink[50], 
      body: productAsyncValue.when(
        data: (products) {
          return GridView.builder(
            padding: EdgeInsets.all(screenWidth * 0.02), 
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount, 
              crossAxisSpacing: screenWidth * 0.02, 
              mainAxisSpacing: screenWidth * 0.02, 
              childAspectRatio: childAspectRatio, 
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final isInCart = cart.any(
                  (p) => p.id == product.id); 

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
                      borderRadius: BorderRadius.circular(screenWidth * 0.03)),
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(screenWidth * 0.03),
                              topRight: Radius.circular(screenWidth * 0.03),
                            ),
                            child: Image.network(
                              product.thumbnail,
                              width: double.infinity,
                              height: screenHeight * 0.15, 
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: screenWidth * 0.02,
                            right: screenWidth * 0.02,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.03,
                                  vertical: screenWidth * 0.01,
                                ),
                                minimumSize: Size(
                                  screenWidth * 0.1,
                                  screenWidth * 0.05,
                                ), 
                              ),
                              onPressed: isInCart
                                  ? null 
                                  : () => cartNotifier.addToCart(product),
                              child: Text(
                                "Add",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.03, 
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenWidth * 0.01,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.042, 
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.01), 
                            Text(
                              product.brand,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: screenWidth * 0.032, 
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.02), 
                            Row(
                              children: [
                                Text(
                                  "₹${product.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035, 
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.01), 
                                Text(
                                  "₹${product.discountedPrice.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04, 
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "${product.discountPercentage}% OFF",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: screenWidth * 0.03, 
                              ),
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