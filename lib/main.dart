import 'package:es_calc/ui/screens/shopping_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: EasySoppingCalculator()));
}

class EasySoppingCalculator extends StatelessWidget {
  const EasySoppingCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Easy Shopping Calculator',
      home: ShoppingListScreen(),
    );
  }
}
