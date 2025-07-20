import 'dart:convert';
import 'package:app/config/key_app.dart';
import 'package:app/config/print_color.dart';
import 'package:http/http.dart' as http;

class FetchApiMovie {
  FetchApiMovie._();

  static Future<Map<String, dynamic>> getMovies() async {
// lấy danh sách các bộ phim mới nhất
    var uri =
        Uri.https(KeyApp.Base_URL, KeyApp.NEW_UPDATE_MOVIES, {'page': '1'});
    Map<String, dynamic> result = {};
    try {
      final response = await http.get(uri);
      var data = jsonDecode(response.body);
      result = data;

      return result;
    } catch (e) {
      printRed(e.toString());
    }
    return result;
  }

  static Future<Map<String, dynamic>> getMovieDetails(String slug) async {
    // lấy thông tin chi tiết bộ phim
    var uri = Uri.https(
      KeyApp.Base_URL,
      '/phim/$slug',
    );
    Map<String, dynamic> result = {};
    try {
      final response = await http.get(uri);
      var data = jsonDecode(response.body);
      result = data;

      return result;
    } catch (e) {
      printRed(e.toString());
    }

    return result;
  }

  static Future<Map<String, dynamic>> getAListOfIndividualMovies() async {
    var uri = Uri.https(KeyApp.Base_URL, KeyApp.SINGLE_MOVIES, {'limit': '50'});
    Map<String, dynamic> result = {};
    try {
      final response = await http.get(uri);
      var data = jsonDecode(response.body);
      result = data;

      return result;
    } catch (e) {
      printRed(e.toString());
    }
    return result;
  }

  static Future<Map<String, dynamic>> getTheListOfMoviesAndSeries() async {
    var uri = Uri.https(KeyApp.Base_URL, KeyApp.SERIES_MOVIES, {'limit': '50'});
    Map<String, dynamic> result = {};
    try {
      final response = await http.get(uri);
      var data = jsonDecode(response.body);
      result = data;

      return result;
    } catch (e) {
      printRed(e.toString());
    }
    return result;
  }

  static Future<Map<String, dynamic>> getTheListOfCartoons() async {
    var uri = Uri.https(KeyApp.Base_URL, KeyApp.CARTOON, {'limit': '50'});
    Map<String, dynamic> result = {};
    try {
      final response = await http.get(uri);
      var data = jsonDecode(response.body);
      result = data;

      return result;
    } catch (e) {
      printRed(e.toString());
    }
    return result;
  }

  static Future<Map<String, dynamic>> movieSearch(String keyWord) async {
    var uri = Uri.https(KeyApp.Base_URL, KeyApp.MOVIES_SEARCH,
        {'keyword': keyWord, 'limit': '10'});
    Map<String, dynamic> result = {};
    try {
      final response = await http.get(uri);
      var data = jsonDecode(response.body);
      result = data;

      return result;
    } catch (e) {
      printRed(e.toString());
    }
    return result;
  }
}
