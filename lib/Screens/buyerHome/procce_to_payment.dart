import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:freshfarm/Screens/buyerHome/order_place.dart';
import 'package:freshfarm/Screens/buyerHome/payment_failed.dart';
import 'package:freshfarm/Screens/verify_screen.dart';
import 'package:freshfarm/model/customer.dart';
import 'package:freshfarm/state/state_not.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentCheckoutScreen extends ConsumerStatefulWidget {
  const PaymentCheckoutScreen({
    super.key,
    required this.cartItems,
    required this.totalAmount,
    required this.customer,
  });
  final List<ProductState> cartItems;
  final double totalAmount;
  final Customer customer;

  @override
  _PaymentCheckoutScreenState createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends ConsumerState<PaymentCheckoutScreen> {
  late Razorpay _razorpay;
  late final CartController cartController;
  @override
  void initState() {
    super.initState();
    setState(() {
      cartController = ref.read(cartProvider.notifier);
      cartController.loadCartData(widget.customer);
    });
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void clearCart() async {
    for (var element in widget.cartItems) {
      cartController.removeFromCart(element);
      final url = Uri.https(
        'freshfarm.azurewebsites.net',
        '/api/cart/${element.cartId}',
      );
      await http.delete(url);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
    placeOrder("Online via RazorPay");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => const OrderPlacedScreen(),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => const PaymentFailedScreen(),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }

  void opencheckout(amount) async {
    var options = {
      'key': 'rzp_test_qcqQ2YjO4gRdYb',
      'amount': (amount * 100).toString(), //in the smallest currency sub-unit.
      'name': 'Fresh Farm',
      // 'order_id': '${widget.customer.id}', // Generate order_id using Orders API
      'description': 'Total Items : ${widget.cartItems.length}',
      'timeout': 300, // in seconds
      'prefill': {
        'contact': widget.customer.mobile,
        'email': FirebaseAuth.instance.currentUser!.email
      },
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void sendEmail(String paymentMethod) async {
    final url = Uri.https(
      "freshfarmmail.azurewebsites.net",
      "/api/customerMail/OrderConfirmation",
    );
    final res=await http.post(
      url,
      headers: {
        'content-type': 'application/json',
      },
      body: json.encode(
        {
          "to": FirebaseAuth.instance.currentUser!.email,
          "customerName": FirebaseAuth.instance.currentUser!.displayName,
          "totalItem": widget.cartItems.length,
          "totalAmount": widget.totalAmount,
          "paymentMethod": paymentMethod,
        },
      ),
    );
    print(res.body);
  }

  void sendEmailFarmer(String sellerEmail, int orderId, int productId,
      int quantity, double amount, String paymentMethod) async {
    final urlSellerMail = Uri.https(
      "freshfarmmail.azurewebsites.net",
      "/api/farmerMail/OrderConfirmation",
    );
    await http.post(
      urlSellerMail,
      headers: {
        'content-type': 'application/json',
      },
      body: json.encode(
        {
          "to": sellerEmail,
          "orderId": orderId,
          "customerId": widget.customer.id,
          "productId": productId,
          "quantity": quantity,
          "Amount": amount,
          "paymentMethod": paymentMethod,
        },
      ),
    );
  }

  void placeOrder(String paymentMethod) async {
    for (var element in widget.cartItems) {
      // print(element);
      // write logic for getting product id.

      // write logic for getting farmer id.
      // write logic to place order.
      final purl = Uri.https(
        'freshfarm.azurewebsites.net',
        '/api/productbycart/${element.cartId}/1',
      );
      final response = await http.get(purl);
      // print(response.body);
      final data = json.decode(response.body);
      // print("product id is = " + data.toString());
      final furl = Uri.https(
        'freshfarm.azurewebsites.net',
        '/api/farmeridbyproduct/$data',
      );
      final res = await http.get(furl);
      // print(res);
      dynamic fid = json.decode(res.body);
      final url = Uri.https(
        'freshfarm.azurewebsites.net',
        '/api/orders/${widget.customer.id}/$fid/$data',
      );
      final ponse = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
        },
        body: json.encode(
          {
            "status": "pending",
            "quantity": element.quantity,
            "amount": element.cost,
            "customers": {"id": widget.customer.id},
            "product": {"id": data},
          },
        ),
      );
      print(
        ponse.statusCode,
      );
      // print(
      final ponseBody = json.decode(ponse.body);
      // );
      final urlFarmerMail = Uri.https(
        'freshfarm.azurewebsites.net',
        '/api/farmerEmailById/$fid',
      );
      final r = await http.get(urlFarmerMail);
      print("the status code is : ${r.statusCode}");
      print(r.body);
      final sellerEmail = r.body;
      print("the seller id is - "+sellerEmail.toString());
      sendEmailFarmer(
        sellerEmail,
        ponseBody['id'],
        data,
        element.quantity,
        element.cost,
        paymentMethod,
      );
    }
    clearCart();
    sendEmail(paymentMethod);
    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const OrderPlacedScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Total Amount: ${widget.totalAmount}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (ctx) => const RazorPay(),
                //   ),
                // );
                opencheckout(widget.totalAmount);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment via online')),
                );
              },
              child: const Text('Pay via Online'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                var verify = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const VerifyScreen(),
                  ),
                );
                if (verify) {
                  placeOrder('Cash on Delivery');
                }
                // ScaffoldMessenger.of(context).showSnackBar(
                // const  SnackBar(content: Text('Payment via Cash on Delivery')),
                // );
              },
              child: const Text('Pay via Cash on Delivery'),
            ),
          ],
        ),
      ),
    );
  }
  /* void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }*/
}
