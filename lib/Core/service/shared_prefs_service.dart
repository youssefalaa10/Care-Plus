import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:careplus/Features/Auth/Data/Model/user_model.dart';

class SharedPrefsService {
  static const String USER_KEY = 'user_data';
  static const String AUTH_TOKEN_KEY = 'auth_token';
  static const String REMEMBER_ME_KEY = 'remember_me';
  static const String THEME_KEY = 'app_theme';
  static const String NOTIFICATION_KEY = 'notifications_enabled';
  static const String FIRST_TIME_KEY = 'first_time_user';

  static SharedPrefsService? _instance;
  static SharedPreferences? _prefs;

  factory SharedPrefsService() => _instance ??= SharedPrefsService._internal();
  SharedPrefsService._internal();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences? get prefs => _prefs;

  Future<bool> saveUserData(UserModel user) async {
    if (_prefs == null) await init();
    final userJson = json.encode(user.toJson());
    return await _prefs!.setString(USER_KEY, userJson);
  }

  /// Retrieve UserModel from SharedPreferences
  UserModel? getUserData() {
    if (_prefs == null) return null;

    final userJson = _prefs!.getString(USER_KEY);
    if (userJson == null) return null;

    try {
      final userData = json.decode(userJson);
      return UserModel.fromJson(userData);
    } catch (e) {
      print('Error parsing user data from preferences: $e');
      return null;
    }
  }

  Future<bool> saveAuthToken(String token) async {
    if (_prefs == null) await init();
    return await _prefs!.setString(AUTH_TOKEN_KEY, token);
  }

  String? getAuthToken() {
    if (_prefs == null) return null;
    return _prefs!.getString(AUTH_TOKEN_KEY);
  }

  Future<bool> setRememberMe(bool value) async {
    if (_prefs == null) await init();
    return await _prefs!.setBool(REMEMBER_ME_KEY, value);
  }

  bool getRememberMe() {
    if (_prefs == null) return false;
    return _prefs!.getBool(REMEMBER_ME_KEY) ?? false;
  }

  bool isLoggedIn() {
    if (_prefs == null) return false;
    return _prefs!.containsKey(USER_KEY) && _prefs!.containsKey(AUTH_TOKEN_KEY);
  }

  bool isFirstTimeUser() {
    if (_prefs == null) return true;
    return _prefs!.getBool(FIRST_TIME_KEY) ?? true;
  }

  Future<bool> setFirstTimeUser(bool value) async {
    if (_prefs == null) await init();
    return await _prefs!.setBool(FIRST_TIME_KEY, value);
  }

  Future<bool> clearSession() async {
    if (_prefs == null) await init();
    await _prefs!.remove(USER_KEY);
    await _prefs!.remove(AUTH_TOKEN_KEY);

    if (!getRememberMe()) {
      await _prefs!.remove(REMEMBER_ME_KEY);
    }

    return true;
  }

  Future<bool> clearAll() async {
    if (_prefs == null) await init();
    return await _prefs!.clear();
  }
}
