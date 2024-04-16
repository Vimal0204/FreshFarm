import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:pointycastle/pointycastle.dart' as pointycastle;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freshfarm/Screens/initial_screen.dart';
import 'package:freshfarm/Screens/sellers_auth_screen.dart';
import 'package:freshfarm/imageinput/seller_pan_card_image.dart';
import 'package:http/http.dart' as http;

class SellerRegister extends StatefulWidget {
  const SellerRegister({super.key});

  @override
  State<SellerRegister> createState() => _SellerRegisterState();
}

class _SellerRegisterState extends State<SellerRegister> {
  bool isRegistering = false;
  final form = GlobalKey<FormState>();
  // String logEmail = '';
  // String logPass = '';
  String email = '';
  String sellerPass = '';
  String firstName = '';
  String lastName = '';
  String mobile = '';
  String city = '';
  String address = '';
  String pinCode = '';
  String state = '';
  File? selectedImage;
  bool passwordVisible = false;
  bool isUserExist = false;
  String pancard = '';
  bool registerSuccessfully = false;
  // bool login = true;
  String? mobileValidator(String value) {
    RegExp regExp = RegExp(r'[0]?[6789]\d{9}$');
    String str = '';
    if (!regExp.hasMatch(value) || value.trim().isEmpty) {
      return str = '${str}Enter in Number format only';
    }
    return null;
  }

  String? pinValidator(String value) {
    RegExp regExp = RegExp(r'[0-9]');
    String str = '';
    if (!regExp.hasMatch(value) || value.trim().isEmpty) {
      return str = '${str}Enter in Number format only';
    }
    return null;
  }

  // for encrrypting confidential information...
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

  void registerUser() async {
    setState(() {
      isRegistering = true;
    });
    final val = form.currentState!.validate();
    if (!val) {
      return;
    }
    form.currentState!.save();
//
//Encrypt the password.
//
    String key = "freshfarm 210763";
    String encryptedPassword = encryptAES(sellerPass, key);
    print(sellerPass);
    print(encryptedPassword);
//
//Encrypt the pancard number.
//
    String encryptedPancard = encryptAES(pancard, key);
    print(pancard);

//
// post the data into the mysql directly.
//
print(email);
    final eurl = Uri.https(
      'freshfarm.azurewebsites.net',
      '/api/checkFarmerEmail/$email',
    );
    final response = await http.get(eurl);
    final res = json.decode(response.body);
    print(res);
    if (res) {
      // Map<String, dynamic> dataList = json.decode(response.body);
      // for (var element in dataList.entries) {
      //   if (element.value['email'] == email) {
      isUserExist = true;
      // }
      // }
    }
    if (!isUserExist) {
      final url = Uri.https(
        'freshfarm.azurewebsites.net',
        '/api/farmer/createFarmer',
      );
      await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode(
          {
            'email': email,
            'password': encryptedPassword,
            'firstName': firstName,
            'lastName': lastName,
            'mobile': mobile,
            'address': address,
            'city': city,
            'state': state,
            'pincode': pinCode,
            'pancard': encryptedPancard,
            'status': 'pending',
            // 'message': '',
          },
        ),
      );
      final storageRef =
          FirebaseStorage.instance.ref().child('pancard').child('$pancard.jpg');
      await storageRef.putFile(selectedImage!);
      setState(
        () {
          registerSuccessfully = true;
          isRegistering = false;
        },
      );
    } else {
      if (!context.mounted) {
        return;
      }
      setState(() {
        isRegistering = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User exist please login.'),
          duration: Duration(
            seconds: 5,
          ),
        ),
      );
    }
  }

  // void haveAccount() {
  //   setState(
  //     () {
  //       login = true;
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      margin: const EdgeInsets.only(
        top: 60,
        bottom: 10,
        left: 10,
        right: 10,
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
            const Text(
              'Welcome to FreshFarm.Please register here!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const SellerAuthScreen(),
                  ),
                );
              },
              child: const Text(
                'Already have an account? LogIn here!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              // child: SingleChildScrollView(
              child: Form(
                key: form,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                          email = value!;
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
                          sellerPass = value!;
                        },
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        maxLength: 12,
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
                        maxLength: 12,
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
                      TextFormField(
                        maxLength: 50,
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
                      TextFormField(
                        maxLength: 50,
                        decoration: const InputDecoration(
                          label: Text('City'),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please Enter the city name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          city = value!;
                        },
                      ),
                      TextFormField(
                        maxLength: 10,
                        decoration: const InputDecoration(
                          label: Text('PinCode'),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) => value!.length > 5
                            ? pinValidator(value)
                            : 'Enter the PinCode',
                        onSaved: (value) {
                          pinCode = value!;
                        },
                      ),
                      TextFormField(
                        maxLength: 50,
                        decoration: const InputDecoration(
                          label: Text('State'),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please Enter the state name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          state = value!;
                        },
                      ),
                      TextFormField(
                        maxLength: 32,
                        decoration: const InputDecoration(
                          label: Text('Pan Card Number'),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please Enter the pancard number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          pancard = value!;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ImageInput(onPickedImage: (image) {
                        selectedImage = image;
                      }),
                      ElevatedButton(
                        onPressed: registerUser,
                        // saveDetails implement this function above,
                        child: isRegistering
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              // ),
            ),
          ],
        ),
      ),
    );
    Widget message = Center(
      child: Container(
        margin: const EdgeInsets.only(
          top: 160,
          bottom: 10,
          left: 30,
          right: 30,
        ),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/freshfarmicon.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'You application for registration has been submitted. Please wait for 2 days for our team to review further we will contact you soon. Thank you for choosing FreshFarm!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const InitialScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Home',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return Scaffold(
      body: registerSuccessfully ? message : content,
    );
  }
}
