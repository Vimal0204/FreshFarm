import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm/widget/customer_drawer.dart';
import 'package:fresh_farm/widget/seller_list.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void onSelectOption(String identifier) {
      Navigator.of(context).pop();
    }

    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
      ),
      drawer: MainDrawer(
        onSelectOption: onSelectOption,
        customerName: FirebaseAuth.instance.currentUser?.email,
      ),
      body: const SellerList(),
    );
  }
}
