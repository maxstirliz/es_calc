import 'package:es_calc/data/db_source.dart';
import 'package:es_calc/data/shopping_list_repository.dart';
import 'package:es_calc/models/shopping_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingItem>>(
        (ref) => ShoppingListNotifier());

class ShoppingListNotifier extends StateNotifier<List<ShoppingItem>> {
  ShoppingListNotifier() : super([]);
  final ShoppingListRepository shoppingListRepository =
      ShoppingListRepository(DatabaseSource());

  Future<void> loadItems() async {
    state = await shoppingListRepository.getItems();
  }

  void addItem(ShoppingItem item) async {
    await shoppingListRepository.addItem(item);
    state = [...await shoppingListRepository.getItems()];
  }

  void updateItem(ShoppingItem item) async {
    state = [...await shoppingListRepository.updateItem(item)];
  }

  void deleteItem(String itemId) async {
    state = [...await shoppingListRepository.deleteItem(itemId)];
  }
}
