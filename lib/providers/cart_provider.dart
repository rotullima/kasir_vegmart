// lib/providers/cart_provider.dart
import 'package:flutter/material.dart';

class CartItem {
  final int produkId;
  final String namaProduk;
  final String gambar;
  final double harga;
  int qty;
  double diskonItem = 0;

  CartItem({
    required this.produkId,
    required this.namaProduk,
    required this.gambar,
    required this.harga,
    this.qty = 1,
  });

  double get subtotal => (harga * qty) - diskonItem;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.qty);

  double get total => _items.fold(0.0, (sum, item) => sum + item.subtotal);

  void addItem(CartItem newItem) {
    final existing = _items.firstWhere(
      (item) => item.produkId == newItem.produkId,
      orElse: () => CartItem(produkId: -1, namaProduk: '', gambar: '', harga: 0),
    );

    if (existing.produkId != -1) {
      existing.qty += newItem.qty;
    } else {
      _items.add(newItem);
    }
    notifyListeners();
  }

  void removeItem(int produkId) {
    _items.removeWhere((item) => item.produkId == produkId);
    notifyListeners();
  }

  void updateQty(int produkId, int newQty) {
    if (newQty <= 0) {
      removeItem(produkId);
      return;
    }
    final item = _items.firstWhere((item) => item.produkId == produkId);
    item.qty = newQty;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}