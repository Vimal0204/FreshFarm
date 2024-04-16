import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freshfarm/model/seller.dart';
import 'package:http/http.dart' as http;

class OrderReceivedWidget extends StatelessWidget {
  final int orderId;
  // final int customerId;
  // final int productId;
  // final String productName;
  final int quantity;
  final double amount;
  final String? status;

  OrderReceivedWidget({
    required this.orderId,
    // required this.customerId,
    // required this.productId,
    // required this.productName,
    required this.quantity,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: $orderId'),
            // Text('Customer ID: $customerId'),
            // Text('Product ID: $productId'),
            // Text('Product Name: $productName'),
            Text('Quantity: $quantity'),
            Text('Amount: \$${amount.toString()}'),
            Text('Status: $status'),
          ],
        ),
      ),
    );
  }
}

class OrdersReceivedScreen extends StatefulWidget {
  const OrdersReceivedScreen({super.key, required this.seller});
  final Seller seller;

  @override
  State<OrdersReceivedScreen> createState() => _OrdersReceivedScreenState();
}

class _OrdersReceivedScreenState extends State<OrdersReceivedScreen> {
  List<OrderReceivedWidget> orders = [];
  @override
  void initState() {
    _loadOrders();
    super.initState();
  }

  void _loadOrders() async {
    final url = Uri.http('freshfarm.azurewebsites.net',
        '/api/orderByFarmerMail/${widget.seller.email}');
    final response = await http.get(url);
    final List<dynamic> data = json.decode(response.body);
    print(data);
    final List<OrderReceivedWidget> orderFarmer = data
        .map(
          (e) => OrderReceivedWidget(
            orderId: e['id'],
            quantity: e['quantity'],
            amount: e['amount'],
            status: e['status'],
          ),
        )
        .toList();
    setState(
      () {
        orders = orderFarmer;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Received'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quantity: ${order.quantity.toString()}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Amount: \$${order.amount.toString()}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Order ID: ${order.orderId.toString()}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Status: ${order.status}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
