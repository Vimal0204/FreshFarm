import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm/models/item_model.dart';

class PurchaseItem extends StatefulWidget {
  const PurchaseItem({super.key, required this.itemData, required this.uid});
  final ItemModel itemData;
  final String uid;
  @override
  State<PurchaseItem> createState() => _PurchaseItemState();
}

class _PurchaseItemState extends State<PurchaseItem> {
  String customerUid = FirebaseAuth.instance.currentUser!.uid;
  String _quantity = '';

  bool _isOrdering = false;
  final _formKey = GlobalKey<FormState>();
  void _orderItem() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isOrdering = true;
    });
    var getCustomerData = await FirebaseFirestore.instance
        .collection('customers')
        .doc(customerUid)
        .get();
    var getSellerData = await FirebaseFirestore.instance
        .collection('seller')
        .doc(widget.uid)
        .get();
    var customerMobile = getCustomerData.data()!['mobile'];
    var cusAddress = getCustomerData.data()!['address'];
    var cusCity = getCustomerData.data()!['city'];
    var sellerMobile = getSellerData.data()!['mobile'];
    var sellerAddress = getSellerData.data()!['address'];
    var sellerCity = getSellerData.data()!['city'];
    var cusName = getCustomerData.data()!['first-name'];
    var sellerName = getSellerData.data()!['first-name'];
    await FirebaseFirestore.instance
        .collection('${widget.uid}orders')
        .doc('$customerUid${widget.itemData.itemName}')
        .set(
      {
        'customer-uid': customerUid,
        'seller-uid': widget.uid,
        'customer-mobile': customerMobile,
        'customer-address': cusAddress,
        'customer-city': cusCity,
        'customer-name': cusName,
        'seller-name': sellerName,
        'seller-mobile': sellerMobile,
        'seller-address': sellerAddress,
        'seller-city': sellerCity,
        'itemname': widget.itemData.itemName,
        'quantity': _quantity,
        'cost-at-time':
            ((int.parse(_quantity)) * (int.parse(widget.itemData.cost)))
                .toString(),
      },
    );
    await FirebaseFirestore.instance
        .collection('${customerUid}myorders')
        .doc('${widget.uid}${widget.itemData.itemName}')
        .set(
      {
        'customer-uid': customerUid,
        'seller-uid': widget.uid,
        'customer-mobile': customerMobile,
        'customer-address': cusAddress,
        'customer-city': cusCity,
        'customer-name': cusName,
        'seller-name': sellerName,
        'seller-mobile': sellerMobile,
        'seller-address': sellerAddress,
        'seller-city': sellerCity,
        'itemname': widget.itemData.itemName,
        'quantity': _quantity,
        'cost-at-time':
            ((int.parse(_quantity)) * (int.parse(widget.itemData.cost)))
                .toString(),
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
              TextFormField(
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
                  _quantity = value!;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.shopping_bag_rounded),
                onPressed: _orderItem,
                label: _isOrdering
                    ? const CircularProgressIndicator()
                    : const Text('Confirm Order'),
              )
            ],
          )),
    );
  }
}
