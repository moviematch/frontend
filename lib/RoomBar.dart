import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'BackArrow.dart';
import 'package:overlay_screen/overlay_screen.dart';
import 'api.dart';
import 'colours.dart';
import 'package:openapi/api.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'fast_splash_factory.dart';
import 'queue_driver.dart';

class RoomBar extends StatelessWidget with PreferredSizeWidget {
  final Room Function() room;
  final void Function(double top) displayMembers;
  final void Function(double top) displayMatches;
  final void Function(double top) displaySettings;

  RoomBar(
      {@required this.room,
      @required this.displayMembers,
      @required this.displayMatches,
      @required this.displaySettings});

  @override
  Size get preferredSize => Size(0, 48);

  Widget _button(BuildContext context,
      {@required Widget child, @required void Function() onTap, Color color}) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            enableFeedback: false,
            splashColor: color ?? Green,
            splashFactory: FastSplashFactory(),
            onTap: onTap,
            child: Container(padding: EdgeInsets.all(4), child: child)));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Container(
            decoration: BoxDecoration(color: LightGrey, boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 10, offset: Offset(0, 12)),
            ]),
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(8),
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  BackArrow(
                      label: 'Leave',
                      back: () {
                        OverlayScreen().show(context, identifier: 'loading');
                        Api.I()
                            .ready()
                            .then((_) => Api.attempt(Api.I().room.leaveRoom()))
                            .then((_) {
                          OverlayScreen().pop();
                          QueueDriver().reset();
                          Navigator.of(context).pop();
                        });
                      }),
                  Container(height: 32, width: 1, color: Colors.black12),
                  Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 4, 8),
                      child: Text('Room code:',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  GestureDetector(
                      onTap: () {
                        try {
                          FlutterClipboard.copy(room().code).then((_) =>
                              Fluttertoast.showToast(
                                  msg: "Copied room code to clipboard!",
                                  backgroundColor: Colors.black45));
                        } catch (e) {}
                      },
                      child: Container(
                          height: 32,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Yellow,
                              borderRadius: BorderRadius.circular(16)),
                          child: Text(room().code,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)))),
                  SizedBox(width: 8),
                  Container(height: 32, width: 1, color: Colors.black12),
                  SizedBox(width: 5),
                  _button(context,
                      onTap: () =>
                          displayMembers(Scaffold.of(context).appBarMaxHeight),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.people),
                            SizedBox(width: 2),
                            Text(room().users.length.toString())
                          ])),
                  SizedBox(width: 5),
                  _button(context,
                      onTap: () =>
                          displayMatches(Scaffold.of(context).appBarMaxHeight),
                      color: Colors.red,
                      child: Icon(Icons.local_fire_department)),
                  SizedBox(width: 5),
                  _button(context,
                      onTap: () =>
                          displaySettings(Scaffold.of(context).appBarMaxHeight),
                      child: Icon(Icons.settings)),
                ])
              ],
            )));
  }
}
