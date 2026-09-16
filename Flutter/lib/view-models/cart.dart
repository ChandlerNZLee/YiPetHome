// lib/view-models/cart.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'product.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  void addToCart({
    required ProductData product,
    required ProductStockData stock,
    int quantity = 1,
  }) {
    if (quantity <= 0) {
      return;
    }

    final index = state.indexWhere(
      (item) => item.product.id == product.id && item.stock.id == stock.id,
    );

    if (index != -1) {
      final currentItem = state[index];
      var newQuantity = currentItem.quantity + quantity;
      final availableStock = stock.stock;
      if (availableStock > 0 && newQuantity > availableStock) {
        newQuantity = availableStock;
      }

      final newItems = [...state];
      newItems[index] = currentItem.copyWith(quantity: newQuantity);
      state = newItems;

      return;
    }

    var initialQuantity = quantity;
    if (stock.stock > 0 && initialQuantity > stock.stock) {
      initialQuantity = stock.stock;
    }

    state = [
      ...state,
      CartItem(product: product, stock: stock, quantity: initialQuantity),
    ];
  }

  void increaseQuantity(CartItem item) {
    final index = _findItemIndex(item);
    if (index == -1) {
      return;
    }

    final currentItem = state[index];
    if (currentItem.stock.stock > 0 &&
        currentItem.quantity >= currentItem.stock.stock) {
      return;
    }

    final newItems = [...state];
    newItems[index] = currentItem.copyWith(quantity: currentItem.quantity + 1);
    state = newItems;
  }

  void decreaseQuantity(CartItem item) {
    final index = _findItemIndex(item);
    if (index == -1) {
      return;
    }

    final currentItem = state[index];
    if (currentItem.quantity <= 1) {
      removeItem(currentItem);
      return;
    }

    final newItems = [...state];
    newItems[index] = currentItem.copyWith(quantity: currentItem.quantity - 1);
    state = newItems;
  }

  void setQuantity(CartItem item, int quantity) {
    final index = _findItemIndex(item);
    if (index == -1) {
      return;
    }

    if (quantity <= 0) {
      removeItem(item);
      return;
    }

    final currentItem = state[index];
    var newQuantity = quantity;
    if (currentItem.stock.stock > 0 && newQuantity > currentItem.stock.stock) {
      newQuantity = currentItem.stock.stock;
    }

    final newItems = [...state];
    newItems[index] = currentItem.copyWith(quantity: newQuantity);
    state = newItems;
  }

  void removeItem(CartItem item) {
    state = state
        .where(
          (element) =>
              !(element.product.id == item.product.id &&
                  element.stock.id == item.stock.id),
        )
        .toList();
  }

  void removeById({required int productId, required int stockId}) {
    state = state
        .where(
          (item) => !(item.product.id == productId && item.stock.id == stockId),
        )
        .toList();
  }

  void clear() {
    state = [];
  }

  int _findItemIndex(CartItem item) {
    return state.indexWhere(
      (element) =>
          element.product.id == item.product.id &&
          element.stock.id == item.stock.id,
    );
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);

final cartTotalQuantityProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold<int>(0, (sum, item) => sum + item.quantity);
});

final cartSubtotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
});

final cartIsEmptyProvider = Provider<bool>((ref) {
  final items = ref.watch(cartProvider);
  return items.isEmpty;
});

class CartItem {
  final ProductData product;
  final ProductStockData stock;
  int quantity;

  CartItem({required this.product, required this.stock, this.quantity = 1});

  double get unitPrice {
    return stock.price * stock.discount;
  }

  double get totalPrice {
    return unitPrice * quantity;
  }

  CartItem copyWith({
    ProductData? product,

    ProductStockData? stock,

    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      stock: stock ?? this.stock,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartColors {
  static const primary = Color(0xFF22C55E);
  static const textPrimary = Color(0xFF17191D);
  static const textSecondary = Color(0xFF747982);
}
