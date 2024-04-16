import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshfarm/Screens/buyerHome/cart_screen.dart';
import 'package:freshfarm/Screens/buyerHome/search_screen.dart';
// import 'package:freshfarm/Screens/new_item.dart';
import 'package:freshfarm/drawer/buyers_drawer.dart';
import 'package:freshfarm/model/customer.dart';
// import 'package:freshfarm/model/customer.dart';
import 'package:freshfarm/model/product_model_seller.dart';
import 'package:freshfarm/widget/product_card_widget.dart';
import 'package:http/http.dart' as http;

class BuyersHomeScreen extends StatefulWidget {
  const BuyersHomeScreen({super.key});

  @override
  State<BuyersHomeScreen> createState() => _BuyersHomeScreenState();
}

class _BuyersHomeScreenState extends State<BuyersHomeScreen> {
  @override
  void initState() {
    _loadCustomer();
    _loadProducts();
    super.initState();
  }

  Customer customer =
      Customer(id: 0, mobile: '', address: '', city: '', state: '', pincode: 0);
  void _loadCustomer() async {
    final ur = Uri.https(
      'freshfarm.azurewebsites.net',
      '/api/customer/${FirebaseAuth.instance.currentUser!.email}',
    );
    final urr = await http.get(ur);
    final userExist = json.decode(urr.body);
    if (!userExist) {
      final url = Uri.https(
        'freshfarm.azurewebsites.net',
        '/api/customerDetails',
      );
      await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: json.encode(
          {
            "email": FirebaseAuth.instance.currentUser!.email,
            "name": FirebaseAuth.instance.currentUser!.displayName,
          },
        ),
      );
      final mailUrl = Uri.https(
          "freshfarmmail.azurewebsites.net", "/api/customerMail/welcome");
      await http.post(
        mailUrl,
        headers: {'content-type': 'application/json'},
        body: json.encode(
          {
            "to": FirebaseAuth.instance.currentUser!.email,
            "customerName": FirebaseAuth.instance.currentUser!.displayName,
          },
        ),
      );
    }
    final rll = Uri.https(
      'freshfarm.azurewebsites.net',
      '/api/customerId/${FirebaseAuth.instance.currentUser!.email}',
    );
    final response = await http.get(rll);
    final getCustomer = json.decode(response.body);
    // print(getCustomer);
    setState(() {
      customer = Customer(
        id: getCustomer['id'],
        mobile: getCustomer['mobile'],
        address: getCustomer['address'],
        city: getCustomer['city'],
        state: getCustomer['state'],
        pincode: getCustomer['pincode'],
      );
    });

    // print(customer.city);
  }

  List<ProductModel> showItem = [];
  //  Map<String, int> map = {};
  void _onSelectOption(String identifier) {
    Navigator.of(context).pop();
  }

  // void addNewItem() async {
  //   final productData = await Navigator.of(context).push<ProductModel>(
  //     MaterialPageRoute(
  //       builder: (ctx) => NewItem(
  //         email: FirebaseAuth.instance.currentUser!.email.toString(),
  //       ),
  //     ),
  //   );
  //   if (productData == null) {
  //     return;
  //   }
  //   setState(() {
  //     showItem.add(productData);
  //   });
  // }

  void _loadProducts() async {
    final url = Uri.https(
      'freshfarm.azurewebsites.net',
      '/api/getProduct',
    );
    final response = await http.get(url);
    final res = json.decode(response.body);
    print(res);
    final List<ProductModel> loadedItem = [];
    for (final element in res) {
      loadedItem.add(
        ProductModel(
          id: element['id'],
          cost: element['price'],
          itemName: element['name'],
          quantity: element['quantity'],
          image: element['imagelink'],
        ),
      );
    }
    setState(() {
      showItem = loadedItem;
    });
    print(showItem[0].image);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => SearchScreen(
                    customer: customer,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
          const SizedBox(
            width: 2,
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => CartScreen(
                    customer: customer,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
          ),
        ],
      ),
      drawer: BuyerDrawer(
        // customer: customer,
        onSelectOption: _onSelectOption,
        userName: FirebaseAuth.instance.currentUser?.displayName,
      ),
      body: ListView.builder(
        itemCount: showItem.length,
        itemBuilder: (context, index) => ProductCard(
          id: showItem[index].id!,
          productName: showItem[index].itemName,
          imageUrl: showItem[index].image,
          productCost: showItem[index].cost,
          customer: customer,
        ),
      ),
    );
  }
}
