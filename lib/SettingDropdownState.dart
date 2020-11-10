import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'LoadIndicator.dart';
import 'package:openapi/api.dart';
import 'package:expandable/expandable.dart';
import 'api.dart';

abstract class SettingDropdownState extends State<StatefulWidget> {
  final Room room;
  final void Function(Room room, bool refreshSettings) updateRoom;

  ExpandableController _expandableController;

  bool _loading = false;
  int _triggeredLoadings = 0;

  SettingDropdownState(this.room, this.updateRoom);

  /// Should call fullRoomUpdate with the input currentRoom with modifications applied to be able
  /// to display the updates immediately or ASAP. Should call input function finish with
  /// a Room object containing _only_ the new changes.
  void setupModifications(
      Room currentRoom,
      void Function(Room modificationsOnly) finish,
      void Function(Room updatedRoom) fullRoomUpdate);

  void modifyRoom() {
    if (room == null) {
      setState(() {});
    } else {
      setState(() => _loading = true);
      ++_triggeredLoadings;
      setupModifications(
          room,
          (Room modificationsOnly) => Api.I()
                  .ready()
                  .then((_) => Api.attempt(
                      Api.I().room.updateRoom(room: modificationsOnly)))
                  .then((_) {
                --_triggeredLoadings;
                if (_triggeredLoadings <= 0) {
                  setState(() => _loading = false);
                }
              }), (Room updatedRoom) {
        if (updateRoom != null) {
          updateRoom(updatedRoom, false);
        }
      });
    }
  }

  @override
  void initState() {
    _expandableController = ExpandableController();
    super.initState();
  }

  Widget dropdownContainer(BuildContext context,
      {@required IconData icon,
      @required String title,
      String subtitle,
      Widget subtitleWidget,
      @required Widget child}) {
    return Column(children: [
      ExpandablePanel(
          controller: _expandableController,
          header: Padding(
              padding: EdgeInsets.only(top: 9),
              child: Row(children: [
                _loading
                    ? LoadIndicator(
                        colours: [Colors.black], padding: 3, size: 18)
                    : Icon(icon, size: 24),
                SizedBox(width: 8),
                Text(title, style: TextStyle(fontWeight: FontWeight.bold))
              ])),
          collapsed: GestureDetector(
              onTap: () => _expandableController.expanded = true,
              child: SizedBox(
                  width: double.infinity,
                  child: subtitleWidget ?? Text(subtitle))),
          expanded: child),
      Divider(color: Colors.black54)
    ]);
  }

  @override
  void dispose() {
    _expandableController.dispose();
    super.dispose();
  }
}
