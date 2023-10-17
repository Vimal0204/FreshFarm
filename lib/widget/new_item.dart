import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm/models/item_model.dart';
import 'package:fresh_farm/widget/image_input.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key,required this.uid});
  final String uid;
  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  var _isSaving=false;
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  String _itemName = '';
  String _quantity = '';
  String _price = '';
  void _addItem(String uid) async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid || _selectedImage == null) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isSaving=true;
    });
    // final newItem = ItemModel(
    //   cost: _price,
    //   image: _selectedImage!,
    //   itemName: _itemName,
    //   quantity: _quantity,
    // );
    //Syntax to upload image file
    final storageRef=FirebaseStorage.instance.ref().child(uid).child('$uid+$_itemName.jpg');
    await storageRef.putFile(_selectedImage!);
    final imageUrl= await  storageRef.getDownloadURL();
    await FirebaseFirestore.instance.collection('${uid}products').doc(_itemName).set({
      'cost':_price,
      'itemname':_itemName,
      'quantity':_quantity,
      'image':imageUrl,
    });
    final newItem = ItemModel(
      cost: _price,
      image: Image.network(imageUrl),
      itemName: _itemName,
      quantity: _quantity,
    );
    // print(imageUrl);
    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop(newItem);
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
                  style: TextStyle( color: Theme.of(context).colorScheme.onBackground),
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
                        style: TextStyle( color: Theme.of(context).colorScheme.onBackground),
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
                          _quantity = value!;
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
                        style: TextStyle( color: Theme.of(context).colorScheme.onBackground),
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
                          _price = value!;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                ImageInput(
                  onPickImage: (image) {
                    _selectedImage = image;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  onPressed:(){ _addItem(widget.uid);},
                  label:_isSaving?const CircularProgressIndicator(): const Text('Add Item'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
