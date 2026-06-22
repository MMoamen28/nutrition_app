import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const _usersKey = 'users';
  static const _loggedInKey = 'logged_in_user';

  static String _todayStr() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  static Future<String?> register(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    Map<String, dynamic> users = usersJson != null ? json.decode(usersJson) : {};
    if (users.containsKey(user.username)) return 'Username already exists.';
    final today = _todayStr();
    user.weightLog.add(WeightEntry(weight: user.weight, date: today));
    user.lastActiveDate = today;
    users[user.username] = user.toMap();
    await prefs.setString(_usersKey, json.encode(users));
    return null;
  }

  static Future<UserModel?> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return null;
    Map<String, dynamic> users = json.decode(usersJson);
    if (!users.containsKey(username)) return null;
    final userData = users[username] as Map<String, dynamic>;
    if (userData['password'] != password) return null;
    final user = UserModel.fromMap(userData);
    final today = _todayStr();
    if (user.lastActiveDate != today) {
      user.caloriesConsumedToday = 0;
      user.lastActiveDate = today;
      users[username] = user.toMap();
      await prefs.setString(_usersKey, json.encode(users));
    }
    await prefs.setString(_loggedInKey, username);
    return user;
  }

  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_loggedInKey);
    if (username == null) return null;
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return null;
    Map<String, dynamic> users = json.decode(usersJson);
    if (!users.containsKey(username)) return null;
    final user = UserModel.fromMap(users[username]);
    final today = _todayStr();
    if (user.lastActiveDate != today) {
      user.caloriesConsumedToday = 0;
      user.lastActiveDate = today;
      users[username] = user.toMap();
      await prefs.setString(_usersKey, json.encode(users));
    }
    return user;
  }

  static Future<void> updateUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    Map<String, dynamic> users = usersJson != null ? json.decode(usersJson) : {};
    users[user.username] = user.toMap();
    await prefs.setString(_usersKey, json.encode(users));
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
  }
}
