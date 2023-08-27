
import 'package:flutter/material.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CompareScreenState();
  }
}

class _CompareScreenState extends State<CompareScreen> {

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Text('Compare Prices screen'),
      ),
    );
  }
}