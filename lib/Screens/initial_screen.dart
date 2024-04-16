import 'package:flutter/material.dart';
import 'package:freshfarm/Screens/buyers_auth_screen.dart';
// import 'package:freshfarm/Screens/sellerRegister/seller_register.dart';
import 'package:freshfarm/Screens/sellers_auth_screen.dart';
// import 'package:freshfarm/Screens/sellers_auth_screen.dart';
class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white54,
            Colors.white12,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 210,
            width: 350,
            margin: const EdgeInsets.only(
              top: 90,
              left: 5,
              right: 5,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/freshfarmlogo.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // const SizedBox(height: 70,),
          MaterialButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const BuyersAuthScreen(),
                ),
              );
            },
            color: const Color.fromARGB(
              255,
              24,
              152,
              139,
            ),
            height: 80,
            minWidth: double.infinity,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: Text(
              "For Buyers",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          // const SizedBox(height: 10,),
          MaterialButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const SellerAuthScreen(),
                ),
              );
            },
            color: const Color.fromARGB(
              255,
              24,
              152,
              139,
            ),
            height: 80,
            minWidth: double.infinity,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: Text(
              "For Sellers",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          // const SizedBox(height:10,),
          Container(
            height: 150,
            width: double.maxFinite,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/onion.jpeg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
    return content;
  }
}
