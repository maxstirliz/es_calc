import 'package:es_calc/models/shopping_item.dart';
import 'package:es_calc/providers/shopping_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddItemDialog extends ConsumerStatefulWidget {
  const AddItemDialog({
    super.key,
  });

  @override
  ConsumerState<AddItemDialog> createState() {
    return _AddItemDialogState();
  }
}

class _AddItemDialogState extends ConsumerState<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final List<ShoppingItem> newItems = [];
  final _nameInputController = TextEditingController();
  final _quantityInputController = TextEditingController();
  final _nameFocusNode = FocusNode();
  var editedItem = ShoppingItem(isBought: false);

  @override
  void dispose() {
    _nameInputController.dispose();
    _quantityInputController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final stateNotifier = ref.watch(shoppingListProvider.notifier);

    return AlertDialog(
      title: const Text(
        'Add Shopping Items',
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              maxLines: 1,
              maxLength: 20,
              decoration: const InputDecoration(labelText: 'Item name'),
              controller: _nameInputController,
              focusNode: _nameFocusNode,
              onChanged: (value) {
                if (value == '' || value.trim() == '') {
                  return;
                }
                editedItem.name = value;
              },
              validator: (value) => _validateTextInput(value!),
            ),
            const SizedBox(height: 20),
            TextFormField(
              maxLines: 1,
              maxLength: 6,
              onChanged: (value) {
                if (double.tryParse(value) == null) {
                  return;
                }
                editedItem.quantity = double.parse(value);
              },
              decoration: const InputDecoration(
                labelText: 'Number / Quantity',
              ),
              controller: _quantityInputController,
              validator: (value) => _validateNumberInput(value!),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[ -]')),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge),
          child: const Text('Go back'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge),
          child: const Text('Add Item'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              stateNotifier.addItem(editedItem);
              editedItem = ShoppingItem(isBought: false);
              _quantityInputController.text = '1';
              _nameInputController.text = editedItem.name;
              _nameFocusNode.requestFocus();
              _nameInputController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _nameInputController.text.length);
            }
          },
        ),
      ],
    );
  }
}
