import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RatingDisplay extends StatelessWidget {
  final int score;
  final String type;
  final double height;
  final EdgeInsets margin;

  RatingDisplay.tmdb(
      {@required this.score, this.height = 14, this.margin = EdgeInsets.zero})
      : type = 'tmdb';

  @override
  Widget build(BuildContext context) {
    if (score == null || score == 0) return SizedBox(width: 0, height: 0);
    return Padding(
        padding: margin,
        child: Builder(builder: (context) {
          switch (type) {
            case 'tmdb':
              return Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 0.1 * height, horizontal: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99999),
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(30, 213, 169, 1.0),
                        Color.fromRGBO(1, 180, 228, 1.0),
                      ])),
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 0.8 * height,
                              color: Color.fromRGBO(3, 37, 65, 1.0)),
                          children: [
                        TextSpan(
                            text: score.toString() + '%',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' on TMDb'),
                      ])));
          }
          throw UnimplementedError();
        }));
  }
}
