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
    final stateNotifier = ref.watch(shoppingItemProvider.notifier);
    return Dismissible(
      key: ValueKey(item.id),
      onDismissed: (direction) {
        stateNotifier.deleteItem(item.id);
      },
      child: Card(
        elevation: 1,
        color: Colors.blue[100],
        child: ListTile(
          trailing: IconButton(
            icon: const Icon(Icons.expand_circle_down_outlined),
            onPressed: () {},
          ),
          leading: Checkbox(
            value: item.isBought,
            onChanged: (value) {
              item.isBought = value!;
              stateNotifier.updateItem(item);
            },
          ),
          title: Text(item.title),
          subtitle: Text(
              '${item.price} x ${item.quantity} = ${item.price * item.quantity}'),
        ),
      ),
    );
  }
}
