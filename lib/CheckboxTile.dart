import 'package:app/colours.dart';
import 'package:app/fast_splash_factory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckboxTile extends StatelessWidget {
  final String title;
  final bool value;
  final void Function(bool value) onChanged;

  CheckboxTile(
      {@required this.title, @required this.value, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            splashFactory: FastSplashFactory(),
            enableFeedback: false,
            splashColor: value ? Colors.red : Colors.green,
            onTap: () => onChanged(!value),
            child: Row(children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: Green,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Text(title,
                  style: TextStyle(
                      fontWeight: value ? FontWeight.bold : FontWeight.normal))
            ])));
  }
}
