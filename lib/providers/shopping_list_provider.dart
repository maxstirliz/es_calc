import 'package:es_calc/data/shopping_list_repository.dart';
import 'package:es_calc/data/mock_data_source.dart';
import 'package:es_calc/models/shopping_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shoppingItemProvider =
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingItem>>(
        (ref) => ShoppingListNotifier());

class ShoppingListNotifier extends StateNotifier<List<ShoppingItem>> {
  ShoppingListNotifier() : super([]);
  final ShoppingListRepository itemRepository =
      ShoppingListRepository(MockDataSrouce());

  Future<void> loadItems() async {
    state = await itemRepository.getItems();
  }

  void addItem(ShoppingItem item) async {
    await itemRepository.addItem(item);
    state = [...await itemRepository.getItems()];
  }

  void updateItem(ShoppingItem item) async {
    state = [...await itemRepository.updateItem(item)];
  }

  void deleteItem(String itemId) async {
    state = [...await itemRepository.deleteItem(itemId)];
  }
}
