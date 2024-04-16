import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshfarm/Screens/buyerHome/customer_register.dart';
import 'package:freshfarm/model/customer.dart';
import 'package:http/http.dart' as http;

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({super.key});
  // final  Customer customer;
  @override
  State<StatefulWidget> createState() {
    return _SellerProfileState();
  }
}

class _SellerProfileState extends State<CustomerProfile> {
  Customer customer = Customer(
    id: 0,
    mobile: '',
    address: '',
    city: '',
    state: '',
    pincode: 0,
  );
  void _loadCus() async {
    final rll = Uri.https(
      'freshfarm.azurewebsites.net',
      '/api/customerId/${FirebaseAuth.instance.currentUser!.email}',
    );
    final response = await http.get(rll);
    final getCustomer = json.decode(response.body);
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
  }

  @override
  void initState() {
    // print("yes");
    _loadCus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Card(
      margin: const EdgeInsets.only(top: 100, left: 5, right: 5),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
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
                    FirebaseAuth.instance.currentUser!.displayName!,
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
                    'Email  : ',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    FirebaseAuth.instance.currentUser!.email!,
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
                    customer.mobile,
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
                      customer.address.toString(),
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
                    customer.city,
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
                    'State  : ',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    customer.state.toString(),
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
                    'Pincode  : ',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    customer.pincode.toString(),
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
//
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          ElevatedButton(
              onPressed: () async {
                var s = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => RegisterCustomer()));
                // print(s);
                if (s == 'success') {
                  _loadCus();
                }
              },
              child: const Text('Change details'))
        ],
      ),
      body: content,
    );
  }
}
