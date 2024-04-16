import 'package:flutter/material.dart';
import 'package:freshfarm/widget/seller_product.dart';

class UpdateProductWidget extends StatefulWidget {
  final String productName;
  final double currentPrice;
  final int currentQuantity;
  final Product product;
  final Function(double price, int quantity,Product product) onUpdate;

  const UpdateProductWidget({
    Key? key,
    required this.product,
    required this.productName,
    required this.currentPrice,
    required this.currentQuantity,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _UpdateProductWidgetState createState() => _UpdateProductWidgetState();
}

class _UpdateProductWidgetState extends State<UpdateProductWidget> {
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: widget.currentPrice.toString());
    _quantityController = TextEditingController(text: widget.currentQuantity.toString());
  }
  @override
  void dispose() {
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Product: ${widget.productName}'),
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
            decoration: InputDecoration(labelText: 'Quantity'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final double updatedPrice = double.tryParse(_priceController.text) ?? widget.currentPrice;
            final int updatedQuantity = int.tryParse(_quantityController.text) ?? widget.currentQuantity;
            widget.onUpdate(updatedPrice, updatedQuantity,widget.product);
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
  }
}