import 'package:app/colours.dart';
import 'package:app/fast_splash_factory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';
import 'room_prefs.dart';

class GenreButton extends StatelessWidget {
  final Genre genre;
  final void Function() update;

  GenreButton({@required this.genre, @required this.update});

  @override
  Widget build(BuildContext context) {
    bool isSelected = RoomPrefs.I().getGenreIds().contains(genre.id);
    return Padding(
        padding: EdgeInsets.only(top: 2, bottom: 2),
        child: Material(
          color: isSelected ? Colors.lightGreen : Grey,
          child: InkWell(
            splashFactory: FastSplashFactory(),
            enableFeedback: false,
            splashColor: isSelected ? Colors.red : Colors.green,
            onTap: () {
              List<String> ids = RoomPrefs.I().getGenreIds();
              if (isSelected) {
                ids.remove(genre.id);
              } else {
                ids.add(genre.id);
              }
              RoomPrefs.I().setGenreIds([
                ...{...ids}
              ]);
              update();
            },
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                child: Row(children: [
                  Icon(isSelected ? Icons.done : Icons.add, size: 20),
                  SizedBox(width: 7),
                  Flexible(child: Text(genre.name)),
                ])),
          ),
        ));
  }
}
