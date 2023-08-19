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

  String id;
  String title;
  double price;
  double quantity;
  bool isSummed;
  bool isBought;

  // ShoppingItem copyWith({
  //   String? currentId,
  //   String? title,
  //   double? price,
  //   double? quantity,
  //   bool? isSummed,
  //   bool? isBought,
  // }) {
  //   final item = ShoppingItem(
  //     title: title ?? this.title,
  //     price: price ?? this.price,
  //     quantity: quantity ?? this.quantity,
  //     isBought: isBought ?? this.isBought,
  //     isSummed: isSummed ?? this.isSummed,
  //   );
  //   return item;
  // }

  double get total {
    return price * quantity;
  }
}
