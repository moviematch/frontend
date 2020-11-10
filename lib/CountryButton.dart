import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'LoadIndicator.dart';
import 'colours.dart';
import 'package:openapi/api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'fast_splash_factory.dart';
import 'room_prefs.dart';

class CountryButton extends StatefulWidget {
  final Country country;
  final void Function() change;

  CountryButton({@required this.country, @required this.change});

  @override
  State<StatefulWidget> createState() {
    return _CountryButtonState(country, change);
  }
}

class _CountryButtonState extends State<CountryButton> {
  final Country country;
  final void Function() change;
  bool _selected = false;

  _CountryButtonState(this.country, this.change);

  @override
  void initState() {
    _selected = RoomPrefs.I().getCountryIds().contains(country.id);
    super.initState();
  }

  void invertSelection() {
    setState(() {
      _selected = !_selected;
      List<String> countryIds = RoomPrefs.I().getCountryIds();
      if (_selected) {
        countryIds.add(country.id);
      } else {
        countryIds.remove(country.id);
      }
      RoomPrefs.I().setCountryIds(countryIds);
      change();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(color: _selected ? Colors.green : Colors.transparent),
      Padding(
          padding: EdgeInsets.all(3),
          child:
              Container(color: _selected ? Colors.white : Colors.transparent)),
      IgnorePointer(
          child: Padding(
              padding: EdgeInsets.all(5),
              child: ColorFiltered(
                  colorFilter: _selected
                      ? ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                      : ColorFilter.mode(
                          Grey.withAlpha(230), BlendMode.saturation),
                  child: Center(
                      child: CachedNetworkImage(
                    imageUrl: country.flag,
                    placeholder: (context, url) =>
                        LoadIndicator(colours: [Grey], padding: 0, size: 16),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ))))),
      Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: invertSelection,
            enableFeedback: false,
            splashColor: _selected
                ? Colors.red.withAlpha(180)
                : Colors.green.withAlpha(180),
            splashFactory: FastSplashFactory(),
          )),
    ]);
  }
}
