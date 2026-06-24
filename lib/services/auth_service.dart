import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  // SharedPreferences only keeps the logged-in username as a session token.
  // All user data lives in MongoDB Atlas via ApiService.
  static const _loggedInKey = 'logged_in_user';

  /// Register a new user. Returns null on success, error message on failure.
  static Future<String?> register(UserModel user) async {
    try {
      await ApiService.register({
        'username':      user.username,
        'password':      user.password,
        'name':          user.name,
        'age':           user.age,
        'weight':        user.weight,
        'height':        user.height,
        'gender':        user.gender,
        'activityLevel': user.activityLevel,
        'goal':          user.goal,
      });
      return null;
    } on ApiException catch (e) {
      return e.message;
    } catch (_) {
      return 'Could not connect to server. Check your internet connection.';
    }
  }

  /// Login. Returns the UserModel on success, null on failure.
  static Future<UserModel?> login(String username, String password) async {
    try {
      final res  = await ApiService.login(username, password);
      final user = UserModel.fromMap(_toFlutterMap(res['user']));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_loggedInKey, user.username);
      return user;
    } catch (_) {
      return null;
    }
  }

  /// Restore the previously logged-in user from MongoDB (used at app start).
  static Future<UserModel?> getCurrentUser() async {
    try {
      final prefs    = await SharedPreferences.getInstance();
      final username = prefs.getString(_loggedInKey);
      if (username == null) return null;

      final data = await ApiService.getUser(username);
      return UserModel.fromMap(_toFlutterMap(data));
    } catch (_) {
      return null;
    }
  }

  /// Persist any change made to the user object back to MongoDB.
  static Future<void> updateUser(UserModel user) async {
    try {
      await ApiService.updateUser(user.username, {
        'name':                  user.name,
        'age':                   user.age,
        'weight':                user.weight,
        'height':                user.height,
        'gender':                user.gender,
        'activityLevel':         user.activityLevel,
        'goal':                  user.goal,
        'caloriesConsumedToday': user.caloriesConsumedToday,
        'lastActiveDate':        user.lastActiveDate,
        'weightLog':             user.weightLog.map((e) => e.toMap()).toList(),
        'foodLog':               user.foodLog.map((e) => e.toMap()).toList(),
        'walletBalance':         user.walletBalance,
        'planType':              user.planType,
        'proExpiryDate':         user.proExpiryDate,
      });
    } catch (_) {
      // Fail silently — the in-memory state is still correct for the current session.
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
  }

  // MongoDB returns _id / __v / timestamps that UserModel.fromMap doesn't expect.
  // Strip them so fromMap works without changes.
  static Map<String, dynamic> _toFlutterMap(Map<String, dynamic> m) {
    final cleaned = Map<String, dynamic>.from(m);
    cleaned.remove('_id');
    cleaned.remove('__v');
    cleaned.remove('createdAt');
    cleaned.remove('updatedAt');
    // Restore plain-text password field Flutter model expects (unused for auth
    // logic but required by the constructor). Backend never returns the hash.
    cleaned.putIfAbsent('password', () => '');
    return cleaned;
  }
}
