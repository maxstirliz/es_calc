import 'package:es_calc/models/shopping_item.dart';

double calculateGrandTotal(List<ShoppingItem> items) {
  double total = 0.0;
  for (final item in items) {
    if (item.isBought) total += item.total;
  }
  return total;
}

String calculateBoughtItemsRation(List<ShoppingItem> items) {
  int boughtItems = 0;
  for (final item in items) {
    if (item.isBought) boughtItems++;
  }
  return '$boughtItems of ${items.length}';
}
