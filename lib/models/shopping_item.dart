import 'package:uuid/uuid.dart';

const uuid = Uuid();

class ShoppingItem {
  ShoppingItem({
    this.name = 'Product',
    this.price = 0.00,
    this.quantity = 1,
    this.isBought = true,
  }) : id = uuid.v4();

  String id;
  String name;
  double price;
  double quantity;
  bool isBought;

  double get total {
    return price * quantity;
  }

  ShoppingItem copy() {
    return ShoppingItem(
      name: name,
      price: price,
      quantity: quantity,
      isBought: isBought,
    );
  }

  void updateValues(ShoppingItem item) {
    name = item.name;
    price = item.price;
    quantity = item.quantity;
    isBought = item.isBought;
  }
}
