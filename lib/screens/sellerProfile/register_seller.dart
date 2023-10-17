import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterSeller extends StatelessWidget {
  RegisterSeller({super.key, required this.uid});
  final String uid;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String email = '';

    String firstName = '';
    String lastName = '';
    String mobile = '';
    String city = '';
    String address = '';

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
      final url = Uri.https(
        'freshfarm-24f40-default-rtdb.firebaseio.com',
        'seller-data.json',
      );
      final response = await http.get(url);
      Map<String, dynamic> dataList = json.decode(response.body);
      for (var element in dataList.entries) {
        if (element.key == uid) {
          email = element.value['email'];
        }
      }
      ;
      // print(email);
      // email = dataList['email'];

      await FirebaseFirestore.instance.collection('seller').doc(uid).set(
        {
          'email': email,
          'first-name': firstName,
          'last-name': lastName,
          'mobile': mobile,
          'city': city,
          'address': address,
        },
      );
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Changes Update Successfully'),),);
      Navigator.of(context).pop(firstName);
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
                            TextFormField(
                              // maxLength: 12,
                              decoration: const InputDecoration(
                                label: Text('First Name'),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please Enter the First name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                firstName = value!;
                              },
                            ),
                            TextFormField(
                              // maxLength: 12,
                              decoration: const InputDecoration(
                                label: Text('Last Name'),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please Enter the Last name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                lastName = value!;
                              },
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
