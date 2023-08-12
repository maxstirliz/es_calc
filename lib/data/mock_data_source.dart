import 'package:es_calc/data/item_data_source.dart';
import 'package:es_calc/models/shopping_item.dart';

class MockDataSrouce implements ItemDataSource {
  List<ShoppingItem> shoppingItems = [
    ShoppingItem(
      title: 'Juice Box',
      quantity: 10,
      price: 21,
      isBought: true,
      isSummed: true,
    ),
    ShoppingItem(
      title: 'Bread',
      quantity: 1,
      price: 35,
      isBought: true,
      isSummed: true,
    ),
    ShoppingItem(
      title: 'Condenced Milk',
      quantity: 3,
      price: 56,
      isBought: true,
      isSummed: true,
    ),
    ShoppingItem(
      title: 'Ice Cream',
      quantity: 1,
      price: 98,
      isBought: true,
      isSummed: true,
    ),
  ];

  @override
  Future<List<ShoppingItem>> getItems() async {
    return shoppingItems;
  }

  @override
  Future<void> addItem(ShoppingItem item) async {
    shoppingItems.add(item);
  }

  @override
  Future<void> updateItem(ShoppingItem item) async {
    final itemIndex = shoppingItems.indexWhere((e) => e.id == item.id);
    if (itemIndex != -1) {
      shoppingItems[itemIndex].title = item.title;
      shoppingItems[itemIndex].price = item.price;
      shoppingItems[itemIndex].quantity = item.quantity;
      shoppingItems[itemIndex].isSummed = item.isSummed;
      shoppingItems[itemIndex].isBought = item.isBought;
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    shoppingItems.removeWhere((e) => e.id == id);
  }
}
