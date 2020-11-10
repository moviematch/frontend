import 'dart:io';
import 'dart:math';
import 'package:openapi/api.dart';
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static Api _instance;

  ApiClient api;
  AnnouncementsApi announcements;
  CountriesApi countries;
  GenresApi genres;
  QueueApi queue;
  RoomApi room;
  String token;
  SharedPreferences sharedPreferences;

  static Api I() {
    if (_instance == null) _instance = Api();
    return _instance;
  }

  Api() {
    api = defaultApiClient;
    announcements = AnnouncementsApi();
    countries = CountriesApi();
    genres = GenresApi();
    queue = QueueApi();
    room = RoomApi();
  }

  Future<String> ready() async {
    if (token != null) return token;
    sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('unique_token');
    if (token == null) {
      DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
      try {
        if (Platform.isAndroid) {
          var build = await deviceInfoPlugin.androidInfo;
          token = 'Andrd-' + build.androidId;
        } else {
          var data = await deviceInfoPlugin.iosInfo;
          token = 'Ios-' + data.identifierForVendor;
        }
      } catch (e) {
        token = 'unknown-device';
      }
      Random rnd = Random();
      var chars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      token += ':' +
          String.fromCharCodes(Iterable.generate(
              16, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
      sharedPreferences.setString('unique_token', token);
    }
    api.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(token);
    api.addDefaultHeader('Host', 'jonathan-kings.com');
    print("Unique token: " + token);
    return token;
  }

  static Future<dynamic> attempt(Future<dynamic> future) async {
    try {
      return await future;
    } catch (e) {
      return null;
    }
  }
}
