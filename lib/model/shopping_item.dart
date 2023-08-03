import 'package:uuid/uuid.dart';

const uuid = Uuid();

class ShoppingItem {
  ShoppingItem({
    this.title = 'Product',
    required this.price,
    this.quantity = 1,
    this.isIncluded = true,
    this.isBought = false,
  }) : id = uuid.v4();

  final String id;
  final String title;
  double price;
  double quantity;
  bool isIncluded;
  bool isBought;
}
