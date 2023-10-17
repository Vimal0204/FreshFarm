import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm/screens/customerAuth/cust_login.dart';
import 'package:fresh_farm/screens/sellerAuth/seller_home.dart';
import 'package:http/http.dart' as http;

class SellerAuth extends StatefulWidget {
  const SellerAuth({super.key});

  @override
  State<SellerAuth> createState() => _SellerAuthState();
}

class _SellerAuthState extends State<SellerAuth> {
  final _form = GlobalKey<FormState>();
  var _sellerUserName = '';
  var _sellerPass = '';
  var uid = '';
  var isUserExist = false;
  void _onSubmit(String status) async {
    final val = _form.currentState!.validate();
    if (!val) {
      return;
    }
    _form.currentState!.save();
    if (status == 'login') {
      final url = Uri.https(
        'freshfarm-24f40-default-rtdb.firebaseio.com',
        'seller-data.json',
      );
      final response = await http.get(url);
      Map<String, dynamic> dataList = json.decode(response.body);
      for (var element in dataList.entries) {
        if (element.value['email'] == _sellerUserName &&
            element.value['password'] == _sellerPass) {
          uid = element.key;

          if (!context.mounted) {
            return;
          }
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => SellerHomeScreen(uid: uid)));
        } else {
          if (!context.mounted) {
            return;
          }
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User not exist.'),
            ),
          );
        }
      }
    } else {
      final url = Uri.https(
        'freshfarm-24f40-default-rtdb.firebaseio.com',
        'seller-data.json',
      );
      final response = await http.get(url);
      Map<String, dynamic> dataList = json.decode(response.body);
      for (var element in dataList.entries) {
        if (element.value['email'] == _sellerUserName) {
          isUserExist = true;
        }
      }
      if (!isUserExist) {
        await http.post(
          url,
          headers: {
            'Content-type': 'application/json',
          },
          body: json.encode(
            {
              'email': _sellerUserName,
              'password': _sellerPass,
            },
          ),
        );
        setState(() {
          screen = '';
        });
      }
      if (!context.mounted) {
            return;
          }
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User  exist please take diffrent user name or login.'),
            ),
          );
    }

    /*  var userCred =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _sellerUserName,
          password: _sellerPass,
        );
        await FirebaseFirestore.instance
            .collection('seller')
            .doc(userCred.user!.uid)
            .set(
          {
            'user-name': _sellerUserName,
            'role': 'seller',
          },
        );*/
  }

  var screen = '';
  void registerState(String str) {
    setState(() {
      screen = str;
    });
  }

  Widget content = const Text('hi');
  @override
  Widget build(BuildContext context) {
    content = Container(
      margin: const EdgeInsets.only(
        top: 60,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/FreshFarmrectangle.png',
              height: 150,
              width: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Card(
                child: SingleChildScrollView(
                  child: Form(
                    key: _form,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Please Login to sell your product.',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Username'),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'ReEnter';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _sellerUserName = value!;
                            },
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Password'),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'ReEnter the password';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _sellerPass = value!;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _onSubmit('login');
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )),
                          const SizedBox(
                            height: 16,
                          ),
                          TextButton(
                            onPressed: () {
                              registerState('register');
                            },
                            child: const Text(
                              'I do not have a account.Register here.',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => const AuthScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'I want to purchase the products.',
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
    );
    if (screen == 'register') {
      content = Container(
        margin: const EdgeInsets.only(
          top: 60,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/FreshFarmrectangle.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Card(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _form,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Welcome Please Register.',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                label: Text('Username'),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'ReEnter';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _sellerUserName = value!;
                              },
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                label: Text('Password'),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'ReEnter the password';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _sellerPass = value!;
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  _onSubmit('');
                                },
                                child: const Text(
                                  'register',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              onPressed: () {
                                registerState('');
                              },
                              child: const Text(
                                'I already have a account.Login here.',
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
      );
    }
    return Scaffold(body: content);
    // return StreamBuilder(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       return const SellerHomeScreen(uid: uid,);
    //     }
    //     return Scaffold(body: content);
    //   },
    // );
  }
}
