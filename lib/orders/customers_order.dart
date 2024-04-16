import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshfarm/Screens/verify_screen.dart';
import 'package:freshfarm/model/order.dart';
import 'package:http/http.dart' as http;

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> orders = [];
  @override
  void initState() {
    _loadOrders();
    super.initState();
  }

  void _loadOrders() async {
    final url = Uri.http('freshfarm.azurewebsites.net',
        '/api/orderByCustomerMail/${FirebaseAuth.instance.currentUser!.email}');
    final response = await http.get(url);
    print(response.statusCode);
    final List<dynamic> data = json.decode(response.body);
    print(data);
    List<Order> loadOrder = data
        .map(
          (e) => Order(
            quantity: e['quantity'],
            amount: e['amount'],
            orderId: e['id'],
            status: e['status'],
            // productId: e['productId'],
          ),
        )
        .toList();
    setState(
      () {
        orders = loadOrder;
      },
    );
  }

  void sendEmail(int id, int quantity, double amount) async {
    final url = Uri.https('freshfarmmail.azurewebsites.net', '/api/customerMail/OrderCancelled');
    await http.post(
      url,
      headers: {'content-type': 'application/json'},
      body: json.encode(
        {
          'to': FirebaseAuth.instance.currentUser!.email,
          'customerName': FirebaseAuth.instance.currentUser!.displayName,
          'orderId': id,
          'quantity': quantity,
          'totalAmount': amount,
        },
      ),
    );
  }

  void sendEmailFarmer(int id, int quantity, double amount) async {
    final urlEmail=Uri.https('freshfarm.azurewebsites.net','/api/farmerEmailByOrderId/$id');
    final get=await http.get(urlEmail);
    final sellerEmail=get.body;
    print(sellerEmail);
    final url = Uri.https('freshfarmmail.azurewebsites.net', '/api/farmerMail/OrderCancelled');
    await http.post(
      url,
      headers: {'content-type': 'application/json'},
      body: json.encode(
        {
          'to': sellerEmail,
          'orderId': id,
          'quantity': quantity,
          'totalAmount': amount,
        },
      ),
    );
  }

  void _cancelOrder(int id, int quantity, double amount) async {
    final url = Uri.https(
      'freshfarm.azurewebsites.net',
      'api/order/$id',
    );
    await http.put(
      url,
      headers: {'content-type': 'application/json'},
      body: json.encode(
        {
          'status': 'cancelled',
        },
      ),
    );
    setState(
      () {
        _loadOrders();
      },
    );
    sendEmail(id,quantity,amount);
    // send farmer ko dekhna h kyun nhi ho rha h yeh 
    // sendEmailFarmer(id, quantity, amount);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
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
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Cancel Order'),
                                content: const Text(
                                    'Are you sure you want to cancel this order?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // Perform cancellation logic here
                                      // For now, just remove the order from the list
                                      var verify =
                                          await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              const VerifyScreen(),
                                        ),
                                      );
                                      if (verify) {
                                        _cancelOrder(order.orderId,
                                            order.quantity, order.amount);
                                      }
                                      if (!context.mounted) {
                                        return;
                                      }
                                      setState(() {
                                        orders.removeAt(index);
                                      });
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('Cancel Order'),
                      ),
                    ],
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
