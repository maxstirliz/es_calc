import 'package:es_calc/models/shopping_item.dart';

abstract class ShoppingListDataSource {
  Future<List<ShoppingItem>> getItems();
  Future<List<ShoppingItem>> addItem(ShoppingItem item);
  Future<List<ShoppingItem>> updateItem(ShoppingItem item);
  Future<List<ShoppingItem>> deleteItem(String itemId);
}
