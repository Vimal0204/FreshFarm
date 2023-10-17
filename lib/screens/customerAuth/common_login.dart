/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm/screens/customerAuth/cust_home.dart';
import 'package:fresh_farm/screens/sellerAuth/seller_home.dart';

class CommonLogin extends StatelessWidget {
  const CommonLogin({super.key});

  @override
  Widget build(BuildContext context) {
    var role = '';
    var id = FirebaseAuth.instance.currentUser!.uid;
    Widget content = const SellerHomeScreen();
    void getRole(var uid) async {
       var c=await FirebaseFirestore.instance
          .collection('customers')
          .doc(uid)
          .get();
          print(c);
        role=  c.data()!['role'];
       
        if (role=='customer') {
          if (context.mounted) {
            print('success');
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const CustomerHomeScreen(),),);
          
          }
        }

      //     .then((value) {
      //   role = value.data()!['role'].toString();
      //   print(role);
      // });
      
    }
    
    getRole(id);
    // print(role);
    // print('the role is$role');
  //  return content;
   return content;
  }
}
*/