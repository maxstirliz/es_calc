import 'package:es_calc/models/shopping_item.dart';
import 'package:es_calc/providers/shopping_list_provider.dart';
import 'package:es_calc/ui/widgets/product_dialog.dart';
import 'package:es_calc/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableProductCard extends ConsumerStatefulWidget {
  const SlidableProductCard({
    super.key,
    required this.item,
  });

  final ShoppingItem item;

  @override
  ConsumerState<SlidableProductCard> createState() =>
      _SlidableProductCardState();
}

class _SlidableProductCardState extends ConsumerState<SlidableProductCard> {
  @override
  Widget build(BuildContext context) {
    final stateNotifier = ref.watch(shoppingListProvider.notifier);
    return Slidable(
      key: ValueKey<String>(widget.item.uuid),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              // TODO: add to favorites
            },
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            icon: Icons.favorite,
            label: 'Favorite',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              // TODO: delete item
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.all(1),
        shape: Border.all(
          width: 0,
          color: Colors.transparent,
        ),
        child: InkWell(
          onTap: () async {
            final updatedItem = await showDialog<ShoppingItem>(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return ProductDialog(
                    item: widget.item,
                    title: 'Edit Item',
                  );
                });
            if (updatedItem != null) {
              stateNotifier.updateItem(updatedItem);
            }
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 6,
            ),
            dense: true,
            leading: Checkbox(
                value: widget.item.isBought,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onChanged: (value) async {
                  widget.item.isBought = value!;
                  stateNotifier.updateItem(widget.item);
                }),
            title: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: widget.item.name != ''
                  ? Text(
                      widget.item.name,
                      style: const TextStyle(fontSize: 16),
                    )
                  : const Text('Product'),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${currencyFormatter(widget.item.price)} × ${quantityFormatter(widget.item.quantity)}',
                    textAlign: TextAlign.start,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    currencyFormatter(widget.item.total),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
