import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colours.dart';

class MenuButton extends StatelessWidget {
  final String text;
  final void Function() press;

  MenuButton(this.text, {this.press});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: SizedBox(
            width: double.infinity,
            child: CupertinoButton(
                child: Text(text),
                onPressed:
                    press ?? () => {print("Pressed button [" + text + "]")},
                color: Green,
                pressedOpacity: 0.8,
                padding: EdgeInsets.only(top: 5, bottom: 5))));
  }
}
