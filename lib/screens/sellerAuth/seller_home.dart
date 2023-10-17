// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
// import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm/models/item_model.dart';
// import 'package:fresh_farm/screens/customerAuth/cust_login.dart';
// import 'package:fresh_farm/screens/sellerAuth/seller_login.dart';
import 'package:fresh_farm/widget/item_card.dart';
import 'package:fresh_farm/widget/new_item.dart';
import 'package:fresh_farm/widget/seller_drawer.dart';
// import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path_provider/path_provider.dart';

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({super.key, required this.uid});
  final String uid;

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState(id: uid);
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  _SellerHomeScreenState({required this.id});
  bool isLoading = true;
  final String id;
  List<ItemModel> showItem = [];
  void onSelectOption(String identifier) {
    Navigator.of(context).pop();
  }

  void _loadItems(String id) async {
    List<ItemModel> itemDatabase = [];
    var getData =
        await FirebaseFirestore.instance.collection('${id}products').get();
    for (var element in getData.docs) {
      ItemModel itemData = ItemModel(
        cost: element.data()['cost'],
        image: Image.network(element.data()['image']),
        itemName: element.data()['itemname'],
        quantity: element.data()['quantity'],
      );
      itemDatabase.add(itemData);
    }

    setState(() {
      showItem = itemDatabase;
      isLoading = false;
    });
  }

  Future<File> urlToFile(String imageUrl) async {
    var response = await http.get(Uri.parse(imageUrl));
    var documentDirectory = await getApplicationDocumentsDirectory();
    var filePath =
        '${documentDirectory.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.png';
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  @override
  void initState() {
    _loadItems(id);
    super.initState();
  }

  void addNewItem(String uid) async {
    final itemData = await Navigator.of(context).push<ItemModel>(
      MaterialPageRoute(
        builder: (ctx) => NewItem(
          uid: uid,
        ),
      ),
    );
    if (itemData == null) {
      return;
    }
    setState(() {
      showItem.add(itemData);
    });
  }

  void _removeItem(ItemModel item) async {
    // final index = showItem.indexOf(item);
    setState(() {
      showItem.remove(item);
    });
    await FirebaseFirestore.instance
        .collection('${widget.uid}products')
        .doc(item.itemName)
        .delete();
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:  Text('Your item has been deleted'),
       
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: showItem.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(showItem[index].itemName),
          onDismissed: (direction) {
            _removeItem(showItem[index]);
          },
          child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              child: ItemCard(
                itemData: showItem[index],
                uid: widget.uid,
              )),
        );
      },
    );

    if (showItem.isEmpty) {
      content = Center(
        child: Text(
          'Please add some items to sell',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground),
        ),
      );
    }
    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sellers'),
        actions: [
          IconButton(
            onPressed: () {
              addNewItem(widget.uid);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: SellerDrawer(onSelectOption: onSelectOption, uid: widget.uid),
      body: content,
    );
  }
}
