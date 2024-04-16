import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freshfarm/model/customer.dart';
import 'package:freshfarm/model/product_model_seller.dart';
import 'package:freshfarm/widget/product_card_widget.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.customer});
  final Customer customer;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductModel> showItem = [];
  void _searchProducts(String name) async {
    final url = Uri.https(
      'freshfarm.azurewebsites.net',
      '/api//getProduct/$name',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search Products',
            border: InputBorder.none,
          ),
          onSubmitted: _searchProducts,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () => _searchProducts(_searchController.text),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: showItem.length,
        itemBuilder: (context, index) => ProductCard(
          id: showItem[index].id!,
          imageUrl: showItem[index].image,
          productName: showItem[index].itemName,
          productCost: showItem[index].cost,
          customer: widget.customer,
        ),
      ),
    );
  }
}
