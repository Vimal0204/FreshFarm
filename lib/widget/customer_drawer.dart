import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm/screens/customer/customer_order.dart';
import 'package:fresh_farm/screens/customerProfile/customer_profile.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer(
      {super.key, required this.onSelectOption, required this.customerName});
  final void Function(String identifier) onSelectOption;
  final dynamic customerName;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/FreshFarmrectangle.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(
                  width: 18,
                ),
                Text(
                  'Hi, ${customerName.toString().toUpperCase()}',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              'My Profile',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const CustomerProfile(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: Text(
              'Your Orders',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const MyOrders(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(
              'Log Out',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            onTap: () {
              FirebaseAuth.instance.signOut();
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (ctx) => const HomePage(),
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }
}
