import 'package:uuid/uuid.dart';
import 'package:es_calc/data/db_source.dart' as db;

const uuidProvider = Uuid();

class ShoppingItem {
  ShoppingItem({
    this.name = 'Product',
    this.price = 0.00,
    this.quantity = 1,
    this.isBought = false,
  }) : uuid = uuidProvider.v4();

  ShoppingItem.fromSource({
    required this.uuid,
    required this.name,
    required this.price,
    required this.quantity,
    required this.isBought,
  });

  String uuid;
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

  Map<String, dynamic> toMap() {
    return {
      db.uuid: uuid,
      db.name: name,
      db.price: price,
      db.quantity: quantity,
      db.isBought: isBought ? 1 : 0,
    };
  }

  ShoppingItem fromMap(Map<String, dynamic> entry) {
    return ShoppingItem.fromSource(
      uuid: entry[db.uuid],
      name: entry[db.name],
      price: entry[db.price],
      quantity: entry[db.quantity],
      isBought: entry[db.isBought] == 1 ? true : false,
    );
  }
}
