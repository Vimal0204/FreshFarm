import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm/models/item_model.dart';

class UpdateItem extends StatefulWidget {
  const UpdateItem({
    super.key,
    required this.itemData,
    required this.uid,
  });
  final ItemModel itemData;
  final String uid;

  @override
  State<UpdateItem> createState() => _UpdateItemState();
}

class _UpdateItemState extends State<UpdateItem> {
  String _newQuantity = '';
  String _newPrice = '';
  bool _isUpdating = false;
  final _formKey = GlobalKey<FormState>();
  void _updateItem(String uid, ItemModel itemData) async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(
      () {
        _isUpdating = true;
      },
    );
    await FirebaseFirestore.instance
        .collection('${uid}products')
        .doc(itemData.itemName)
        .update(
      {
        'quantity': _newQuantity,
        'cost': _newPrice,
      },
    );
    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 70),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              widget.itemData.itemName,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(
              height: 20,
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
                      label: Text('Enter the new quantity in Kg.'),
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
                      _newQuantity = value!;
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
                      _newPrice = value!;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.update),
              onPressed: () {
                _updateItem(widget.uid, widget.itemData);
              },
              label: _isUpdating
                  ? const CircularProgressIndicator()
                  : const Text('Update'),
            )
          ],
        ),
      ),
    );
  }
}
