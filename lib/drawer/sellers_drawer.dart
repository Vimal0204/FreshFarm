// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshfarm/Screens/initial_screen.dart';
import 'package:freshfarm/Screens/sellerHome/seller_profile.dart';
import 'package:freshfarm/model/seller.dart';
import 'package:freshfarm/orders/seller_order.dart';

class SellerDrawer extends StatelessWidget {
  const SellerDrawer(
      {super.key, required this.onSelectOption, required this.userName,required this.seller});
  final void Function(String identifier) onSelectOption;
  final dynamic userName;
  final Seller seller;
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
                  'assets/images/freshfarmicon.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(
                  width: 18,
                ),
                Text(
                  'Hi, ${userName.toString().toUpperCase()}',
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
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => SellerProfile(seller: seller,),
                ),
              );
              
            },
          ),
          const SizedBox(
            height: 8,
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: Text(
              'Orders Received',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => OrdersReceivedScreen(seller: seller,),
                ),
              );
              
            },
          ),
          const SizedBox(
            height: 8,
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
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                    'Logout Alert',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                  ),
                  content: Text(
                    'Are you sure want to logout ?',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: Text(
                        'No',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const InitialScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Yes',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
