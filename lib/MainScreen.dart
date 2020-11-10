import 'package:app/room_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';
import 'RoomScaffold.dart';
import 'RecommendationSwiper.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  Room _room;

  Room _currentRoom() {
    if (_room != null) return _room;
    _room = ModalRoute.of(context).settings.arguments;
    return _room;
  }

  void _updateRoom(Room room, bool refreshSettings) {
    setState(() => _room = room);
    if (refreshSettings) {
      RoomPrefs.I().updatePrefsToMatch(room);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RoomScaffold(
        room: _currentRoom,
        updateRoom: _updateRoom,
        body: RecommendationSwiper(
            updateRoom: (Room room) => _updateRoom(room, true)));
  }
}
