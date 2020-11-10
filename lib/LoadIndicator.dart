import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_color/rainbow_color.dart';

class LoadIndicator extends StatefulWidget {
  final List<Color> colours;
  final double size;
  final double padding;

  LoadIndicator({this.colours, this.size = 48, this.padding = 8});

  @override
  State<StatefulWidget> createState() {
    return _LoadIndicatorState(colours, size, padding);
  }
}

class _LoadIndicatorState extends State<LoadIndicator>
    with SingleTickerProviderStateMixin<LoadIndicator> {
  List<Color> colours;
  final double size;
  final double padding;

  _LoadIndicatorState(this.colours, this.size, this.padding) {
    if (colours == null || colours.length < 1) {
      colours = [Colors.white];
    }
  }

  AnimationController _animationController;
  Animation<Color> _colorTween;
  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    List<Color> _colours = List<Color>.from(colours);
    _colours.add(_colours.first);
    _colorTween = _animationController.drive(RainbowColorTween(_colours));
    _animationController.repeat(
        reverse: false, period: Duration(seconds: colours.length));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: EdgeInsets.all(padding),
          child: SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                valueColor: _colorTween,
                strokeWidth: 2.0,
              ))),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
