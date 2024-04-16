class ProductModel {
  ProductModel({
    required this.id,
    required this.cost,
    required this.image,
    required this.itemName,
    required this.quantity,
  });
  int? id;
  String itemName;
  int quantity;
  double cost;
  String image;  
}