import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm/models/order_model.dart';
import 'package:fresh_farm/widget/show_order.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});
  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<OrderModel> listOrders = [];
  final List<OrderModel> tempList = [];
  var customerUid = FirebaseAuth.instance.currentUser!.uid;
  var isLoading = true;
  void _loadMyOrders() async {
    
    var getOrder = await FirebaseFirestore.instance
        .collection('${customerUid}myorders')
        .get();
    for (var element in getOrder.docs) {
      OrderModel temp = OrderModel(
        sellerName: element.data()['seller-name'],
        itemName: element.data()['itemname'],
        quantity: element.data()['quantity'],
        amount: element.data()['cost-at-time'],
        sellerMobile: element.data()['seller-mobile'],
        sellerAddress: element.data()['seller-address'],
        sellerCity: element.data()['seller-city'],
        sellerId: element.data()['seller-uid'],
      );
      tempList.add(temp);
    }
    setState(() {
      listOrders = tempList;
      isLoading = false;
    });
  }

  void _cancelOrder(OrderModel order,String sellerid,String itemname) async {
    // final index = showItem.indexOf(item);
    setState(() {
      listOrders.remove(order);
    });
    await FirebaseFirestore.instance
        .collection('${customerUid}myorders')
        .doc('$itemname$sellerid')
        .delete();
    await FirebaseFirestore.instance
        .collection('${itemname}orders')
        .doc('$customerUid$sellerid')
        .delete();
        // print('${sellerid}orders');
        print('${itemname}orders');
        print('$sellerid$customerUid');
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('The order has been canceled successfully.'),
      ),
    );
  }

  @override
  void initState() {
    _loadMyOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: listOrders.length,
      itemBuilder: (context, index) {
        return Dismissible(
            key: ValueKey(listOrders[index].itemName),
            onDismissed: (direction) {
              _cancelOrder(listOrders[index],listOrders[index].itemName,listOrders[index].sellerId);
            },
            child: ShowCostumerOrder(orderModel: listOrders[index]));
      },
    );
    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (listOrders.isEmpty) {
      content = const Text(
        'Please Order something',
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: content,
    );
  }
}
