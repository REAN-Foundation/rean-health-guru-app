import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }

  readString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  saveDouble(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  Future<double> readDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) == null ? 0.0 : prefs.getDouble(key);
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  saveBoolean(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<bool> readBoolean(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) == null ? false : prefs.getBool(key);
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
