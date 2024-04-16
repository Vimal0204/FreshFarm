import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshfarm/Screens/buyerHome/buyers_home.dart';
import 'package:google_sign_in/google_sign_in.dart';

class BuyersAuthScreen extends StatefulWidget {
  const BuyersAuthScreen({super.key});

  @override
  State<BuyersAuthScreen> createState() => _BuyersAuthScreenState();
}

class _BuyersAuthScreenState extends State<BuyersAuthScreen> {
  
  void _signIn()async{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

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
            Colors.red,
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
          return const BuyersHomeScreen();
        }
        return Scaffold(body: content);
      },
    );
  }
}

  