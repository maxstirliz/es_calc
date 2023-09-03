import 'package:es_calc/models/shopping_item.dart';
import 'package:es_calc/providers/shopping_list_provider.dart';
import 'package:es_calc/ui/screens/shopping_cart.dart';
import 'package:es_calc/ui/widgets/product_dialog.dart';
import 'package:es_calc/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({
    super.key,
    required this.item,
    required this.animation,
  });

  final ShoppingItem item;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateNotifier = ref.watch(shoppingListProvider.notifier);
    final shoppingItems = ref.watch(shoppingListProvider);

    return SizeTransition(
      key: ValueKey(item.uuid),
      sizeFactor: animation,
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 4,
        ),
        color: Colors.grey[100],
        child: InkWell(
          onTap: () async {
            final updatedItem = await showDialog<ShoppingItem>(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return ProductDialog(
                    item: item,
                    title: 'Edit Item',
                  );
                });
            if (updatedItem != null) {
              int oldIndex = shoppingItems.indexOf(item);
              int newIndex = await stateNotifier.updateItem(updatedItem);
              if (oldIndex != newIndex) {
                listKey.currentState!.removeItem(oldIndex, (context, animation) => ProductCard(item: item, animation: animation));
                listKey.currentState!.insertItem(newIndex);
              }
            }
          },
          child: ListTile(
            leading: IconButton(
              onPressed: () async {
                item.isBought = !item.isBought;
                int oldIndex = shoppingItems.indexOf(item);
                int newIndex = await stateNotifier.updateItem(item);
                if (oldIndex != newIndex) {
                  listKey.currentState!.removeItem(oldIndex, (context, animation) => ProductCard(item: item, animation: animation));
                  listKey.currentState!.insertItem(newIndex);
                }
              },
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: item.isBought
                    ? Container(
                  key: const ValueKey('included'),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                )
                    : Container(
                  key: const ValueKey('not included'),
                  child: const Icon(
                    Icons.add,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            title: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: item.name != '' ? Text(item.name) : const Text('Product'),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${currencyFormatter(item.price)} x ${quantityFormatter(
                        item.quantity)}',
                    textAlign: TextAlign.start,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    currencyFormatter(item.total),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
              },
            ),
          ),
        ),
      ),
    );
  }
}
