import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:freshfarm/Screens/buyerHome/cart_screen.dart';
import 'package:freshfarm/model/customer.dart';
import 'package:freshfarm/state/state_not.dart';

class ProductCard extends ConsumerStatefulWidget {
  const ProductCard(
      {super.key,
      required this.id,
      required this.imageUrl,
      required this.productName,
      required this.productCost,
      required this.customer
      // required this.productQuantity,
      });
  final int id;
  final String imageUrl;
  final String productName;
  final double productCost;
  final Customer customer;
  // final int productQuantity;

  @override
  ConsumerState<ProductCard> createState() {
    return _ProductCard();
  }
}

class _ProductCard extends ConsumerState<ProductCard> {
  int quantity = 1;

  @override
  Widget build(BuildContext contex) {
    final cartController = ref.watch(cartProvider.notifier);
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                widget.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.productName,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  // const SizedBox(height: 6),
                  Text(
                    '₹ ${widget.productCost.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      if (quantity > 1) {
                        quantity--;
                      }
                    });
                  },
                  icon: const Icon(Icons.remove),
                  label: const Text(''),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                ),
                Text(
                  quantity.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(''),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    primary: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    cartController.addToCart(
                      ProductState(
                        productId: widget.id,
                        cartId: 0,
                        name: widget.productName,
                        cost: widget.productCost * quantity,
                        quantity: quantity,
                      ),
                      widget.customer,
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
