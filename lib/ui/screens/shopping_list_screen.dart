import 'package:es_calc/providers/shopping_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:es_calc/utils/shopping_calculator.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() {
    return _ShoppingListScreenState();
  }
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  late Future<void> _itemsFuture;

  @override
  void initState() {
    _itemsFuture = ref.read(shoppingItemProvider.notifier).loadItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shoppingItems = ref.watch(shoppingItemProvider);
    final stateNotifier = ref.watch(shoppingItemProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 10,
        ),
        child: FutureBuilder(
            future: _itemsFuture,
            builder: (context, snapshot) {
              return Column(
                children: [
                  Text(
                      'Total: ${ShoppingCalculator.calculateGrandTotal(shoppingItems)}'),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: shoppingItems.length,
                      itemBuilder: (_, index) {
                        final item = shoppingItems[index];
                        return Dismissible(
                          key: ValueKey(item.id),
                          onDismissed: (direction) {
                            stateNotifier.deleteItem(item.id);
                          },
                          child: Card(
                            elevation: 1,
                            color: Colors.blue[100],
                            child: ListTile(
                              trailing: const Icon(Icons.menu),
                              leading: Checkbox(
                                value: item.isBought,
                                onChanged: (value) {
                                  setState(() {
                                    item.isBought = value!;
                                  });
                                },
                              ),
                              title: Text(item.title),
                              subtitle: Text(
                                  '${item.price} x ${item.quantity} = ${item.price * item.quantity}'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}