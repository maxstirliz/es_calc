import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  AnimatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
  });

  final String text;
  TextStyle? style;
  TextAlign? textAlign;

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Text(
        key: ValueKey(widget.text),
        widget.text,
        style: widget.style,
        textAlign: widget.textAlign,
      ),
    );
  }
}
