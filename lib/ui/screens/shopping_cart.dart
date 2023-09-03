import 'package:es_calc/providers/shopping_list_provider.dart';
import 'package:es_calc/ui/widgets/product_card.dart';
import 'package:es_calc/utils/calculation_utils.dart';
import 'package:es_calc/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final listKey = GlobalKey<AnimatedListState>();

class ShoppingCartScreen extends ConsumerStatefulWidget {
  const ShoppingCartScreen({
    super.key,
  });

  @override
  ConsumerState<ShoppingCartScreen> createState() {
    return _ShoppingListScreenState();
  }
}

class _ShoppingListScreenState extends ConsumerState<ShoppingCartScreen> {
  late Future<void> _itemsFuture;
  int currentNavigationIndex = 0;

  @override
  void initState() {
    _itemsFuture = ref.read(shoppingListProvider.notifier).loadItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shoppingItems = ref.watch(shoppingListProvider);

    String getTotal() {
      final total = calculateGrandTotal(shoppingItems);
      return currencyFormatter(total);
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: FutureBuilder(
          future: _itemsFuture,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            calculateBoughtItemsRation(shoppingItems),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(),
                          Text(
                            'Total: ${getTotal()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: AnimatedList(
                          key: listKey,
                          initialItemCount: shoppingItems.length,
                          itemBuilder: (context, i, animation) {
                            return ProductCard(
                              item: shoppingItems[i],
                              animation: animation,
                            );
                          },
                        ),
                      ),
                    ],
                  );
          }),
    );
  }
}
