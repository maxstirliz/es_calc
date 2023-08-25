import 'package:uuid/uuid.dart';

const uuid = Uuid();

class ShoppingItem {
  ShoppingItem({
    this.title = 'Product',
    this.price = 0.0,
    this.quantity = 1.0,
    this.isBought = true,
  }) : id = uuid.v4();

  String id;
  String title;
  double price;
  double quantity;
  bool isBought;

  double get total {
    return price * quantity;
  }

  ShoppingItem copy() {
    return ShoppingItem(
      title: title,
      price: price,
      quantity: quantity,
      isBought: isBought,
    );
  }

  void updateValues(ShoppingItem item) {
    title = item.title;
    price = item.price;
    quantity = item.quantity;
    isBought = item.isBought;
  }
}
