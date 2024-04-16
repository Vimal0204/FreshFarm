import 'package:flutter/material.dart';
import 'package:freshfarm/Screens/buyerHome/buyers_home.dart';

class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Placed'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your order has been placed successfully!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (ctx) => const BuyersHomeScreen(),
                  ),
                );
              },
              child:const Text('Go to Home Screen'),
            ),
          ],
        ),
      ),
    );
  }
}