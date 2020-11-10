import 'package:app/fast_splash_factory.dart';
import 'package:flutter/material.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

class EllipseButton extends StatelessWidget {
  final IconData icon;
  final void Function() press;
  final Color iconColor;
  final Color splashColor;
  final double size;

  EllipseButton(
      {this.icon = Icons.favorite,
      this.press,
      this.iconColor = Colors.green,
      this.splashColor = Colors.greenAccent,
      this.size = 56});

  @override
  Widget build(BuildContext context) => Material(
      elevation: 20,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: SuperellipseShape(
          borderRadius: BorderRadius.circular(double.infinity)),
      child: InkWell(
          splashFactory: FastSplashFactory(),
          splashColor: splashColor,
          onTap: press,
          child: Padding(
              padding: EdgeInsets.all(8),
              child: Icon(icon, size: size - 16, color: iconColor))));
}
