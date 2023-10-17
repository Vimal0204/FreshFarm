import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm/screens/customerProfile/register_customer.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({super.key,});
  @override
  State<StatefulWidget> createState() {
    return _SellerProfileState();
  }
}

class _SellerProfileState extends State<CustomerProfile> {
  
  String uid=FirebaseAuth.instance.currentUser!.uid;
  String _firstName = '';
  String _lastName = '';
  String _mobile = '';
  String _city = '';
  String _address = '';
  String _email='';
  
  void loadData() async {
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(uid)
        .get()
        .then((value) {
      String firstName = value.data()!['first-name'];
      String lastName = value.data()!['last-name'];
      String mobile = value.data()!['mobile'];
      String city = value.data()!['city'];
      String address = value.data()!['address'];
      String email = value.data()!['user-name'];
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
                    builder: (ctx) => RegisterCustomer()));
              },
              child: const Text('Change details'))
        ],
      ),
      body: content,
    );
  }
}
