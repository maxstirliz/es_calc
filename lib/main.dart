import 'package:es_calc/ui/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: EasySoppingCalculator()));
}

class EasySoppingCalculator extends StatelessWidget {
  const EasySoppingCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 255, 250, 0),
        useMaterial3: true,
      ),
      title: 'ESCalc',
      home: const MainScreen(),
    );
  }
}
