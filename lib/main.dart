import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'RoomEntry.dart';
import 'MainScreen.dart';
import 'package:overlay_screen/overlay_screen.dart';
import 'LoadIndicator.dart';
import 'package:keyboard_service/keyboard_service.dart';
import 'colours.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  OverlayScreen().saveScreens({
    'loading': CustomOverlayScreen(
        backgroundColor: Colors.transparent, content: LoadIndicator())
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          KeyboardService.dismiss(unfocus: context);
        },
        child: MaterialApp(
            title: "Movie Match",
            theme: ThemeData(primaryColor: Green),
            debugShowCheckedModeBanner: false,
            routes: <String, WidgetBuilder>{
              '/': (BuildContext context) {
                return RoomEntry();
              },
              '/swipe': (BuildContext context) {
                return MainScreen();
              }
            }));
  }
}
