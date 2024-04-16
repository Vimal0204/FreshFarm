import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterCustomer extends StatelessWidget {
  RegisterCustomer({
    super.key,
  });

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String mobile = '';
    String city = '';
    String address = '';
    String state = '';
    int pincode = 0;

    String? mobileValidator(String value) {
      RegExp regExp = RegExp(r'[0]?[6789]\d{9}$');
      String str = '';
      if (!regExp.hasMatch(value) || value.trim().isEmpty) {
        return str = '${str}Enter in Number format only';
      }
      return null;
    }

    void saveDetails() async {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      _formKey.currentState!.save();

      // print(email);
      // email = dataList['email'];
      final url = Uri.https(
        'freshfarm.azurewebsites.net',
        '/api/customerDetails/${FirebaseAuth.instance.currentUser!.email}',
      );
      await http.put(
        url,
        headers: {'content-type': 'application/json'},
        body: json.encode({
          "mobile": mobile,
          "address": address,
          "city": city,
          "pincode": pincode,
          "state": state
        }),
      );
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes Update Successfully'),
        ),
      );
      Navigator.of(context).pop('success');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Details'),
      ),
      body: Container(
        margin: const EdgeInsets.only(
          top: 100,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Card(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Enter the new details',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              // maxLength: 12,
                              decoration: const InputDecoration(
                                label: Text('City'),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please Enter the Last city';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                city = value!;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              // maxLength: 12,
                              decoration: const InputDecoration(
                                label: Text('Address'),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please Enter the address';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                address = value!;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              // maxLength: 12,
                              decoration: const InputDecoration(
                                label: Text('State'),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please Enter the address';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                state = value!;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              // maxLength: 12,
                              decoration: const InputDecoration(
                                label: Text('Pincode'),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please Enter the address';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                pincode = int.parse(value!);
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              maxLength: 10,
                              decoration: const InputDecoration(
                                label: Text('Mobile Number'),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) => value!.length > 9
                                  ? mobileValidator(value)
                                  : 'Enter the mobile number',
                              onSaved: (value) {
                                mobile = value!;
                              },
                            ),
                            ElevatedButton(
                              onPressed: saveDetails,
                              child: const Text(
                                'Save Changes',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
