import 'package:es_calc/providers/shopping_list_provider.dart';
import 'package:es_calc/ui/widgets/product_card.dart';
import 'package:es_calc/utils/shopping_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingCartScreen extends ConsumerStatefulWidget {
  const ShoppingCartScreen({super.key});

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

    return Padding(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder(
          future: _itemsFuture,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Text(
                          'Total: ${ShoppingCalculator.calculateGrandTotal(shoppingItems)}'),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: shoppingItems.length,
                          itemBuilder: (_, index) {
                            return ProductCard(item: shoppingItems[index]);
                          },
                        ),
                      ),
                    ],
                  );
          }),
    );
  }
}
