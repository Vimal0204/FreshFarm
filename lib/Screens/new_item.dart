import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freshfarm/imageinput/image_input.dart';
import 'package:freshfarm/model/seller.dart';
import 'package:freshfarm/widget/seller_product.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key, required this.seller, required this.addProduct});
  final Seller seller;
  final Function(Product product) addProduct;
  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  var _isSaving = false;
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  String _itemName = '';
  int _quantity = 0;
  double _price = 0;
  void _addItem() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid || _selectedImage == null) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isSaving = true;
    });
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("product")
        .child('${widget.seller.email + _itemName}.jpg');
    await storageRef.putFile(_selectedImage!);
    final imageUrl = await storageRef.getDownloadURL();

    Product product = Product(
        id: 0,
        imageUrl: imageUrl,
        productName: _itemName,
        quantity: _quantity,
        price: _price);
    widget.addProduct(product);
    // print(imgeUrl);
    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 15,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground),
                  decoration: const InputDecoration(
                    label: Text('Item Name'),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the item';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _itemName = value!;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: '1',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground),
                        decoration: const InputDecoration(
                          prefixText: 'Kg ',
                          label: Text('Enter the quantity in Kg.'),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Please enter the Quantity in the numeric format';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _quantity = int.parse(value!);
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(
                        width: 8,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground),
                        decoration: const InputDecoration(
                          prefixText: '₹/Kg ',
                          label: Text('Price/Kg  '),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Please enter  the cost per Kg ';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _price = double.parse(value!);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                ImageInput1(
                  onPickImage: (image) {
                    _selectedImage = image;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _addItem();
                  },
                  label: _isSaving
                      ? const CircularProgressIndicator()
                      : const Text('Add Item'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
