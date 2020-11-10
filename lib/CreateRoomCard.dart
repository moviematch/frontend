import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MenuButton.dart';
import 'BackArrow.dart';
import 'CountrySelector.dart';
import 'GenreSelector.dart';
import 'api.dart';
import 'room_prefs.dart';
import 'package:overlay_screen/overlay_screen.dart';
import 'MediaTypeSelector.dart';

class CreateRoomCard extends StatefulWidget {
  final void Function() back;
  CreateRoomCard({@required this.back});
  @override
  State<StatefulWidget> createState() {
    return _CreateRoomCardState(back);
  }
}

class _CreateRoomCardState extends State<CreateRoomCard> {
  void Function() back;
  _CreateRoomCardState(this.back);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [BackArrow(back: back)]),
        MediaTypeSelector(),
        CountrySelector(),
        GenreSelector(),
        MenuButton('Create room', press: () {
          OverlayScreen().show(context, identifier: 'loading');
          Api.I()
              .ready()
              .then((_) => Api.attempt(Api.I()
                  .room
                  .createRoom(room: RoomPrefs.I().roomFromSettings())))
              .then((room) {
            OverlayScreen().pop();
            if (room == null)
              // @todo: better error feedback when failing to create room?
              back();
            else {
              RoomPrefs.I().updatePrefsToMatch(room);
              Navigator.of(context).pushNamed('/swipe', arguments: room);
            }
          });
        })
      ],
    );
  }
}
