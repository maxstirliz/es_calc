import 'package:es_calc/data/item_repository.dart';
import 'package:es_calc/data/mock_data_source.dart';
import 'package:es_calc/models/shopping_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shoppingItemProvider =
    StateNotifierProvider<ShoppingItemProvider, List<ShoppingItem>>(
        (ref) => ShoppingItemProvider());

class ShoppingItemProvider extends StateNotifier<List<ShoppingItem>> {
  ShoppingItemProvider() : super([]);
  final ItemRepository itemRepository = ItemRepository(MockDataSrouce());

  Future<void> loadItems() async {
    state = await itemRepository.getItems();
  }

  void addItem(ShoppingItem item) async {
    await itemRepository.addItem(item);
    state = await itemRepository.getItems();
  }

  void updateItem(ShoppingItem item) async {
    await itemRepository.updateItem(item);
    state = await itemRepository.getItems();
  }

  void deleteItem(String itemId) async {
    await itemRepository.deleteItem(itemId);
    state = await itemRepository.getItems();
  }
}
