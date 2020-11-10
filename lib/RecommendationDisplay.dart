import 'package:app/LoadIndicator.dart';
import 'package:app/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';
import 'RatingDisplay.dart';
import 'helpers.dart' as helpers;
import 'SwipeOverlay.dart';
import 'EllipseButton.dart';

class RecommendationDisplay extends StatelessWidget {
  final Recommendation recommendation;
  final double swipePos;
  final void Function(bool left) swipe;

  RecommendationDisplay(
      {@required this.recommendation, this.swipePos = 0, this.swipe});

  Widget _cast(String role, String prefix) {
    List<String> names = [];
    for (CastMember member in recommendation.cast) {
      if (member.role == role) {
        names.add(member.name);
      }
    }
    if (names.length <= 0) return SizedBox(height: 0);
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(
          prefix + ' ' + helpers.naturalJoin(names),
        ));
  }

  @override
  Widget build(BuildContext context) => Stack(children: [
        LayoutBuilder(
            builder: (context, constraints) => Stack(children: [
                  ListView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 12.0 + 70.0),
                      children: [
                        SizedBox(
                            height: constraints.maxHeight * 0.45,
                            width: constraints.maxWidth,
                            child: Stack(children: [
                              Container(
                                  color: Colors.grey, child: LoadIndicator()),
                              SizedBox.expand(
                                  child: Image.network(recommendation.cover,
                                      fit: BoxFit.cover))
                            ])),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 24),
                                    children: [
                                  TextSpan(
                                    text: recommendation.title,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                      text: ' (' +
                                          recommendation.releaseYear
                                              .toString() +
                                          ')'),
                                ]))),
                        Padding(
                            padding:
                                EdgeInsets.only(bottom: 4, left: 8, right: 8),
                            child: Row(children: [
                              RatingDisplay.tmdb(
                                  score: recommendation.tmdbRating,
                                  margin: EdgeInsets.only(right: 6),
                                  height: 16),
                              Text(
                                  recommendation.type ==
                                          RecommendationTypeEnum.series_
                                      ? 'TV Show'
                                      : 'Film ' +
                                          helpers.runtimeDisplay(
                                              recommendation.runtime),
                                  style: TextStyle(fontSize: 16))
                            ])),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Text(recommendation.description,
                                style: TextStyle(fontSize: 16))),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Divider(color: Colors.black45)),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Text(helpers.naturalJoin(recommendation
                                .genres
                                .map((genre) => genre.name)
                                .toList()))),
                        _cast('creator', 'By'),
                        _cast('actor', 'With'),
                      ]),
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 70,
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Colors.white.withAlpha(0),
                                Colors.white.withAlpha(200),
                                Colors.white
                              ])),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                EllipseButton(
                                  icon: Icons.clear,
                                  splashColor: Colors.redAccent,
                                  iconColor: Colors.red,
                                  press: () => swipe != null
                                      ? swipe(true)
                                      : print('trigger left swipe'),
                                ),
                                SizedBox(width: 12),
                                EllipseButton(
                                  icon: Icons.favorite,
                                  splashColor: Colors.lightGreen,
                                  iconColor: Green,
                                  press: () => swipe != null
                                      ? swipe(false)
                                      : print('trigger right swipe'),
                                )
                              ])))
                ])),
        SwipeOverlay(swipePos),
      ]);
}
