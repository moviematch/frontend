import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';
import 'package:openapi/api.dart';

class RoomPrefs {
  final String _showMoviesKey = 'room_prefs/show_movies';
  final String _showSeriesKey = 'room_prefs/show_series';
  final String _genreIdsKey = 'room_prefs/genre_ids';
  final String _countryIdsKey = 'room_prefs/country_ids';

  static RoomPrefs _instance;
  bool _showMovies = true;
  bool _showSeries = false;
  List<String> _genreIds = [];
  List<String> _countryIds = [];
  static RoomPrefs I() {
    if (_instance == null) {
      _instance = RoomPrefs();
    }
    return _instance;
  }

  RoomPrefs() {
    SharedPreferences prefs = Api.I().sharedPreferences;
    if (prefs.containsKey(_showMoviesKey)) {
      _showMovies = prefs.getBool(_showMoviesKey);
    }
    if (prefs.containsKey(_showSeriesKey)) {
      _showSeries = prefs.getBool(_showSeriesKey);
    }
    if (prefs.containsKey(_genreIdsKey)) {
      _genreIds = prefs.getStringList(_genreIdsKey);
    }
    if (prefs.containsKey(_countryIdsKey)) {
      _countryIds = prefs.getStringList(_countryIdsKey);
    }
  }

  bool getShowMovies() => _showMovies;

  void setShowMovies(bool showMovies) {
    _showMovies = showMovies;
    Api.I().sharedPreferences.setBool(_showMoviesKey, _showMovies);
  }

  bool getShowSeries() => _showSeries;

  void setShowSeries(bool showSeries) {
    _showSeries = showSeries;
    Api.I().sharedPreferences.setBool(_showSeriesKey, _showSeries);
  }

  List<String> getGenreIds() => _genreIds;

  List<Genre> getGenresFromIds() {
    List<Genre> genres = [];
    for (String id in _genreIds) {
      genres.add(Genre(id: id));
    }
    return genres;
  }

  void setGenreIds(List<String> ids) {
    _genreIds = ids;
    Api.I().sharedPreferences.setStringList(_genreIdsKey, _genreIds);
  }

  List<String> getCountryIds() => _countryIds;

  List<Country> getCountriesFromIds() {
    List<Country> countries = [];
    for (String id in _countryIds) {
      countries.add(Country(id: id));
    }
    return countries;
  }

  void setCountryIds(List<String> ids) {
    _countryIds = ids;
    Api.I().sharedPreferences.setStringList(_countryIdsKey, _countryIds);
  }

  Room roomFromSettings() {
    return Room(
        showMovies: _showMovies,
        showSeries: _showSeries,
        genres: getGenresFromIds(),
        countries: getCountriesFromIds());
  }

  void updatePrefsToMatch(Room room) {
    setShowMovies(room.showMovies);
    setShowSeries(room.showSeries);
    List<String> genres = [];
    for (Genre g in room.genres) {
      genres.add(g.id);
    }
    setGenreIds(genres);
  }
}
