import 'package:es_calc/models/shopping_item.dart';

abstract class ItemDataSource {
  Future<List<ShoppingItem>> getItems();
  Future<void> addItem(ShoppingItem item);
  Future<void> updateItem(ShoppingItem item);
  Future<void> deleteItem(String itemId);
}
