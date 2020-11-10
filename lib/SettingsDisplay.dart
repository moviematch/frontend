import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';
import 'CountrySelector.dart';
import 'GenreSelector.dart';
import 'MediaTypeSelector.dart';
import 'api.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsDisplay extends StatelessWidget {
  final Room room;
  final void Function(Room room, bool refreshSettings) updateRoom;

  SettingsDisplay({@required this.room, @required this.updateRoom});

  TextSpan _link(String text, {@required String href}) {
    return TextSpan(
        text: text,
        style: TextStyle(color: Colors.blue),
        recognizer: TapGestureRecognizer()
          ..onTap = () => Api.attempt(launch(href)));
  }

  TextSpan _span(String text) {
    return TextSpan(text: text);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 12, left: 12, right: 12),
      children: [
        MediaTypeSelector(room: room, updateRoom: updateRoom),
        CountrySelector(room: room, updateRoom: updateRoom),
        GenreSelector(room: room, updateRoom: updateRoom),
        SizedBox(height: 8),
        RichText(
            textScaleFactor: 0.9,
            text: TextSpan(style: TextStyle(color: Colors.black), children: [
              _span('Made with '),
              WidgetSpan(child: Icon(Icons.favorite, size: 16)),
              _span(' by '),
              _link('Jonathan Kings', href: 'https://jonathan-kings.com/'),
              _span('.\n'),
              _span('Movie Match relies on the '),
              _link('TMDb', href: 'https://www.themoviedb.org/'),
              _span(' and '),
              _link('uNoGS', href: 'https://unogs.com/'),
              _span(' APIs.\n'),
              _span('Robot images delivered by '),
              _link('Robohash.org', href: 'https://robohash.org/'),
              _span('.\n'),
              _span(
                  'Movie Match is not affiliated with or endorsed by Netflix.\n'),
              _span('Send me your feedback at '),
              _link('istaakestudio@gmail.com',
                  href:
                      'mailto:istaakestudio@gmail.com?subject=Movie%20Match%20Feedback'),
              _span(' :)')
            ])),
      ],
    );
  }
}
