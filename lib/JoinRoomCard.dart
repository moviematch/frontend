import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MenuButton.dart';
import 'BackArrow.dart';
import 'CountrySelector.dart';
import 'api.dart';
import 'room_prefs.dart';
import 'package:overlay_screen/overlay_screen.dart';
import 'RoomCodeInput.dart';

class JoinRoomCard extends StatefulWidget {
  final void Function() back;
  JoinRoomCard({@required this.back});
  @override
  State<StatefulWidget> createState() {
    return _JoinRoomCardState(back);
  }
}

class _JoinRoomCardState extends State<JoinRoomCard> {
  final void Function() back;
  String _code;

  _JoinRoomCardState(this.back);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [BackArrow(back: back)]),
      RoomCodeInput(
        update: (String code) => setState(() => _code = code),
      ),
      CountrySelector(),
      Builder(
        builder: (context) {
          if (_code == null) {
            return Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text('Please enter a room code.',
                    style: TextStyle(color: Colors.red)));
          } else {
            return MenuButton('Join with code ' + _code, press: () {
              OverlayScreen().show(context, identifier: 'loading');
              Api.I()
                  .ready()
                  .then((_) => Api.attempt(Api.I().room.joinRoom(_code,
                      country: RoomPrefs.I().getCountriesFromIds())))
                  .then((dynamic room) {
                OverlayScreen().pop();
                if (room == null) {
                  // @todo: show better error feedback here
                  back();
                } else {
                  RoomPrefs.I().updatePrefsToMatch(room);
                  Navigator.of(context).pushNamed('/swipe', arguments: room);
                }
              });
            });
          }
        },
      )
    ]);
  }
}
