import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm/screens/sellerProfile/register_seller.dart';

class SellerProfile extends StatefulWidget {
  const SellerProfile({super.key, required this.uid});
  final String uid;

  @override
  State<StatefulWidget> createState() {
    return _SellerProfileState(uid: uid);
  }
}

class _SellerProfileState extends State<SellerProfile> {
  _SellerProfileState({required this.uid});
  String uid;
  String _firstName = '';
  String _lastName = '';
  String _mobile = '';
  String _city = '';
  String _address = '';
  String _email='';
  void loadData() async {
    await FirebaseFirestore.instance
        .collection('seller')
        .doc(uid)
        .get()
        .then((value) {
      String firstName = value.data()!['first-name'];
      String lastName = value.data()!['last-name'];
      String mobile = value.data()!['mobile'];
      String city = value.data()!['city'];
      String address = value.data()!['address'];
      String email = value.data()!['email'];
      setState(() {
        _firstName = firstName;
        _lastName = lastName;
        _address = address;
        _city = city;
        _mobile = mobile;
        _email = email;
      });
    });

    
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Widget content = Card(
      margin: const EdgeInsets.only(top: 100, left: 5, right: 5),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(50),
          margin: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // fontSize:24,
            children: [
              Row(
                children: [
                  Text(
                    'Name  : ',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _firstName,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    _lastName,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    'Emaill  : ',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _email,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    'mobile  : ',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _mobile,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    'Address  : ',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _address,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    'City  : ',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _city,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => RegisterSeller(uid: uid)));
              },
              child: const Text('Change details'))
        ],
      ),
      body: content,
    );
  }
}
