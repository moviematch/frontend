import 'package:app/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:openapi/api.dart';
import 'RecommendationDisplay.dart';
import 'MatchDisplay.dart';
import 'Button.dart';

class QueueItemCard extends StatelessWidget {
  final QueueItem item;
  final double swipePos;
  final void Function(bool left) swipe;

  QueueItemCard({@required this.item, this.swipePos = 0, this.swipe});

  @override
  Widget build(BuildContext context) {
    if (item.match != null) {
      return MatchDisplay(match: item.match, swipe: swipe);
    } else if (item.recommendation != null) {
      return RecommendationDisplay(
          recommendation: item.recommendation,
          swipePos: swipePos,
          swipe: swipe);
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/shipping-package-drawkit.svg', width: 200),
          Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                'Nothing more to show... You can try relaxing the room filters a bit :)',
                textAlign: TextAlign.center,
              )),
          Button('Refresh',
              press: () => swipe(true),
              splashColor: Green,
              color: Colors.white,
              textColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: Icon(Icons.autorenew, size: 14)),
        ],
      );
    }
  }
}
