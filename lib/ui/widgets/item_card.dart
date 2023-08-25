import 'package:es_calc/models/shopping_item.dart';
import 'package:es_calc/providers/shopping_list_provider.dart';
import 'package:es_calc/ui/widgets/item_edit_dialog.dart';
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

    void toggleBoughtIcon(ShoppingItem item) {
      item.isBought = !item.isBought;
      stateNotifier.updateItem(item);
    }

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
          leading: IconButton(
            onPressed: () => toggleBoughtIcon(item),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: item.isBought
                  ? Container(
                      key: const ValueKey('included'),
                      child: const Icon(
                        Icons.shopping_cart,
                        color: Colors.green,
                      ),
                    )
                  : Container(
                      key: const ValueKey('not included'),
                      child: const Icon(
                        Icons.add,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.blueGrey,
            ),
            onPressed: () async {
              final ShoppingItem updatedItem = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return ItemEditDialog(
                      item: item,
                    );
                  });
              stateNotifier.updateItem(updatedItem);
            },
          ),
          title: Text(item.title),
          subtitle: Text('${item.price} x ${item.quantity} = ${item.total}'),
        ),
      ),
    );
  }
}
