import 'package:app/LoadIndicator.dart';
import 'package:app/MenuDropdown.dart';
import 'package:app/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';
import 'api.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'MatchCard.dart';

class MatchesDisplay extends StatefulWidget {
  final Room room;

  MatchesDisplay({@required this.room});

  @override
  State<StatefulWidget> createState() {
    return _MatchesDisplayState(room);
  }
}

class _MatchesDisplayState extends State<MatchesDisplay> {
  final Room room;

  bool _wasVisible = false;
  List<Recommendation> _matches;

  _MatchesDisplayState(this.room);

  Widget _matchList() {
    if (_matches.isEmpty) {
      return Padding(
          padding: EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 18),
          child: SizedBox(
              width: double.infinity,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                SvgPicture.asset('assets/shipping-package-drawkit.svg',
                    width: 140),
                SizedBox(height: 30),
                Text('No matches yet... Keep swiping!')
              ])));
    }
    return ListView.separated(
      itemCount: _matches.length + 1,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 12, left: 12, right: 12),
      itemBuilder: (context, index) => index < _matches.length
          ? MatchCard(match: _matches[index])
          : Text('Keep swiping to see more matches here!'),
      separatorBuilder: (context, _) => Divider(color: Colors.black38),
    );
  }

  @override
  Widget build(BuildContext context) {
    // refresh list of matches each time we rebuild and the widget is visible
    MenuDropdown parent = MenuDropdown.of(context);
    if (!_wasVisible && parent.visible) _matches = null;
    _wasVisible = parent.visible;
    if (_matches != null)
      return _matchList();
    else
      return FutureBuilder(
          future: Api.I()
              .ready()
              .then((_) => Api.attempt(Api.I().room.getRoomMatches())),
          builder: (context, future) {
            if (future.connectionState != ConnectionState.done ||
                future.data == null) {
              return SizedBox(
                  height: 108,
                  child: LoadIndicator(colours: [Green, Yellow, Grey]));
            }
            _matches = future.data;
            return _matchList();
          });
  }
}
