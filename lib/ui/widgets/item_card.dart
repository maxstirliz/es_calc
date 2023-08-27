import 'package:es_calc/models/shopping_item.dart';
import 'package:es_calc/providers/shopping_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemCard extends ConsumerWidget {
  const ItemCard({
    super.key,
    required this.item,
  });

  final ShoppingItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateNotifier = ref.watch(shoppingListProvider.notifier);

    return Dismissible(
      key: ValueKey(item.id),
      onDismissed: (direction) {
        stateNotifier.deleteItem(item.id);
      },
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 4,
        ),
        color: Colors.grey[100],
        child: ListTile(
          leading: item.isBought
              ? const Icon(
                  Icons.check,
                  color: Colors.green,
                )
              : null,
          title: Text(item.name),
          trailing: Text('x ${item.quantity}'),
        ),
      ),
    );
  }
}
