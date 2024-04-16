import 'package:flutter/material.dart';
import 'package:freshfarm/Screens/initial_screen.dart';
//
class IntermediateScreen extends StatefulWidget{
  const IntermediateScreen({super.key,required this.uid,required this.username,required this.status,required this.message});
  final dynamic uid;
  final dynamic username;
  final dynamic status;
  final dynamic message;

  @override
  State<IntermediateScreen> createState() => _IntermediateScreenState();
}

class _IntermediateScreenState extends State<IntermediateScreen> {
  @override
  Widget build(BuildContext context) {
    Widget content;
    if (widget.status.toString().toLowerCase()=='pending') {
      content=Container(
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
                'You application is under review. Please wait further we will contact you soon. Thank you for choosing FreshFarm',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  // style: TextStyle(fontWeight: FontWeight.bold),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      );
    }
    else{
       content=Container(
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
                'You application is rejected because of pancard issue. Try to re-rister after 24 hrs.',
                style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.red),
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
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                ),
              ),
            ],
          ),
               ),
       );
    }
    return Scaffold(body: SingleChildScrollView(child: content));

  }
}