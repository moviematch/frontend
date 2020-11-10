import 'package:openapi/api.dart';
import 'api.dart';

class CountryCache {
  static List<Country> loadedCountries;

  static Future<List<Country>> loadCountries() {
    return Api.attempt(Api.I()
            .ready()
            .then((_) => Api.attempt(Api.I().countries.getCountries())))
        .then((countries) {
      loadedCountries = countries;
      return countries;
    });
  }
}
