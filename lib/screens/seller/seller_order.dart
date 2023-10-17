import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm/models/order_model.dart';
import 'package:fresh_farm/widget/recieved_order.dart';

class ShowOrders extends StatefulWidget {
  const ShowOrders({
    super.key,
    required this.uid,
  });
  final String uid;
  @override
  State<ShowOrders> createState() => _ShowOrdersState();
}

class _ShowOrdersState extends State<ShowOrders> {
  List<OrderModel> listOrders = [];
  final List<OrderModel> tempList = [];
  var isLoading = true;
  void _loadMyOrders() async {
    var getOrder = await FirebaseFirestore.instance
        .collection('${widget.uid}orders')
        .get();
    for (var element in getOrder.docs) {
      OrderModel temp = OrderModel(
        sellerName: element.data()['customer-name'],
        itemName: element.data()['itemname'],
        quantity: element.data()['quantity'],
        amount: element.data()['cost-at-time'],
        sellerMobile: element.data()['customer-mobile'],
        sellerAddress: element.data()['customer-address'],
        sellerCity: element.data()['customer-city'],
        sellerId: element.data()['customer-uid'],
      );
      tempList.add(temp);
    }
    setState(() {
      listOrders = tempList;
      isLoading = false;
    });
  }

  void _cancelOrder(
      OrderModel order, String customerUid, String itemname) async {
    // final index = showItem.indexOf(item);
    setState(() {
      listOrders.remove(order);
    });
    await FirebaseFirestore.instance
        .collection('${itemname}myorders')
        .doc('${widget.uid}${customerUid}')
        .delete();
        // print('${itemname}myorders');
        // print('${customerUid}${widget.uid}');
    // print('$itemname$customerUid');
   await FirebaseFirestore.instance
        .collection('${widget.uid}orders')
        .doc('$itemname$customerUid')
        .delete();
        
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
            _cancelOrder(listOrders[index], listOrders[index].itemName,
                listOrders[index].sellerId);
          },
          child: ShowRecievedOrder(
            orderModel: listOrders[index],
          ),
        );
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
