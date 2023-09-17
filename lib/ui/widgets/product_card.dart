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
  final _animationDuration = 350;

  @override
  Widget build(BuildContext context) {
    final stateNotifier = ref.watch(shoppingListProvider.notifier);
    final shoppingItems = ref.watch(shoppingListProvider);
    final currentIndex = shoppingItems.indexOf(widget.item);

    return IgnorePointer(
      key: ValueKey<String>(widget.item.uuid),
      ignoring: widget.isDummy,
      child: SizeTransition(
        sizeFactor: widget.animation,
        child: Card(
          elevation: 1,
          margin: const EdgeInsets.all(2),
          shape: Border.all(
            width: 0,
            color: Colors.transparent,
          ),
          child: InkWell(
            onTap: () async {
              final oldItem = widget.item;
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
                int newIndex = await stateNotifier.updateItem(updatedItem);
                if (currentIndex != newIndex) {
                  if (!context.mounted) return;
                  AnimatedList.of(context).removeItem(
                    currentIndex,
                    (context, animation) => ProductCard(
                      item: oldItem,
                      animation: animation,
                      isDummy: true,
                    ),
                    duration: Duration(milliseconds: _animationDuration),
                  );
                  AnimatedList.of(context).insertItem(newIndex,
                      duration: Duration(milliseconds: _animationDuration));
                }
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
                    final oldItem = widget.item;
                    final newIndex =
                        await stateNotifier.updateItem(widget.item);

                    if (currentIndex != newIndex) {
                      if (!context.mounted) return;
                      AnimatedList.of(context).removeItem(
                        currentIndex,
                        (context, animation) => ProductCard(
                          item: oldItem,
                          animation: animation,
                          isDummy: true,
                        ),
                        duration: Duration(milliseconds: _animationDuration),
                      );

                      AnimatedList.of(context).insertItem(
                        newIndex,
                        duration: Duration(milliseconds: _animationDuration),
                      );
                    }
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
              trailing: IconButton(
                onPressed: () {
                  final removedItem = widget.item;
                  stateNotifier.deleteItem(widget.item.uuid);
                  AnimatedList.of(context).removeItem(
                    shoppingItems.indexOf(widget.item),
                    (context, animation) => ProductCard(
                      item: removedItem,
                      animation: animation,
                      isDummy: true,
                    ),
                    duration: Duration(milliseconds: _animationDuration),
                  );
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
