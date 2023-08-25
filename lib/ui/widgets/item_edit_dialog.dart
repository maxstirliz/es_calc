import 'package:es_calc/models/shopping_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class ItemEditDialog extends StatefulWidget {
  const ItemEditDialog({super.key, required this.item});

  final ShoppingItem item;

  @override
  State<StatefulWidget> createState() {
    return _ItemEditDialogState();
  }
}

class _ItemEditDialogState extends State<ItemEditDialog> {
  final _formKey = GlobalKey<FormState>();

  late ShoppingItem editedItem;
  late double total;

  @override
  void initState() {
    super.initState();
    editedItem = widget.item.copy();
    total = editedItem.total;
  }

  String? _validateNumberInput(String value) {
    if (double.tryParse(value) == null) {
      return 'Not a number';
    }
    return null;
  }

  String? _validateTextInput(
    String value,
  ) {
    if (value == '' || value.trim() == '') {
      return 'Must contain at least one symbol';
    }
    editedItem.title = value;
    return null;
  }

  void _updateTotalPrice() {
    setState(() {
      total = editedItem.total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit ${editedItem.title}',
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              maxLength: 20,
              maxLines: 1,
              decoration: const InputDecoration(
                labelText: 'Product name',
              ),
              initialValue: editedItem.title,
              validator: (value) => _validateTextInput(value!),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    maxLines: 1,
                    maxLength: 6,
                    onChanged: (value) {
                      if (double.tryParse(value) == null) {
                        return;
                      }
                      editedItem.quantity = double.parse(value);
                      _updateTotalPrice();
                    },
                    decoration: const InputDecoration(
                      labelText: 'Unit quantity',
                    ),
                    validator: (value) => _validateNumberInput(value!),
                    initialValue: editedItem.quantity.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'[ -]')),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Transform.rotate(
                  angle: math.pi / 4,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    maxLines: 1,
                    maxLength: 6,
                    onChanged: (value) {
                      if (double.tryParse(value) == null) {
                        return;
                      }
                      editedItem.price = double.parse(value);
                      _updateTotalPrice();
                    },
                    decoration: const InputDecoration(
                      labelText: 'Price per unit',
                    ),
                    validator: (value) => _validateNumberInput(value!),
                    initialValue: editedItem.price.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'[ -]')),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${editedItem.title} total: $total',
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge),
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge),
          child: const Text('Save'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              widget.item.updateValues(editedItem);
              Navigator.of(context).pop<ShoppingItem>(widget.item);
            }
          },
        ),
      ],
    );
  }
}
