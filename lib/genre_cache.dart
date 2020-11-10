import 'package:openapi/api.dart';
import 'api.dart';
import 'package:collection/collection.dart';

class GenreCache {
  static List<Genre> _loadedGenres;
  static List<String> _loadedGenreIds;
  static List<String> _loadingGenreIds;
  static Future<List<Genre>> _loading;
  static Function _eq = const ListEquality().equals;

  static bool isAlreadyLoaded(List<String> ids) {
    return _loadedGenreIds != null && _eq(ids, _loadedGenreIds);
  }

  static List<Genre> alreadyLoaded() {
    return _loadedGenres;
  }

  static Future<List<Genre>> loadGenres(List<String> ids) async {
    if (isAlreadyLoaded(ids)) {
      return _loadedGenres;
    }
    if (_eq(ids, _loadingGenreIds) && _loading != null) {
      return _loading;
    }
    _loadingGenreIds = [
      ...{...ids}
    ];
    _loading = Api.I()
        .ready()
        .then((_) => Api.attempt(Api.I().genres.getGenres(ids: ids.join(','))))
        .then((genres) {
      _loadedGenres = genres;
      _loadedGenreIds = [
        ...{...ids}
      ];
      return genres;
    });
    return _loading;
  }
}
