import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshfarm/Screens/buyerHome/procce_to_payment.dart';
import 'package:freshfarm/model/customer.dart';
import 'package:freshfarm/state/state_not.dart';
// impllement init state method to load the method for the first time somehow..  done

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key, required this.customer});

  final Customer customer;

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  late final CartController cartController;

  @override
  void initState() {
    setState(() {
      cartController = ref.read(cartProvider.notifier);
      cartController.loadCartData(widget.customer);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            onPressed: () {
              double totalAmount = 0;
              for (var element in cartItems) {
                totalAmount = totalAmount + element.cost;
              }
              cartItems.map((e) {
                totalAmount = totalAmount + e.cost;
              });
              // print(totalAmount);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => PaymentCheckoutScreen(
                      customer: widget.customer,
                      cartItems: cartItems,
                      totalAmount: totalAmount),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart_checkout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Cart Items',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Display cart items
            ...cartItems.map((product) {
              return ListTile(
                title: Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
                subtitle: Text(
                  'Cost: \$${product.cost.toString()}',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Remove Item'),
                        content: const Text(
                            'Are you sure you want to remove this item from the cart?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Remove product from cart
                              cartController.removeFromCart(product);
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                trailing: Text(
                  'Quantity: ${product.quantity.toString()}',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}



/*class CartScreen extends ConsumerWidget {
  const CartScreen({super.key,required this.customer});
  final Customer customer;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final cartItems = ref.watch(cartProvider);
    final CartController = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Cart Items',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Display cart items
            ...cartItems.map((product) {
              return ListTile(
                title: Text(product.name),
                subtitle: Text('Cost: \$${product.cost.toString()}'),
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Remove Item'),
                          content: const Text(
                              'Are you sure you want to remove this item from the cart?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Remove product from cart
                                CartController.removeFromCart(product);
                                Navigator.pop(context); // Close the dialog
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      });
                },
                trailing: Text('Quantity: ${product.quantity.toString()}'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
*/