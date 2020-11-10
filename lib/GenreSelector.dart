import 'package:app/LoadIndicator.dart';
import 'package:app/fast_splash_factory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:openapi/api.dart';
import 'room_prefs.dart';
import 'SettingDropdownState.dart';
import 'GenreButton.dart';
import 'api.dart';
import 'colours.dart';
import 'genre_cache.dart';

class GenreSelector extends StatefulWidget {
  final Room room;
  final void Function(Room room, bool refreshSettings) updateRoom;

  GenreSelector({this.room, this.updateRoom});

  @override
  State<StatefulWidget> createState() {
    return _GenreSelectorState(room, updateRoom);
  }
}

class _GenreSelectorState extends SettingDropdownState {
  TextEditingController _editingController;
  String _searchString;
  int _searchId = 0;
  bool _loadingSearch = false;
  List<Genre> _suggestions = [];

  _GenreSelectorState(
      Room room, void Function(Room room, bool refreshSettings) updateRoom)
      : super(room, updateRoom);

  @override
  void setupModifications(
      Room currentRoom,
      void Function(Room modificationsOnly) finish,
      void Function(Room updatedRoom) fullRoomUpdate) {
    GenreCache.loadGenres(RoomPrefs.I().getGenreIds()).then((genres) {
      currentRoom.genres = genres;
      fullRoomUpdate(currentRoom);
    });
    finish(Room(genres: RoomPrefs.I().getGenresFromIds()));
  }

  @override
  void initState() {
    _editingController = TextEditingController();
    void Function() editingListener = () {
      setState(() => _loadingSearch = true);
      ++_searchId;
      var currentSearchId = _searchId;
      var _text = _editingController.text;
      if (_text.length < 2) _text = "";
      Future.delayed(Duration(milliseconds: _text.length == 0 ? 0 : 800))
          .then((_) {
        if (currentSearchId == _searchId) {
          if (_text != _searchString) {
            _searchString = _editingController.text;
            Api.I()
                .ready()
                .then((_) => Api.attempt(
                    Api.I().genres.getGenres(keyword: _searchString, limit: 5)))
                .then((genres) {
              if (genres == null) {
                genres = [];
              }
              if (currentSearchId == _searchId) {
                setState(() {
                  _loadingSearch = false;
                  _suggestions = genres;
                });
              }
            });
          } else {
            setState(() => _loadingSearch = false);
          }
        }
      });
    };
    editingListener();
    _editingController.addListener(editingListener);
    super.initState();
  }

  Widget _selectedGenresText() {
    Widget Function(List<Genre> genres) actualWidget = (List<Genre> genres) {
      if (genres.length <= 0) {
        return Text('No genres selected');
      } else {
        String selections = "";
        for (int i = 0; i < genres.length; ++i) {
          if (i > 0) selections += ", ";
          selections += genres[i].name;
        }
        return Text(selections);
      }
    };

    if (GenreCache.isAlreadyLoaded(RoomPrefs.I().getGenreIds())) {
      return actualWidget(GenreCache.alreadyLoaded());
    }

    return FutureBuilder(
        future: GenreCache.loadGenres(RoomPrefs.I().getGenreIds()),
        builder: (context, future) {
          if (future.connectionState != ConnectionState.done) {
            return SizedBox(
                width: 20,
                child: LoadIndicator(
                    colours: [Colors.black], padding: 0, size: 16));
          }
          return actualWidget(future.data ?? []);
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> suggestionCards = [];
    for (Genre g in _suggestions) {
      suggestionCards.add(GenreButton(
          genre: g,
          update: () {
            setState(() {});
            modifyRoom();
          }));
    }
    if (suggestionCards.length <= 0) {
      suggestionCards.add(Text('Nothing corresponds to your search, sorry :('));
    }

    return dropdownContainer(context,
        icon: Icons.extension,
        title: 'Genres',
        subtitleWidget: _selectedGenresText(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Optionally, select a list of genres you\'d like to get results for.'),
            SizedBox(height: 4),
            Row(children: [
              AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: RoomPrefs.I().getGenreIds().length > 0 ? 44 : 0,
                  curve: Curves.easeInOut,
                  child: Material(
                      color: Colors.white,
                      elevation: 2,
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                          splashFactory: FastSplashFactory(),
                          enableFeedback: false,
                          splashColor: Colors.red,
                          onTap: () {
                            RoomPrefs.I().setGenreIds([]);
                            setState(() {});
                            modifyRoom();
                          },
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.delete))))),
              SizedBox(width: 8),
              Flexible(child: _selectedGenresText()),
            ]),
            SizedBox(height: 4),
            Card(
                color: Colors.grey,
                margin: EdgeInsets.only(bottom: 4),
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                child: Padding(
                    padding: EdgeInsets.all(1),
                    child: TextField(
                      controller: _editingController,
                      decoration: InputDecoration(
                          prefixIcon: !_loadingSearch
                              ? Icon(Icons.search)
                              : SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: LoadIndicator(
                                      colours: [Green], padding: 0, size: 24)),
                          labelText: 'Search genres',
                          hintText: 'action, dramas, comedies, ...',
                          contentPadding: EdgeInsets.symmetric(vertical: 2),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: _editingController.text.length <= 0
                              ? null
                              : Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () => _editingController.text = "",
                                      enableFeedback: false,
                                      splashFactory: FastSplashFactory(),
                                      splashColor: Colors.red,
                                      child: Icon(Icons.cancel,
                                          color: Colors.red)))),
                    ))),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: suggestionCards)
          ],
        ));
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }
}
