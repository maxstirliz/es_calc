import 'package:es_calc/providers/shopping_list_provider.dart';
import 'package:es_calc/ui/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


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
    _itemsFuture = ref.read(shoppingListProvider.notifier).loadItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shoppingItems = ref.watch(shoppingListProvider);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FutureBuilder(
        future: _itemsFuture,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Expanded(
                child: ListView.builder(
                  itemCount: shoppingItems.length,
                  itemBuilder: (_, index) {
                    return ItemCard(item: shoppingItems[index]);
                  },
                ),

          );
        }),
    );
  }
}