import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instancePrefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Token management
  Future<void> saveToken(String token) async {
    final prefs = await _instancePrefs;
    await prefs.setString(AppConstants.tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await _instancePrefs;
    return prefs.getString(AppConstants.tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await _instancePrefs;
    await prefs.remove(AppConstants.tokenKey);
  }

  // User caching
  Future<void> saveUser(Map<String, dynamic> userJson) async {
    final prefs = await _instancePrefs;
    await prefs.setString(AppConstants.userKey, jsonEncode(userJson));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await _instancePrefs;
    final userStr = prefs.getString(AppConstants.userKey);
    if (userStr != null) {
      return jsonDecode(userStr) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> clearUser() async {
    final prefs = await _instancePrefs;
    await prefs.remove(AppConstants.userKey);
  }

  // Generic key-value
  Future<void> setString(String key, String value) async {
    final prefs = await _instancePrefs;
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await _instancePrefs;
    return prefs.getString(key);
  }

  Future<void> clearAll() async {
    final prefs = await _instancePrefs;
    await prefs.clear();
  }
}
