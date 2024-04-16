import 'package:flutter/material.dart';
import 'dart:math';
class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});
  
  @override
  State createState()=> _VerifyScreenState();
}
class _VerifyScreenState extends State<VerifyScreen> {
  int? randomNum1;
  int? randomNum2;
  int? userSum;
  String result = '';

  @override
  void initState() {
    super.initState();
    generateRandomNumbers();
  }

  void generateRandomNumbers() {
    final random = Random();
    randomNum1 = random.nextInt(50); // Generates a random number between 0 and 49
    randomNum2 = random.nextInt(50); // Generates a random number between 0 and 49
  }

  void checkSum() {
    setState(() {
      if (userSum == (randomNum1! + randomNum2!)) {
        Navigator.of(context).pop(true);
      } else {
        result = 'Verification failed';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Solve the puzzle'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             const Text(
                'Find the sum of the following numbers:',
                style: TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 20.0),
              Text(
                '$randomNum1 + $randomNum2 = ?',
                style:const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
             const SizedBox(height: 20.0),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  userSum = int.tryParse(value);
                },
                decoration:const InputDecoration(
                  hintText: 'Enter the sum',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  checkSum();
                },
                child:const Text('Submit'),
              ),
              const SizedBox(height: 20.0),
              Text(
                result,
                style:const TextStyle(fontSize: 20.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
