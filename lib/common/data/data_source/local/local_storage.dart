import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie/core/constants/constants.dart';

class SharedPrefs {
  static final SharedPrefs _instance = SharedPrefs._internal();
  late SharedPreferences _preferences;

  factory SharedPrefs() {
    return _instance;
  }

  SharedPrefs._internal();

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Method để lưu token
  Future<void> setToken(String token) async {
    await _preferences.setString(Constants.token, token);
  }

  // Method để lấy token
  String? getToken() {
    return _preferences.getString(Constants.token);
  }

  // Method để xóa token
  Future<void> removeToken() async {
    await _preferences.remove(Constants.token);
  }


}
