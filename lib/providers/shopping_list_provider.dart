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

  Future<int> addItem(ShoppingItem item) async {
    await shoppingListRepository.addItem(item);
    final list = await shoppingListRepository.getItems();
    final newItem = list.where((i) => i.uuid == item.uuid).toList();
    state = [...list];
    return list.indexOf(newItem[0]);
  }

  Future<int> updateItem(ShoppingItem item) async {
    state = [...await shoppingListRepository.updateItem(item)];
    final list = await shoppingListRepository.getItems();
    final newItem = list.where((i) => i.uuid == item.uuid).toList();
    return list.indexOf(newItem[0]);
  }

  void deleteItem(String itemId) async {
    state = [...await shoppingListRepository.deleteItem(itemId)];
  }
}
