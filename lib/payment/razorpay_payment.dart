// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class RazorPay extends StatefulWidget{
//   const RazorPay({super.key});

//   @override
//   State<RazorPay> createState() => _RazorPayState();
// }
//
// class _RazorPayState extends State<RazorPay> {
//  final _razorpay = Razorpay();
//   static const platform=const MethodChannel("razorpay_flutter");
// @override
// void initState(){
//   super.initState();
// _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
// _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
// _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
// }

// void _handlePaymentSuccess(PaymentSuccessResponse response) {
//   // Do something when payment succeeds
// }
// void _handlePaymentError(PaymentFailureResponse response) {
//   // Do something when payment fails
// }

// void _handleExternalWallet(ExternalWalletResponse response) {
//   // Do something when an external wallet is selected
// }
// @override
// void dispose(){
//   super.dispose();
//   _razorpay.clear(); // Removes all listeners
// }
// var options = {
//   'key': '<YOUR_KEY_ID>',
//   'amount': 50000, //in the smallest currency sub-unit.
//   'name': 'Acme Corp.',
//   'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
//   'description': 'Fine T-Shirt',
//   'timeout': 60, // in seconds
//   'prefill': {
//     'contact': '9000090000',
//     'email': 'gaurav.kumar@example.com'
//   }
// };
// // try{
// //   _razorpay.open(options);
// // }catch(e){
// //   debugPrint(e);
// // }
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }