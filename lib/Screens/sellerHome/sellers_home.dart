import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freshfarm/Screens/new_item.dart';
import 'package:freshfarm/drawer/sellers_drawer.dart';
import 'package:freshfarm/model/seller.dart';
import 'package:freshfarm/widget/seller_product.dart';
import 'package:http/http.dart' as http;

class SellersHomeScreen extends StatefulWidget {
  const SellersHomeScreen(
      {super.key,
      required this.uid,
      required this.email,
      required this.seller});
  final dynamic uid;
  final String email;
  final Seller seller;

  @override
  State<SellersHomeScreen> createState() => SellersHomeScreenState();
}

class SellersHomeScreenState extends State<SellersHomeScreen> {
  List<Product> showItem = [];
  // Seller seller = Seller(
  //   email: "",
  //   firstName: "",
  //   lastName: "",
  //   id: 0,
  //   mobile: "",
  //   address: "",
  //   city: "",
  //   state: "",
  //   pincode: 0,
  // );

  // String get getMail => widget.email;
  // void _loadFarmerDetails() async {
  //   print("loading");
  //   final url = Uri.https(
  //     'freshfarm.azurewebsites.net',
  //     '/api/farmerId/${widget.email}',
  //   );
  //   final response = await http.get(url);
  //   dynamic data = json.decode(response.body);
  //   setState(() {
  //     seller = Seller(
  //       email: widget.email,
  //       firstName: data['firstName'],
  //       lastName: data['lastName'],
  //       id: data['id'],
  //       mobile: data['mobile'],
  //       address: data['address'],
  //       city: data['city'],
  //       state: data['state'],
  //       pincode: data['pincode'],
  //     );
  //   });
  // }

  void _loadProduct() async {
    final url = Uri.https(
      'freshfarm.azurewebsites.net',
      '/api/getProductByFarmerId/${widget.seller.id}',
    );
    // print(url);
    final response = await http.get(url);
    List<dynamic> data = json.decode(response.body);
    // print(data);
    List<Product> loadProduct = data
        .map(
          (e) => Product(
            id: e['id'],
            imageUrl: e['imagelink'],
            productName: e['name'],
            quantity: e['quantity'],
            price: e['price'],
          ),
        )
        .toList();
    setState(() {
      showItem = loadProduct;
    });
  }

  void addProduct(Product product) async {
    setState(() {
      showItem.add(product);
    });
    final url = Uri.https(
      "freshfarm.azurewebsites.net",
      '/api/product/${widget.seller.id}',
    );
    await http.post(url,
        headers: {'content-type': 'application/json'},
        body: json.encode({
          "name": product.productName,
          "quantity": product.quantity,
          "price": product.price,
          "imagelink": product.imageUrl,
        }));

    // Future.delayed(const Duration(seconds: 10), () async {
    //   setState(
    //     () async {
    //       _loadProduct();
    //     },
    //   );
    // });
  }

  void _onRemoveProduct(Product product) async {
    var undo = false;
    final productIndex = showItem.indexOf(product);
    print(product.id);
    var l = showItem;
    l.remove(product);
    setState(
      () {
        showItem = l;
      },
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Product deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              showItem.insert(productIndex, product);
            });
            undo = true;
          },
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 5), () async {
      if (undo == false) {
        try {
          final url = Uri.https(
            "freshfarm.azurewebsites.net",
            '/api/product/${product.id}',
          );
          final response = await http.delete(
            url,
          );
          print(response.statusCode);
          final data = json.decode(response.body);
          print(data);
        } catch (error) {
          print(error);
        }
      }
    });
  }

  void onUpdate(double price, int quantity, Product product) async {
    product.price = price;
    product.quantity = quantity;
    final productIndex = showItem.indexOf(product);
    print(widget.seller.id);
    var l = showItem;
    l.remove(product);
    l.insert(productIndex, product);
    print(l.length);
    print((productIndex));
    setState(() {
      showItem = l;
    });
    final url = Uri.https(
      'freshfarm.azurewebsites.net',
      'api/product/${widget.seller.id}',
    );
    try {
      final response = await http.put(
        url,
        headers: {'content-type': 'application/json'},
        body: json.encode(
          {
            'id': product.id,
            'price': price,
            'quantity': quantity,
          },
        ),
      );
      print(response.statusCode);
      final data = json.decode(response.body);
      print(data);
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    // _loadFarmerDetails();

    // Future.delayed(const Duration(seconds: 10), () async {
    // setState(() {
    _loadProduct();
    // });
    // });

    super.initState();
  }

  void _onSelectOption(String identifier) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Widget mainContent = const Center(
    //   child: CircularProgressIndicator(),
    // );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fresh Farm'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => NewItem(
                        seller: widget.seller,
                        addProduct: addProduct,
                      )));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: SellerDrawer(
        seller: widget.seller,
        onSelectOption: _onSelectOption,
        userName: widget.seller.firstName,
      ),
      body: ListView.builder(
        itemCount: showItem.length,
        itemBuilder: (context, index) => ListTile(
          /*onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => UpdateProductWidget(
                  product: showItem[index],
                  productName: showItem[index].productName,
                  currentPrice: showItem[index].price,
                  currentQuantity: showItem[index].quantity,
                  onUpdate: onUpdate,
                ),
              ),
            );
          },
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Remove Item'),
                  content: const Text(
                      'Are you sure you want to remove this Product?'),
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
                        // CartController.removeFromCart(product);
                        _onRemoveProduct(showItem[index]);
                        Navigator.pop(context); // Close the dialog
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          },*/
          title: ProductWidget(
            onUpdate: onUpdate,
            product: showItem[index],
            onRemoveProduct: _onRemoveProduct,
          ),
        ),
      ),
    );
  }
}
