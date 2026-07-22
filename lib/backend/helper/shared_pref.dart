import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  SharedPreferences? sharedPreferences;
  SharedPreferencesManager({required this.sharedPreferences});

  // TODO :: BOOLEAN VALUES
  Future<bool>? putBool(String key, bool value) => sharedPreferences?.setBool(key, value);
  bool getBool(String key) => sharedPreferences?.getBool(key) ?? false;

  // TODO :: DOUBLE VALUES
  Future<bool>? putDouble(String key, double value) => sharedPreferences?.setDouble(key, value);
  double? getDouble(String key) => sharedPreferences?.getDouble(key);

  // TODO :: INTEGER VALUES
  Future<bool>? putInt(String key, int value) => sharedPreferences?.setInt(key, value);
  int? getInt(String key) => sharedPreferences?.getInt(key);

  // TODO :: STRING VALUES
  Future<bool>? putString(String key, String value) => sharedPreferences?.setString(key, value);
  String? getString(String key) => sharedPreferences?.getString(key);

  Future<bool>? clearKey(String key) => sharedPreferences?.remove(key);
  Future<bool>? clearAll() => sharedPreferences?.clear();
}
