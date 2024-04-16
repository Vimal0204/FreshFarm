import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshfarm/model/customer.dart';
import 'package:http/http.dart' as http;

final cartProvider =
    StateNotifierProvider<CartController, List<ProductState>>((ref) {
  return CartController();
});

class ProductState {
  final int? cartId;
  final int? productId;
  final String name;
  final double cost;
  final int quantity;

  ProductState({
    required this.productId,
    required this.cartId,
    required this.name,
    required this.cost,
    required this.quantity,
  });
}

class CartController extends StateNotifier<List<ProductState>> {
  CartController() : super([]);

  //load cart from database for the first time. ok
  void loadCartData(Customer customer) async {
    final url = Uri.https(
      'freshfarm.azurewebsites.net',
      '/api/cart/${customer.id}',
    );
    final response = await http.get(url);
    final List<dynamic> jsonData = json.decode(response.body);
    print(jsonData);
    final List<ProductState> product = jsonData
        .map(
          (e) => ProductState(
              productId: 0,
              cartId: e['id'],
              name: e['productName'],
              cost: e['amount'],
              quantity: e['quantity']),
        )
        .toList();
        // for (var element in product) {
        //   state=[...state,element];
        // }
    state = product;
  }

  // Add product to cart
  void addToCart(ProductState product, Customer customer) async {
    state = [...state, product];
    // print(product.cartId);
    // final purl=Uri.https(
    //   "freshfarm.azurewebsites.net",
    //   '/api/productbycart/${product.cartId}',
    // );
    // final response=await http.get(purl);
    // dynamic pid=json.decode(response.body);
    final url = Uri.https(
      "freshfarm.azurewebsites.net",
      '/api/cart/${customer.id}/${product.productId}',
    );
    await http.post(
      url,
      headers: {
        'content-type': 'application/json',
      },
      body: json.encode(
        {
          "productName": product.name,
          "quantity": product.quantity,
          "amount": product.cost,
          "product": {
            "id": product.productId,
          }
          // "productId":product.productId,
        },
      ),
    );
  }

  // Remove product from cart
  Future<void> removeFromCart(ProductState product) async {
    state = state.where((item) => item != product).toList();
    print(product.cartId);
    final url = Uri.https(
      'freshfarm.azurewebsites.net',
      '/api/cart/${product.cartId}',
    );
    await http.delete(url);
  }
}
