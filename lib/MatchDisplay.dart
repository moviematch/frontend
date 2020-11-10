import 'package:app/Button.dart';
import 'package:app/LoadIndicator.dart';
import 'package:app/colours.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';
import 'api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:confetti/confetti.dart';

class MatchDisplay extends StatefulWidget {
  final Recommendation match;
  final void Function(bool left) swipe;

  MatchDisplay({@required this.match, this.swipe});

  @override
  State<StatefulWidget> createState() => _MatchDisplayState(match, swipe);
}

class _MatchDisplayState extends State<MatchDisplay> {
  final Recommendation match;
  final void Function(bool left) swipe;

  ConfettiController _confettiController;

  _MatchDisplayState(this.match, this.swipe);

  @override
  void initState() {
    _confettiController = ConfettiController(duration: Duration(seconds: 1));
    _confettiController.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SizedBox.expand(
          child: Stack(fit: StackFit.expand, children: [
        Container(
            color: Colors.black87,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Text('It\'s a match!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 30))),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('Everyone in the room voted for',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white))),
              Padding(
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
                  child: Text(match.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold))),
              SizedBox(
                  width: double.infinity,
                  height: 160,
                  child: Stack(fit: StackFit.expand, children: [
                    Container(
                        color: Colors.black87,
                        child: LoadIndicator(
                            colours: [Colors.white.withAlpha(200)])),
                    Image.network(match.cover, fit: BoxFit.cover),
                  ])),
              Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button('Watch on Netflix',
                            color: Color.fromRGBO(229, 9, 20, 1.0),
                            textColor: Colors.white,
                            size: 18,
                            leading: SvgPicture.asset('assets/netflix.svg',
                                height: 18, color: Colors.white),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            press: () =>
                                Api.attempt(launch(match.netflixLink))),
                        SizedBox(width: 8),
                        Button('Copy link',
                            color: Colors.white.withAlpha(100),
                            splashColor: Color.fromRGBO(229, 9, 20, 1.0),
                            textColor: Colors.black54,
                            size: 18,
                            leading: Icon(Icons.copy,
                                size: 18, color: Colors.black54),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            press: () => Api.attempt(
                                FlutterClipboard.copy(match.netflixLink).then(
                                    (_) => Fluttertoast.showToast(
                                        msg: "Copied link to clipboard!",
                                        backgroundColor: Colors.black45))))
                      ])),
              Padding(
                  padding: EdgeInsets.all(8),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                                text:
                                    'Watch now or keep swiping. Your matches remain available by tapping the fire '),
                            WidgetSpan(
                                child: Icon(Icons.local_fire_department,
                                    size: 16, color: Colors.white)),
                            TextSpan(text: ' icon at the top of the screen.')
                          ]))),
              Button('Continue',
                  press: () => swipe(false),
                  padding: EdgeInsets.all(12),
                  color: Colors.transparent,
                  textColor: Colors.white,
                  splashColor: Green,
                  leading: Icon(Icons.arrow_right_alt,
                      size: 14, color: Colors.white)),
            ])),
        Center(
            child: ConfettiWidget(
          confettiController: _confettiController,
          numberOfParticles: 25,
          maxBlastForce: 50,
          minimumSize: Size(10, 5),
          maximumSize: Size(20, 10),
          blastDirectionality: BlastDirectionality.explosive,
        )),
      ]));

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
}
