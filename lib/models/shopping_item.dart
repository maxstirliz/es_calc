import 'package:uuid/uuid.dart';

const uuid = Uuid();

class ShoppingItem {
  ShoppingItem({
    this.title = 'Product',
    this.price = 0.0,
    this.quantity = 1.0,
    this.isSummed = true,
    this.isBought = true,
  }) : id = uuid.v4();

  final String id;
  String title;
  double price;
  double quantity;
  bool isSummed;
  bool isBought;

  double get total {
    return price * quantity;
  }
}
