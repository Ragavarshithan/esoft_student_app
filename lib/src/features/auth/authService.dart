import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esoft_student_app/src/models/auth_response.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  AuthResponse? _currentUser;

  // Get current user
  AuthResponse? get currentUser => _currentUser;

  // API base URL
  static const String _baseUrl = 'http://43.205.111.147:8080/api';

  // Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _currentUser = AuthResponse.fromJson(data);

        // Save tokens
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', _currentUser!.accessToken);
        await prefs.setString('refreshToken', _currentUser!.refreshToken);
        await prefs.setString('userEmail', _currentUser!.email);
        await prefs.setString('userName', _currentUser!.name);
        await prefs.setString('userRole', _currentUser!.role);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Return false if network error or other exceptions occur
      return false; 
    }
  }

  // Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Registration failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception during registration: $e');
      return false;
    }
  }

  // Refresh Token
  Future<String?> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');

      if (refreshToken == null || refreshToken.isEmpty) return null;

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/refresh-token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Update stored access token
        final newAccessToken = data['accessToken'] as String;
        await prefs.setString('accessToken', newAccessToken);

        // If backend issues a new refresh token, save it too
        if (data['refreshToken'] != null) {
          await prefs.setString('refreshToken', data['refreshToken']);
        }

        return newAccessToken;
      } else {
        // Refresh token might be expired, log user out
        await logout();
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    await prefs.remove('userRole');
  }

  // Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  // Check existing session
  Future<bool> checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');
    final email = prefs.getString('userEmail');
    final name = prefs.getString('userName');
    final role = prefs.getString('userRole');

    if (accessToken != null && refreshToken != null && email != null && name != null && role != null) {
      _currentUser = AuthResponse(
        accessToken: accessToken,
        refreshToken: refreshToken,
        email: email,
        name: name,
        role: role,
      );
      return true;
    }
    return false;
  }
}