import 'package:es_calc/data/shopping_list_data_source.dart';
import 'package:es_calc/models/shopping_item.dart';

class MockDataSrouce implements ShoppingListDataSource {
  List<ShoppingItem> shoppingList = [
    ShoppingItem(
      title: 'Juice Box',
      quantity: 10,
      price: 21,
      isBought: true,
    ),
    ShoppingItem(
      title: 'Bread',
      quantity: 1,
      price: 35,
      isBought: true,
    ),
    ShoppingItem(
      title: 'Condenced Milk',
      quantity: 3,
      price: 56,
      isBought: true,
    ),
    ShoppingItem(
      title: 'Ice Cream',
      quantity: 1,
      price: 98,
      isBought: true,
    ),
  ];

  @override
  Future<List<ShoppingItem>> getItems() async {
    return shoppingList;
  }

  @override
  Future<List<ShoppingItem>> addItem(ShoppingItem item) async {
    shoppingList.add(item);
    return shoppingList;
  }

  @override
  Future<List<ShoppingItem>> updateItem(ShoppingItem item) async {
    final itemIndex = shoppingList.indexWhere((e) => e.id == item.id);
    if (itemIndex != -1) {
      shoppingList[itemIndex].title = item.title;
      shoppingList[itemIndex].price = item.price;
      shoppingList[itemIndex].quantity = item.quantity;
      shoppingList[itemIndex].isBought = item.isBought;
    }
    return shoppingList;
  }

  @override
  Future<List<ShoppingItem>> deleteItem(String id) async {
    shoppingList.removeWhere((e) => e.id == id);
    return shoppingList;
  }
}
