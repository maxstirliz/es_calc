import 'package:es_calc/models/shopping_item.dart';
import 'package:es_calc/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class ProductDialog extends StatefulWidget {
  const ProductDialog({
    super.key,
    required this.item,
    required this.title,
  });

  final ShoppingItem item;
  final String title;

  @override
  State<ProductDialog> createState() {
    return _ProductDialogState();
  }
}

class _ProductDialogState extends State<ProductDialog> {
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
    editedItem.name = value;
    return null;
  }

  void _updateTotalPrice() {
    setState(() {
      total = editedItem.total;
    });
  }

  String _normalizedInitialPriceValue(double value) {
    if (currencyFormatter(value).length > 6) {
      return currencyFormatter(value).substring(0, 6);
    } else if (currencyFormatter(value).substring(
            currencyFormatter(value).length - 3,
            currencyFormatter(value).length) ==
        '.00') {
      return currencyFormatter(value)
          .substring(0, currencyFormatter(value).length - 3);
    } else {
      return currencyFormatter(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                maxLines: 1,
                maxLength: 20,
                decoration: const InputDecoration(labelText: 'Product name'),
                initialValue: editedItem.name,
                onChanged: (value) {
                  if (value == '' || value.trim() == '') {
                    return;
                  }
                  editedItem.name = value;
                  _updateTotalPrice();
                },
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
                        editedItem.price = double.parse(value);
                        _updateTotalPrice();
                      },
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                      validator: (value) => _validateNumberInput(value!),
                      initialValue:
                          _normalizedInitialPriceValue(editedItem.price),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[-, ]')),
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
                        editedItem.quantity = double.parse(value);
                        _updateTotalPrice();
                      },
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                      ),
                      validator: (value) => _validateNumberInput(value!),
                      initialValue: quantityFormatter(editedItem.quantity),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[-, ]')),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${editedItem.name} total: ${currencyFormatter(total)}',
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
              widget.item.updateValues(editedItem);
              if (widget.item.total > 0) {
                widget.item.isBought = true;
              }

              Navigator.of(context).pop<ShoppingItem>(widget.item);
            }
          },
        ),
      ],
    );
  }
}