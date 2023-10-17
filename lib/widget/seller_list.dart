import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm/screens/customer/items.dart';

import '../models/seller_list_model.dart';

class SellerList extends StatefulWidget {
  const SellerList({super.key});

  @override
  State<SellerList> createState() => _SellerListState();
}

class _SellerListState extends State<SellerList> {
  var _isLoading = true;
  List<SellerListData> _sellerList = [];

  // String? _error;
  @override
  void initState() {
    _loadItem();

    super.initState();
  }

  void _loadItem() async {
    // await FirebaseFirestore.instance
    //     .collection('seller')
    //     .get()
    //     .then((querySnapshot) {
    //       print('them here');
    //   querySnapshot.docs.forEach((result) {

    //     FirebaseFirestore.instance
    //         .collection('seller')
    //         .doc(result.id)
    //         .collection('seller-details')
    //         .get()
    //         .then((querySnapshot) {
    //           print(result.id);
    //       querySnapshot.docs.forEach((result) {
    //         print(result.data());
    //       });
    //     });
    //   });

    try {
      List<SellerListData> tempList = [];
      QuerySnapshot<Map<String, dynamic>> sellerData;
      sellerData = await FirebaseFirestore.instance.collection('seller').get();
      for (var element in sellerData.docs) {
        FirebaseFirestore.instance
            .collection('seller')
            .doc(element.id)
            .get()
            .then((value) {
          tempList.add(
            SellerListData(
              name:
                  '${value.data()!['first-name'].toString().toUpperCase()} ${value.data()!['last-name'].toString().toUpperCase()}',
              city: value.data()!['city'],
              uid: element.id,
            ),
          );
          // print(tempList.length);
          setState(() {
            _sellerList = tempList;
            _isLoading = false;
          });
        });
      }
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _sellerList.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          child: ListTile(
            // tileColor:Theme.of(context).colorScheme.onPrimary ,
            leading: Text(
              _sellerList[index].name,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            trailing: Text(
              _sellerList[index].city,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) =>
                      SellerItemDetails(uid: _sellerList[index].uid),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
