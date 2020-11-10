import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'fast_splash_factory.dart';

class Button extends StatelessWidget {
  final String text;
  final void Function() press;
  final Color color;
  final Color textColor;
  final Color splashColor;
  final Widget leading;
  final double size;
  final EdgeInsets padding;

  Button(this.text,
      {@required this.press,
      @required this.color,
      @required this.textColor,
      this.splashColor = Colors.white,
      this.leading,
      this.size = 14,
      this.padding = const EdgeInsets.symmetric(vertical: 5, horizontal: 8)});

  @override
  Widget build(BuildContext context) => Material(
      elevation: 0,
      color: color,
      borderOnForeground: false,
      child: InkWell(
          enableFeedback: false,
          splashFactory: FastSplashFactory(),
          splashColor: splashColor,
          onTap: press,
          child: Padding(
              padding: padding,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                leading ?? SizedBox(width: 0),
                SizedBox(width: leading != null ? 4 : 0),
                Text(text, style: TextStyle(color: textColor, fontSize: size))
              ]))));
}
