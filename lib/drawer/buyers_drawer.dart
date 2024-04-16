import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshfarm/Screens/buyerHome/customer_profile.dart';
// import 'package:freshfarm/model/customer.dart';
import 'package:freshfarm/orders/customers_order.dart';
// 
class BuyerDrawer extends StatelessWidget {
  const BuyerDrawer({
    super.key,
    required this.onSelectOption,
    required this.userName,
    // required this.customer,
  });
  final void Function(String identifier) onSelectOption;
  final dynamic userName;
  // final Customer customer;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(10),
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
            child: Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/freshfarmicon.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  Expanded(
                    child: Text(
                      'Hi, ${userName.toString().toUpperCase()}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
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
              // print(customer.address);
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => CustomerProfile(),
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
              'Your Orders',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => OrdersScreen(),
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
                        FirebaseAuth.instance.signOut();
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
