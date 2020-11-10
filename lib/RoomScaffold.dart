import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';
import 'RoomBar.dart';
import 'MenuDropdown.dart';
import 'MembersDisplay.dart';
import 'MatchesDisplay.dart';
import 'SettingsDisplay.dart';
import 'package:expandable/expandable.dart';

class RoomScaffold extends StatefulWidget {
  final Room Function() room;
  final Widget body;
  final void Function(Room room, bool refreshSettings) updateRoom;

  RoomScaffold(
      {@required this.room, @required this.body, @required this.updateRoom});

  @override
  State<StatefulWidget> createState() {
    return _RoomScaffoldState(room, body, updateRoom);
  }
}

class _RoomScaffoldState extends State<RoomScaffold> {
  final Room Function() room;
  final Widget body;
  final void Function(Room room, bool refreshSettings) updateRoom;

  double _appBarTopOffset;
  ExpandableController _displayMembers;
  ExpandableController _displayMatches;
  ExpandableController _displaySettings;

  _RoomScaffoldState(this.room, this.body, this.updateRoom);

  @override
  void initState() {
    super.initState();
    _displayMembers = ExpandableController();
    _displayMatches = ExpandableController();
    _displaySettings = ExpandableController();
  }

  /// Whether at least one overlay is displayed
  bool get isOverlayDisplayed =>
      _displayMembers.expanded ||
      _displayMatches.expanded ||
      _displaySettings.expanded;

  /// Close all overlays
  void closeOverlays() => setState(() {
        _displayMembers.expanded =
            _displayMatches.expanded = _displaySettings.expanded = false;
      });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          appBar: RoomBar(
            room: room,
            displayMembers: (double top) => setState(() {
              _appBarTopOffset = top;
              _displayMembers.expanded = !_displayMembers.expanded;
              _displayMatches.expanded = _displaySettings.expanded = false;
            }),
            displayMatches: (double top) => setState(() {
              _appBarTopOffset = top;
              _displayMatches.expanded = !_displayMatches.expanded;
              _displayMembers.expanded = _displaySettings.expanded = false;
            }),
            displaySettings: (double top) => setState(() {
              _appBarTopOffset = top;
              _displaySettings.expanded = !_displaySettings.expanded;
              _displayMembers.expanded = _displayMatches.expanded = false;
            }),
          ),
          body: Stack(children: [
            // Actual scaffold body
            body,
            // Overlay backdrop
            IgnorePointer(
                ignoring: !isOverlayDisplayed,
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    color: isOverlayDisplayed
                        ? Colors.black.withAlpha(80)
                        : Colors.transparent,
                    child: GestureDetector(
                      onTap: () => closeOverlays(),
                      onVerticalDragEnd: (details) =>
                          details.primaryVelocity < -100
                              ? closeOverlays()
                              : null,
                    )))
          ])),
      // Overlays
      MenuDropdown(
          top: _appBarTopOffset,
          expandableController: _displayMembers,
          close: closeOverlays,
          child: MembersDisplay(room: room())),
      MenuDropdown(
          top: _appBarTopOffset,
          expandableController: _displayMatches,
          close: closeOverlays,
          child: MatchesDisplay(room: room())),
      MenuDropdown(
          top: _appBarTopOffset,
          expandableController: _displaySettings,
          close: closeOverlays,
          child: SettingsDisplay(room: room(), updateRoom: updateRoom))
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _displayMembers.dispose();
    _displayMatches.dispose();
    _displaySettings.dispose();
  }
}
