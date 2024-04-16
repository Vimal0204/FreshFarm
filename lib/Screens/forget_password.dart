import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:freshfarm/Screens/sellers_auth_screen.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/pointycastle.dart' as pointycastle;

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _form = GlobalKey<FormState>();
  String panController = '';
  String emailController = '';
  String passController = '';
  String mail = '';
  bool vald = false;
  bool changing = false;
  bool ver = false;

  String encryptAES(String text, String secretKey) {
    final keyBytes = Uint8List.fromList(utf8.encode(secretKey));
    final iv = Uint8List(16);
    final cipher = pointycastle.BlockCipher("AES/CBC")
      ..init(
        true,
        pointycastle.ParametersWithIV(
          pointycastle.KeyParameter(
            keyBytes,
          ),
          iv,
        ),
      );

    final inputBytes = Uint8List.fromList(
      utf8.encode(
        text,
      ),
    );
    final encryptedBytes = encryptBytes(
      cipher,
      inputBytes,
    );

    final encryptedText = base64.encode(
      encryptedBytes,
    );

    return encryptedText;
  }

  Uint8List encryptBytes(pointycastle.BlockCipher cipher, Uint8List input) {
    final blockSize = cipher.blockSize;
    final paddedInput = padBlock(
      input,
      blockSize,
    );
    final result = Uint8List(
      paddedInput.length,
    );
    for (var i = 0; i < paddedInput.length; i += blockSize) {
      cipher.processBlock(
        paddedInput,
        i,
        result,
        i,
      );
    }
    return result;
  }

  Uint8List padBlock(Uint8List input, int blockSize) {
    final padLength = blockSize - (input.length % blockSize);
    final padded = Uint8List(input.length + padLength);
    padded.setAll(
      0,
      input,
    );
    for (var i = input.length; i < padded.length; i++) {
      padded[i] = padLength;
    }
    return padded;
  }

  void _validateDetails() async {
    setState(() {
      ver = true;
    });
    final val = _form.currentState!.validate();
    if (!val) {
      return;
    }
    _form.currentState!.save();
    // print(emailController);
    // print(panController);
    String secretKey = "freshfarm 210763";
    String encryptPan = encryptAES(panController, secretKey);
    final url = Uri.https(
      'freshfarm.azurewebsites.net',
      '/api/farmerpp/$emailController?&pancard=$encryptPan',
    );

    final response = await http.get(
      url,
    );
    // print(object)
    vald = json.decode(response.body);
    // print(val);
    setState(() {
      if (vald == false) {
        ver = false;
      }
      vald;
      mail = emailController;
    });
  }

  void _forget() async {
    final val = _form.currentState!.validate();
    setState(() {
      changing = true;
    });
    if (!val) {
      return;
    }
    _form.currentState!.save();
    String secretKey = "freshfarm 210763";
    String encryptPass = encryptAES(passController, secretKey);
    // String pass = passController;
    final url = Uri.https(
      'freshfarm.azurewebsites.net',
      '/api/farmer/$mail',
    );
    await http.put(
      url,
      headers: {
        'content-type': 'application/json',
      },
      body: json.encode(
        encryptPass,
      ),
    );

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => const SellerAuthScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Enter your new password',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'ReEnter';
                }
                return null;
              },
              onSaved: (value) {
                // 
                passController = value!;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Implement forget password logic here ok
                // For now, just print the entered PAN card number
                _forget();
                // print('PAN card number entered');
              },
              child: changing
                  ? const CircularProgressIndicator()
                  : const Text('Submit'),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forget Password'),
      ),
      body: !vald
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Enter your email',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'ReEnter';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        emailController = value!;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Enter your PAN card number',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'ReEnter';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        panController = value!;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Implement forget password logic here
                        // For now, just print the entered PAN card number
                        _validateDetails();
                        // print('PAN card number entered');
                      },
                      child: ver
                          ? const CircularProgressIndicator()
                          : const Text('Submit'),
                    ),
                  ],
                ),
              ),
            )
          : content,
    );
  }
}
