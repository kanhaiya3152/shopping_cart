import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_cart/product_model.dart';
import 'package:shopping_cart/service.dart';

final productProvider = FutureProvider<List<Product>>((ref) async {
  return ProductService().fetchProducts();
});

class CartNotifier extends StateNotifier<List<Product>> {
  CartNotifier() : super([]);

  void addToCart(Product product) {
    state = state.map((p) {
      if (p.id == product.id) {
        return p.copyWith(quantity: p.quantity + 1); 
      }
      return p;
    }).toList();

    if (!state.any((p) => p.id == product.id)) {
      state = [...state, product.copyWith(quantity: 1)];
    }
  }

  void increaseQuantity(Product product) {
    state = state.map((p) {
      if (p.id == product.id) {
        return p.copyWith(quantity: p.quantity + 1);
      }
      return p;
    }).toList();
  }

  void decreaseQuantity(Product product) {
    state = state
        .map((p) => p.id == product.id ? p.copyWith(quantity: p.quantity - 1) : p)
        .where((p) => p.quantity > 0) 
        .toList();
  }

  void clearCart() {
    state = []; 
  }

  double get totalPrice => state.fold(
        0,
        (sum, item) => sum + (item.discountedPrice * item.quantity),
      );
}

final cartProvider = StateNotifierProvider<CartNotifier, List<Product>>((ref) => CartNotifier());
