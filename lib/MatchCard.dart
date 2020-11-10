import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:openapi/api.dart';
import 'RatingDisplay.dart';
import 'api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Button.dart';
import 'helpers.dart' as helpers;

class MatchCard extends StatelessWidget {
  final Recommendation match;

  MatchCard({@required this.match});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            height: 64,
            width: 48,
            child:
                CachedNetworkImage(imageUrl: match.cover, fit: BoxFit.cover)),
        SizedBox(width: 8),
        Flexible(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RichText(
              text: TextSpan(style: TextStyle(color: Colors.black), children: [
            TextSpan(
                text: match.title,
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' (' + match.releaseYear.toString() + ')')
          ])),
          SizedBox(height: 2),
          Row(children: [
            RatingDisplay.tmdb(
                score: match.tmdbRating,
                margin: EdgeInsets.only(right: 6),
                height: 14),
            Text(match.type == RecommendationTypeEnum.series_
                ? 'TV Show'
                : 'Film ' + helpers.runtimeDisplay(match.runtime))
          ]),
          SizedBox(height: 4),
          Row(children: [
            Button('Watch on Netflix',
                color: Color.fromRGBO(229, 9, 20, 1.0),
                textColor: Colors.white,
                leading: SvgPicture.asset('assets/netflix.svg',
                    height: 14, color: Colors.white),
                press: () => Api.attempt(launch(match.netflixLink))),
            SizedBox(width: 8),
            Button('Copy link',
                color: Colors.transparent,
                textColor: Colors.black54,
                leading: Icon(Icons.copy, size: 14, color: Colors.black54),
                press: () => Api.attempt(
                    FlutterClipboard.copy(match.netflixLink).then((_) =>
                        Fluttertoast.showToast(
                            msg: "Copied link to clipboard!",
                            backgroundColor: Colors.black45))))
          ]),
        ])),
      ],
    );
  }
}
