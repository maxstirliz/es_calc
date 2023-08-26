import 'package:es_calc/models/shopping_item.dart';
import 'package:es_calc/providers/shopping_list_provider.dart';
import 'package:es_calc/ui/widgets/edit_item_dialog.dart';
import 'package:es_calc/ui/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:es_calc/utils/shopping_calculator.dart';


class ShoppingCartScreen extends ConsumerStatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  ConsumerState<ShoppingCartScreen> createState() {
    return _ShoppingListScreenState();
  }
}

class _ShoppingListScreenState extends ConsumerState<ShoppingCartScreen> {
  late Future<void> _itemsFuture;

  @override
  void initState() {
    _itemsFuture = ref.read(shoppingListProvider.notifier).loadItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shoppingItems = ref.watch(shoppingListProvider);
    final stateNotifier = ref.watch(shoppingListProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Easy Shopping Calculator')),
      body: Padding(
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
                              return ItemCard(item: shoppingItems[index]);
                            },
                          ),
                        ),
                      ],
                    );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        onPressed: () async {
          final updatedItem = await showDialog<ShoppingItem>(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return ItemEditDialog(
                  item: ShoppingItem(),
                  title: 'Add Item',
                );
              });
          if (updatedItem != null) {
            stateNotifier.addItem(updatedItem);
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.yellowAccent,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit_document),
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.compare_arrows),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
