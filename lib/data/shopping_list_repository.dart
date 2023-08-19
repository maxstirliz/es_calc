import 'package:es_calc/data/shopping_list_data_source.dart';
import 'package:es_calc/models/shopping_item.dart';

class ShoppingListRepository {
  ShoppingListRepository(this.dataSource);
  final ShoppingListDataSource dataSource;

  Future<List<ShoppingItem>> getItems() {
    return dataSource.getItems();
  }

  Future<List<ShoppingItem>> addItem(ShoppingItem item) {
    return dataSource.addItem(item);
  }

  Future<List<ShoppingItem>> updateItem(ShoppingItem item) {
    return dataSource.updateItem(item);
  }

  Future<List<ShoppingItem>> deleteItem(String itemId) {
    return dataSource.deleteItem(itemId);
  }
}
