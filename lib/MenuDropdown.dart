import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colours.dart';
import 'package:expandable/expandable.dart';

class MenuDropdown extends StatelessWidget {
  final double top;
  final ExpandableController expandableController;
  final void Function() close;
  final Widget child;

  MenuDropdown(
      {@required this.top,
      @required this.expandableController,
      @required this.close,
      @required this.child});

  static MenuDropdown of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<MenuDropdown>();
  }

  bool get visible {
    return expandableController.expanded;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        right: 0,
        top: top ?? 0,
        child: Material(
            child: Container(
                decoration: BoxDecoration(color: LightGrey, boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 12))
                ]),
                child: ExpandablePanel(
                    controller: expandableController,
                    expanded: GestureDetector(
                        onVerticalDragEnd: (DragEndDetails details) {
                          if (details != null &&
                              details.primaryVelocity < -100) {
                            close();
                          }
                        },
                        child: Container(
                            padding: EdgeInsets.only(bottom: 12),
                            constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height -
                                    (top ?? 0) -
                                    200),
                            child: child))))));
  }
}
