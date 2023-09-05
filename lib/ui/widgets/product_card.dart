import 'package:es_calc/models/shopping_item.dart';
import 'package:es_calc/providers/shopping_list_provider.dart';
import 'package:es_calc/ui/widgets/product_dialog.dart';
import 'package:es_calc/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerStatefulWidget {
  const ProductCard({
    super.key,
    required this.item,
    required this.animation,
    this.isDummy = false,
  });

  final ShoppingItem item;
  final Animation<double> animation;
  final bool isDummy;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProductCardState();
  }
}

class _ProductCardState extends ConsumerState<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final stateNotifier = ref.watch(shoppingListProvider.notifier);
    final shoppingItems = ref.watch(shoppingListProvider);

    return SizeTransition(
      key: ValueKey<String>(widget.item.uuid),
      sizeFactor: widget.animation,
      child: ExpansionTile(
        backgroundColor: Colors.grey[100],
        leading: Checkbox(
          value: widget.item.isBought,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onChanged: (value) async {
            widget.item.isBought = value!;
            final oldItem = widget.item;
            final oldIndex = shoppingItems.indexOf(widget.item);
            final newIndex = await stateNotifier.updateItem(widget.item);
            if (oldIndex == newIndex) {
              setState(() {});
            } else {
              if (!context.mounted) return;
              AnimatedList.of(context).removeItem(
                  oldIndex,
                  (context, animation) => ProductCard(
                        item: oldItem,
                        animation: animation,
                        isDummy: true,
                      ));
              AnimatedList.of(context).insertItem(newIndex);
            }
          },
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: widget.item.name != ''
              ? Text(widget.item.name)
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
                ),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: !widget.isDummy
                    ? () {
                        stateNotifier.deleteItem(widget.item.uuid);
                        AnimatedList.of(context).removeItem(
                          shoppingItems.indexOf(widget.item),
                          (context, animation) => ProductCard(
                            item: widget.item,
                            animation: animation,
                            isDummy: true,
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
                color: Colors.purple,
              ),
              IconButton(
                onPressed: !widget.isDummy
                    ? () async {
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
                          int oldIndex = shoppingItems.indexOf(widget.item);
                          int newIndex =
                              await stateNotifier.updateItem(updatedItem);
                          if (oldIndex != newIndex) {
                            if (!context.mounted) return;
                            AnimatedList.of(context).removeItem(
                                oldIndex,
                                (context, animation) => ProductCard(
                                      item: widget.item,
                                      animation: animation,
                                      isDummy: true,
                                    ));
                            AnimatedList.of(context).insertItem(newIndex);
                          }
                        }
                      }
                    : null,
                icon: const Icon(Icons.edit),
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
