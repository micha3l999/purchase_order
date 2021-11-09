import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesRepo {
  static Future<String?> getPrefer(String keyModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(keyModel);
  }

  static Future<void> setPrefer(String keyModel, String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(keyModel, value);
  }

  static Future<void> clearPrefer() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }
}
