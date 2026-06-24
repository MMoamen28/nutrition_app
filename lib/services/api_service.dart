import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Change this to your computer's IP when testing on a real phone.
  // Use 10.0.2.2 for Android emulator, localhost for iOS simulator.
  static const String _base = 'http://10.0.2.2:3000/api';

  static Map<String, String> get _headers =>
      {'Content-Type': 'application/json'};

  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) =>
      _post('/auth/register', data);

  static Future<Map<String, dynamic>> login(String username, String password) =>
      _post('/auth/login', {'username': username, 'password': password});

  static Future<Map<String, dynamic>> getUser(String username) =>
      _get('/users/$username');

  static Future<Map<String, dynamic>> updateUser(
      String username, Map<String, dynamic> data) =>
      _put('/users/$username', data);

  static Future<Map<String, dynamic>> addFoodEntry(
      String username, Map<String, dynamic> entry) =>
      _post('/users/$username/food', entry);

  static Future<Map<String, dynamic>> addWeightEntry(
      String username, double weight, String date) =>
      _post('/users/$username/weight', {'weight': weight, 'date': date});

  // ── Private HTTP helpers ─────────────────────────────────────────────────

  static Future<Map<String, dynamic>> _get(String path) async {
    final res = await http.get(Uri.parse('$_base$path'), headers: _headers);
    return _parse(res);
  }

  static Future<Map<String, dynamic>> _post(
      String path, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$_base$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _parse(res);
  }

  static Future<Map<String, dynamic>> _put(
      String path, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('$_base$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _parse(res);
  }

  static Map<String, dynamic> _parse(http.Response res) {
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode >= 200 && res.statusCode < 300) return body;
    throw ApiException(body['error'] ?? 'Request failed (${res.statusCode})');
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}
