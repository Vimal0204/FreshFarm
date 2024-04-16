import 'package:flutter/material.dart';

class Product {
  final String imageUrl;
  final String productName;
  int quantity;
  double price;
  final int id;

  Product({
    required this.id,
    required this.imageUrl,
    required this.productName,
    required this.quantity,
    required this.price,
  });
}

class ProductWidget extends StatelessWidget {
  final Product product;
  final void Function(double price, int quantity, Product product) onUpdate;
  final void Function(Product product) onRemoveProduct;
  ProductWidget(
      {super.key,
      required this.product,
      required this.onUpdate,
      required this.onRemoveProduct});

  @override
  @override
  Widget build(BuildContext context) {
    final TextEditingController _priceController =
        TextEditingController(text: product.price.toString());
    final TextEditingController _quantityController =
        TextEditingController(text: product.quantity.toString());
    return Card(
      margin:const EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.imageUrl),
            SizedBox(height: 16.0),
            Text(
              'Product Name: ${product.productName}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
           const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quantity: ${product.quantity}',style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),),
                Text('Price: \$${product.price}',style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),),
              ],
            ),
            
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Update Product: ${product.productName}'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(labelText: 'Price'),
                              ),
                              TextField(
                                controller: _quantityController,
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecoration(labelText: 'Quantity'),
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                final double updatedPrice =
                                    double.tryParse(_priceController.text) ??
                                        product.price;
                                final int updatedQuantity =
                                    int.tryParse(_quantityController.text) ??
                                        product.quantity;
                                onUpdate(
                                    updatedPrice, updatedQuantity, product);
                                Navigator.pop(context);
                              },
                              child: Text('Update'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Update'),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Remove Product'),
                          content: Text(
                              'Are you sure you want to remove this product?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Perform remove product logic here
                                // For now, just print a message
                                onRemoveProduct(product);
                                Navigator.pop(context); // Close the dialog
                              },
                              child: Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Remove'),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
