import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/pointycastle.dart' as pointycastle;
import 'package:flutter/material.dart';
import 'package:freshfarm/Screens/forget_password.dart';
import 'package:freshfarm/Screens/sellerHome/seller_intermediate.dart';
import 'package:freshfarm/Screens/sellerHome/sellers_home.dart';
import 'package:freshfarm/Screens/sellerRegister/seller_register.dart';
import 'package:freshfarm/model/seller.dart';
import 'package:http/http.dart' as http;

class SellerAuthScreen extends StatefulWidget {
  const SellerAuthScreen({super.key});

  @override
  State<SellerAuthScreen> createState() => _SellerAuthScreenState();
}
class _SellerAuthScreenState extends State<SellerAuthScreen> {
  bool signIn = false;
  Seller seller = Seller(
    email: "",
    firstName: "",
    lastName: "",
    id: 0,
    mobile: "",
    address: "",
    city: "",
    state: "",
    pincode: 0,
  );
  final _form = GlobalKey<FormState>();
  String? _sellerUserName;
  String? _sellerPass;
  bool passwordVisible = false;
  var uid = '';

  String encryptAES(String text, String password) {
    final keyBytes = Uint8List.fromList(utf8.encode(password));
    final iv = Uint8List(16);
    final cipher = pointycastle.BlockCipher("AES/CBC")
      ..init(
          true,
          pointycastle.ParametersWithIV(
              pointycastle.KeyParameter(keyBytes), iv));

    final inputBytes = Uint8List.fromList(utf8.encode(text));
    final encryptedBytes = encryptBytes(cipher, inputBytes);

    final encryptedText = base64.encode(encryptedBytes);

    return encryptedText;
  }

  String decryptAES(String encryptedText, String password) {
    final keyBytes = Uint8List.fromList(utf8.encode(password));
    final iv = Uint8List(16);
    final cipher = pointycastle.BlockCipher("AES/CBC")..init(false, pointycastle.ParametersWithIV(pointycastle.KeyParameter(keyBytes), iv));

    final encryptedBytes = base64.decode(encryptedText);
    final decryptedBytes = decryptBytes(cipher, encryptedBytes);

    final decryptedText = utf8.decode(decryptedBytes);

    return decryptedText;
  }

  Uint8List encryptBytes(pointycastle.BlockCipher cipher, Uint8List input) {
    final blockSize = cipher.blockSize;
    final paddedInput = padBlock(input, blockSize);
    final result = Uint8List(paddedInput.length);
    for (var i = 0; i < paddedInput.length; i += blockSize) {
      cipher.processBlock(paddedInput, i, result, i);
    }
    return result;
  }

   Uint8List decryptBytes(pointycastle.BlockCipher cipher, Uint8List input) {
    final blockSize = cipher.blockSize;
    final result = Uint8List(input.length);
    for (var i = 0; i < input.length; i += blockSize) {
      cipher.processBlock(input, i, result, i);
    }
    return removePadding(result);
  }

  Uint8List padBlock(Uint8List input, int blockSize) {
    final padLength = blockSize - (input.length % blockSize);
    final padded = Uint8List(input.length + padLength);
    padded.setAll(0, input);
    for (var i = input.length; i < padded.length; i++) {
      padded[i] = padLength;
    }
    return padded;
  }

  Uint8List removePadding(Uint8List input) {
    final padLength = input.last;
    return input.sublist(0, input.length - padLength);
  }

  void loginUser() async {
    // print("the de text is "+detex);
    setState(
      () {
        signIn = true;
      },
    );
    final val = _form.currentState!.validate();
    if (!val) {
      return;
    }
    _form.currentState!.save();
    // String pass=_sellerPass!;
    String key = "freshfarm 210763";
    final emailUrl = Uri.https(
      'freshfarm.azurewebsites.net',
      '/api/checkFarmerEmail/$_sellerUserName',
    );
    final response = await http.get(
      emailUrl,
    );
    final responseBody = json.decode(response.body);
//  yahan pr mysql database se data lanee ki kosis krna h.
    // final url = Uri.https(
    //   'capstonefreshfarm-default-rtdb.firebaseio.com',
    //   'seller-data.json',
    // );
    // final response = await http.get(url);
    if (!context.mounted) {
      return;
    }
    // var res = json.decode(response.body);
    if (!responseBody) {
      setState(() {
        signIn = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not exist.Please register'),
          duration: Duration(
            seconds: 5,
          ),
        ),
      );
    } else {
      print(_sellerPass);
      final decryptedpass = encryptAES(_sellerPass!, key);
      print(decryptedpass);
      print(decryptAES("Is1pb3gdAsuZ8y06Hwiyfw==", key));
      final url = Uri.https(
        'freshfarm.azurewebsites.net',
        '/api/checkFarmerCredentials/$_sellerUserName?&password=$decryptedpass',
      );
      final res = await http.get(url);
      print(res.body);
      // final resBody = json.decode(
      //   res.body,
      // );
      // Map<String, dynamic> dataList = res;
      // for (var element in dataList.entries) {
      // String decryptedpass=abs(element.value['password']);

      // print("the encrypted password is " + decryptedpass);
  // print(resBody);
  
      if (res.body!="") {
        // uid = element.key;

        if (res.body == 'approved') {
          final url = Uri.https(
            'freshfarm.azurewebsites.net',
            '/api/farmerId/$_sellerUserName',
          );
          final respo = await http.get(url);
          dynamic data = json.decode(respo.body);
          setState(
            () {
              seller = Seller(
                email: _sellerUserName!,
                firstName: data['firstName'],
                lastName: data['lastName'],
                id: data['id'],
                mobile: data['mobile'],
                address: data['address'],
                city: data['city'],
                state: data['state'],
                pincode: data['pincode'],
              );
            },
          );
          if (!context.mounted) {
            return;
          }
          // encryptDecrypt(_sellerPass!);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => SellersHomeScreen(
                email: _sellerUserName!,
                uid: uid,
                seller: seller,
              ),
            ),
          );
        } else if(res.body=='pending'||res.body=='rejected'){
          final url = Uri.https(
            'freshfarm.azurewebsites.net',
            '/api/farmerId/$_sellerUserName',
          );
          final respon = await http.get(url);
          dynamic data = json.decode(respon.body);
          if (!context.mounted) {
            return;
          }
          // print(data['status']);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => IntermediateScreen(
                username: data['firstname'],
                uid: data["id"],
                status: data['status'],
                message: "",
              ),
            ),
          );
        }
      } else {
        setState(() {
          signIn=false;
        });
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong Username or Password. Please Retry'),
            duration: Duration(
              seconds: 5,
            ),
          ),
        );
      }
      // }
    }
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
              'assets/images/freshfarmicon.png',
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
                              label: Text('Email'),
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
                            decoration: InputDecoration(
                              label: const Text('Password'),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      passwordVisible = !passwordVisible;
                                    },
                                  );
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
                              _sellerPass = value!;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: loginUser,
                            child: signIn
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      const ForgetPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Forget Password',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => const SellerRegister(),
                                ),
                              );
                            },
                            child: const Text(
                              'Does not have a account ? Register here!',
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
    return Scaffold(body: content);
  }
}

/*void _signIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue,
            Color.fromARGB(255, 52, 231, 183),
          ],
        ),
      ),
      child: Card(
        margin:
            const EdgeInsets.only(top: 200, bottom: 200, left: 30, right: 30),
        elevation: 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 200,
              width: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/freshfarmlogo.png'),
                ),
                // shape: BoxShape.circle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: MaterialButton(
                color: const Color.fromARGB(255, 38, 213, 196),
                elevation: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 30.0,
                      width: 30.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/goo.png'),
                            fit: BoxFit.cover),
                        // shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Sign In with Google",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                onPressed: () {
                  _signIn();
                },
              ),
            )
          ],
        ),
      ),
    );
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          return const Scaffold(body: SellerRegister(),);
        }
        return Scaffold(body: content);
      },
    );
  }*/
