import 'package:flutter/material.dart';
import 'package:fresh_farm/screens/seller/seller_order.dart';
import 'package:fresh_farm/screens/sellerAuth/seller_login.dart';
import 'package:fresh_farm/screens/sellerProfile/seller_profile.dart';
// import 'package:freshfarm/home_page.dart';

class SellerDrawer extends StatelessWidget {
  const SellerDrawer({
    super.key,
    required this.onSelectOption,
    required this.uid,
  });
  final void Function(String identifier) onSelectOption;
  final String uid;

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
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
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
              Expanded(
                child: Text(
                  'Hi, ${uid.toString().toUpperCase()}',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
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
                MaterialPageRoute(builder: (ctx) => SellerProfile(uid: uid)));
          },
        ),
        ListTile(
          leading: const Icon(Icons.shopping_bag),
          title: Text(
            'See Orders',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => ShowOrders(uid: uid),
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const SellerAuth(),
              ),
            );
          },
        ),
      ],
    ));
  }
}
