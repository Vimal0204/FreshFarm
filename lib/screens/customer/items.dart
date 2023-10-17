import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm/models/item_model.dart';
import 'package:fresh_farm/widget/customer_item_card.dart';

class SellerItemDetails extends StatefulWidget {
  const SellerItemDetails({super.key, required this.uid});
  final String uid;

  @override
  State<SellerItemDetails> createState() => _SellerItemDetailsState();
}

class _SellerItemDetailsState extends State<SellerItemDetails> {
  List<ItemModel> _productCard = [];
  var _isLoading = true;
  void _loadItems() async {
    List<ItemModel> temp = [];
    var getData = await FirebaseFirestore.instance
        .collection('${widget.uid}products')
        .get();
    for (var element in getData.docs) {
      ItemModel itemData = ItemModel(
        cost: element.data()['cost'],
        image: Image.network(element.data()['image']),
        itemName: element.data()['itemname'],
        quantity: element.data()['quantity'],
      );
      temp.add(itemData);
    }
    setState(() {
      _productCard=temp;
      _isLoading=false;
    });
  }

  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: _productCard.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          child: CustomerItemCard(
            itemData: _productCard[index],
            uid: widget.uid,
          ),
        );
      },
    );
    if (_productCard.isEmpty) {
      content = Center(
        child: Text(
          'No items to show here!Please visit different options.',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground),
        ),
      );
    }
    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fresh Farm Items'),
      ),
      body: content,
    );
  }
}
