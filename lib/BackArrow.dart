import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'fast_splash_factory.dart';

class BackArrow extends StatelessWidget {
  final void Function() back;
  final String label;
  BackArrow({@required this.back, this.label = 'Back'});
  @override
  Widget build(BuildContext context) {
    Future<bool> Function() typedBack = () async {
      back();
      return false;
    };
    return WillPopScope(
        onWillPop: typedBack,
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: back,
              enableFeedback: false,
              splashColor: Colors.black12,
              splashFactory: FastSplashFactory(),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
                  child: Row(children: [
                    Icon(Icons.arrow_back_ios, size: 20.0),
                    Text(label)
                  ])),
            )));
  }
}
