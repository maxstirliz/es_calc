import 'package:es_calc/models/shopping_item.dart';
import 'package:es_calc/providers/shopping_list_provider.dart';
import 'package:es_calc/ui/widgets/edit_item_dialog.dart';
import 'package:es_calc/ui/widgets/item_card.dart';
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
        backgroundColor: Colors.greenAccent,
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
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        indicatorColor: Colors.lightBlueAccent,
        selectedIndex: currentNavigationIndex,
        backgroundColor: Colors.yellowAccent,
        onDestinationSelected: (index) {
          setState(() {
            currentNavigationIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_document),
            label: 'List',
          ),
          SizedBox(),
          NavigationDestination(
            icon: Icon(Icons.compare_arrows),
            label: 'Compare',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
