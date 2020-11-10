import 'package:flutter/material.dart';
import 'dart:math';

class SwipeOverlay extends StatelessWidget {
  final double swipePos;

  SwipeOverlay(this.swipePos);

  @override
  Widget build(BuildContext context) {
    Color background = Colors.lightGreen;
    if (swipePos < 0) background = Colors.red;
    int alpha = min(swipePos.abs() * 5, 160).floor();
    background = background.withAlpha(alpha);

    return IgnorePointer(
        child: SizedBox.expand(
            child: Container(
                color: background,
                child: Center(
                  child: Icon(swipePos > 0 ? Icons.favorite : Icons.clear,
                      color: Colors.white.withAlpha(alpha), size: 200),
                ))));
  }
}
