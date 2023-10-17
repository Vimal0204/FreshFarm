import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:fresh_farm/screens/customerAuth/common_login.dart';
import 'package:fresh_farm/screens/customerAuth/cust_home.dart';
import 'package:fresh_farm/screens/sellerAuth/seller_login.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  String checkId = '';
  var _customerUserName = '';
  var _customerPass = '';
  bool passwordVisible = false;
  void _onSubmit(String status) async {
    final val = _form.currentState!.validate();
    if (!val) {
      return;
    }
    try {
      _form.currentState!.save();
      if (status == 'login') {
        //  print(emId);
        // if (emId.toString() == _customerUserName) {
        var userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _customerUserName, password: _customerPass);
        print(userCred);
        // }

        // Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const Screen()));
      } else {
        var userCred =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _customerUserName,
          password: _customerPass,
        );
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(userCred.user!.uid)
            .set(
          {
            'user-name': _customerUserName,
            'role': 'customer',
          },
        );
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.code),
        ),
      );
    }
  }

  var screen = '';
  void registerState(String str) {
    setState(() {
      screen = str;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
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
                            'Welcome back in the customer.Please Login.',
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
                              _customerUserName = value!;
                            },
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              label: const Text('Password'),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            obscureText: !passwordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'ReEnter the password';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _customerPass = value!;
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
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextButton(
                            onPressed: () {
                              registerState('register');
                            },
                            child: const Text(
                              'I do not have account.Register here',
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
                                  builder: (ctx) => const SellerAuth(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sell products with us.',
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
                              'Please register yourself to purchase.',
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
                                _customerUserName = value!;
                              },
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                label: const Text('Password'),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ),
                              obscureText: !passwordVisible,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'ReEnter the password';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _customerPass = value!;
                              },
                            ),
                            const SizedBox(
                              height: 20,
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
                              height: 16,
                            ),
                            TextButton(
                                onPressed: () {
                                  registerState('');
                                },
                                child: const Text(
                                  'I have a account.Login here. ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
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

   /* void roleFun(var uid) async {
       await FirebaseFirestore.instance
          .collection('customers')
          .doc(uid)
          .get().then((value) {checkId= value.data()!['role'].toString();} );
      if (checkId=='customer') {
        if (context.mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>const CustomerHomeScreen(),),);
          
        }
      }else{
        if (context.mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>const CustomerHomeScreen(),),);;
          
        }

      }
    }*/

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
            return const CustomerHomeScreen();
        }
        return Scaffold(body: content);
      },
    );
  }
}














/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fresh_farm/screens/customerAuth/cust_home.dart';
import 'package:fresh_farm/screens/sellerAuth/seller_login.dart';

class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});

  @override
  State<CustomerLoginScreen> createState() {
    return _CustomerLoginScreenState();
  }
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firebase = FirebaseAuth.instance;
  String _customerUserName = '';
  String _customerPassword = '';
  bool passwordVisible = false;
  String _customerFirstName = '';
  String _customerLastName = '';
  String _customerMobile = '';
  // function for customer validate
  String? _customerValidate(String value) {
    RegExp regExp = RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
    String str = '';
    if (!regExp.hasMatch(value) || value.trim().isEmpty) {
      return str = '${str}Enter the user name in the alphanumeric format';
    }
    return null;
  }

  String? _mobileValidator(String value) {
    RegExp regExp = RegExp(r'[0]?[6789]\d{9}$');
    String str = '';
    if (!regExp.hasMatch(value) || value.trim().isEmpty) {
      return str = '${str}Enter in Number format only';
    }
    return null;
  }

  String? _passwordValidator(String value) {
    RegExp regExp = RegExp(
        r'(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    String str = '';
    if (value.length < 8) {
      return str = '${str}Password length should be more than 8';
    }
    if (!regExp.hasMatch(value) || value.trim().isEmpty) {
      return str =
          '${str}Enter the password in aplhanumeric format with one special character';
    }
    return null;
  }

  void _onSubmit(String status) async {
    final val = _formKey.currentState!.validate();
    if (!val) {
      return;
    }
    _formKey.currentState!.save();
    try {
      if (status == 'login') {
        var userCred =await _firebase.signInWithEmailAndPassword(
            email: _customerUserName, password: _customerPassword);
        print(userCred);
        print(_firebase.currentUser);
        print('done successfully');

        print(FirebaseAuth.instance.currentUser);
        // Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const Screen()));
      } else {
       var userCred= await _firebase.createUserWithEmailAndPassword(
            email: _customerUserName, password: _customerPassword);
            print(userCred);
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.code),
        ),
      );
    }
  }

  var screen = '';
  void registerState(String str) {
    setState(() {
      screen = str;
    });
  }


  @override
  Widget build(BuildContext context) {
    Widget content = Container(
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
                            'Welcome back Please Login to purchase.',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            // maxLength: 12,
                            decoration: const InputDecoration(
                              label: Text('Username'),
                            ),
                             validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'ReEnter';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              label: const Text('Password'),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            obscureText: !passwordVisible,
                            keyboardType: TextInputType.visiblePassword,
                             validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'ReEnter the password';
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _onSubmit('login');
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              registerState('register');
                            },
                            child: const Text(
                              'I do not have a account.Register here.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                              height: 16,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (ctx) => const SellerLoginScren(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sell your products with us.',
                                style: TextStyle(fontSize: 16),
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
          top: 100,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/FreshFarmrectangle.png',
                height: 150,
                width: 150,
              ),
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
                              'Please register yourself to purchase.',
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
                                _customerFirstName = value!;
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
                                _customerLastName = value!;
                              },
                            ),
                            TextFormField(
                              // maxLength: 12,
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
                                _customerUserName = value!;
                              },
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                label: const Text('Password'),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ),
                              obscureText: !passwordVisible,
                              keyboardType: TextInputType.visiblePassword,
                             validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'ReEnter the password';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _customerPassword = value!;
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
                                  ? _mobileValidator(value)
                                  : 'Enter the mobile number',
                              onSaved: (value) {
                                _customerMobile = value!;
                              },
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _onSubmit('');
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                registerState('');
                              },
                              child: const Text(
                                'I already have a account.Log in',
                                style: TextStyle(fontSize: 16),
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
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState==ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }
        if (snapshot.hasData) {
          return const CustomerHomeScreen();
        }
        return Scaffold(body: content);
      },
    );
    //end here
  }
}
*/