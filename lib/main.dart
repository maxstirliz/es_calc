import 'package:es_calc/ui/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: EasySoppingCalculator()));
}

class EasySoppingCalculator extends StatelessWidget {
  const EasySoppingCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 106, 186, 243),
        useMaterial3: false,
      ),
      title: 'ESCalc',
      home: const MainScreen(),
    );
  }
}
