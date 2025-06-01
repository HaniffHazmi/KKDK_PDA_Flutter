import 'package:flutter/material.dart';
import 'package:flutterapp/payment/cart_summary_bar.dart';
import '../../payment/cart_parcel_list.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: const CartParcelList(),
      bottomNavigationBar: CartSummaryBar(),
    );
  }
}
