import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';
import 'SettingDropdownState.dart';
import 'room_prefs.dart';
import 'CheckboxTile.dart';

class MediaTypeSelector extends StatefulWidget {
  final Room room;
  final void Function(Room room, bool refreshSettings) updateRoom;

  MediaTypeSelector({this.room, this.updateRoom});

  @override
  State<StatefulWidget> createState() {
    return _MediaTypeSelectorState(room, updateRoom);
  }
}

class _MediaTypeSelectorState extends SettingDropdownState {
  _MediaTypeSelectorState(
      Room room, void Function(Room room, bool refreshSettings) updateRoom)
      : super(room, updateRoom);

  @override
  void setupModifications(
      Room currentRoom,
      void Function(Room modificationsOnly) finish,
      void Function(Room updatedRoom) fullRoomUpdate) {
    currentRoom.showMovies = RoomPrefs.I().getShowMovies();
    currentRoom.showSeries = RoomPrefs.I().getShowSeries();
    finish(Room(
        showMovies: currentRoom.showMovies,
        showSeries: currentRoom.showSeries));
    fullRoomUpdate(currentRoom);
  }

  @override
  Widget build(BuildContext context) {
    RoomPrefs prefs = RoomPrefs.I();
    String selectedTypes = prefs.getShowMovies() == prefs.getShowSeries()
        ? 'Both movies and TV shows'
        : prefs.getShowMovies()
            ? 'Movies only'
            : 'TV shows only';

    return dropdownContainer(context,
        icon: Icons.movie,
        title: 'Media type',
        subtitle: selectedTypes,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select the type of media you\'re looking to watch.'),
            SizedBox(height: 8),
            CheckboxTile(
                title: 'Include movies',
                value: prefs.getShowMovies(),
                onChanged: (value) {
                  prefs.setShowMovies(value);
                  if (!value) prefs.setShowSeries(true);
                  modifyRoom();
                }),
            CheckboxTile(
                title: 'Include TV shows',
                value: prefs.getShowSeries(),
                onChanged: (value) {
                  prefs.setShowSeries(value);
                  if (!value) prefs.setShowMovies(true);
                  modifyRoom();
                }),
          ],
        ));
  }
}
