import 'package:es_calc/data/item_data_source.dart';
import 'package:es_calc/models/shopping_item.dart';

class ItemRepository {
  ItemRepository(this.dataSource);
  final ItemDataSource dataSource;

  Future<List<ShoppingItem>> getItems() {
    return dataSource.getItems();
  }

  Future<void> addItem(ShoppingItem item) {
    return dataSource.addItem(item);
  }

  Future<void> updateItem(ShoppingItem item) {
    return dataSource.updateItem(item);
  }

  Future<void> deleteItem(String itemId) {
    return dataSource.deleteItem(itemId);
  }
}
