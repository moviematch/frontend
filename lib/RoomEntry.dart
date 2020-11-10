import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'package:openapi/api.dart';
import 'WelcomeCard.dart';
import 'CreateRoomCard.dart';
import 'LoadIndicator.dart';
import 'colours.dart';
import 'JoinRoomCard.dart';
import 'room_prefs.dart';

class RoomEntry extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RoomEntryState();
  }
}

class _RoomEntryState extends State<RoomEntry> {
  bool _loading = true;
  bool _showCreateScreen = false;
  bool _showJoinScreen = false;

  @override
  void initState() {
    super.initState();
    Api.I().ready().then((_) async {
      print('API ready.');
      Room room = await Api.attempt(Api.I().room.getRoom());
      if (room != null) {
        RoomPrefs.I().updatePrefsToMatch(room);
        Navigator.of(context)
            .pushNamed('/swipe', arguments: room)
            .then((_) => setState(() => _loading = false));
      } else {
        setState(() => _loading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                color: Grey,
                image: DecorationImage(
                    image:
                        AssetImage("assets/unsplash-georgia-vagim-popcorn.jpg"),
                    fit: BoxFit.cover)),
            child:
                SafeArea(child: LayoutBuilder(builder: (context, constraints) {
              if (_loading) {
                return LoadIndicator();
              }
              return ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Container(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Center(
                          child: Padding(
                              padding: EdgeInsets.all(30.0),
                              child: Card(
                                  elevation: 15,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Builder(builder: (context) {
                                        if (_showCreateScreen) {
                                          return CreateRoomCard(
                                              back: () => setState(() =>
                                                  _showCreateScreen = false));
                                        } else if (_showJoinScreen) {
                                          return JoinRoomCard(
                                              back: () => setState(() =>
                                                  _showJoinScreen = false));
                                        } else {
                                          return WelcomeCard(
                                              createRoom: () => setState(() =>
                                                  _showCreateScreen = true),
                                              joinRoom: () => setState(() =>
                                                  _showJoinScreen = true));
                                        }
                                      })))))),
                ],
              );
            }))));
  }
}
