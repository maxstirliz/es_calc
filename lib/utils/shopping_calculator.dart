import 'package:es_calc/models/shopping_item.dart';

class ShoppingCalculator {
  static double calculateGrandTotal(List<ShoppingItem> items) {
    double total = 0.0;
    for (final item in items) {
      if (item.isBought) total += item.total;
    }
    return total;
  }
}
