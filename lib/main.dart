import 'package:es_calc/screens/shopping_list_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EasySoppingCalculator());
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
