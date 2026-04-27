import 'dart:convert';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../features/auth/authService.dart';

class CourseService {
  static const String _baseUrl = 'http://43.205.111.147:8080/api';

  // Create a new course
  Future<bool> createCourse({
    required String name,
    required String description,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      var response = await http.post(
        Uri.parse('$_baseUrl/courses'),
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': name,
          'description': description,
        }),
      );

      // If token expired, try to refresh and retry
      if (response.statusCode == 401 || response.statusCode == 403) {
        final newToken = await AuthService().refreshToken();
        if (newToken != null && newToken.isNotEmpty) {
          response = await http.post(
            Uri.parse('$_baseUrl/courses'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $newToken',
            },
            body: json.encode({
              'name': name,
              'description': description,
            }),
          );
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        return true;
      } else {
        // Log the error or handle it
        print('Failed to create course: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception while creating course: $e');
      return false;
    }
  }

  Future<List<Course>> getAllCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      var response = await http.get(
        Uri.parse('$_baseUrl/courses'),
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      // If token expired, try to refresh and retry
      if (response.statusCode == 401 || response.statusCode == 403) {
        final newToken = await AuthService().refreshToken();
        if (newToken != null && newToken.isNotEmpty) {
          response = await http.get(
            Uri.parse('$_baseUrl/courses'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $newToken',
            },
          );
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body);
        final courses = data.map((item) => Course.fromJson(item)).toList();
        return courses;
      } else {
        // Log the error or handle it
        print('Failed to load courses: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exception while loading courses: $e');
      return [];
    }
  }

  Future<bool> updateCourse({
    required String id,
    required String name,
    required String description,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      var response = await http.put(
        Uri.parse('$_baseUrl/courses/$id'),
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': name,
          'description': description,
        }),
      );

      // If token expired, try to refresh and retry
      if (response.statusCode == 401 || response.statusCode == 403) {
        final newToken = await AuthService().refreshToken();
        if (newToken != null && newToken.isNotEmpty) {
          response = await http.put(
            Uri.parse('$_baseUrl/courses/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $newToken',
            },
            body: json.encode({
              'name': name,
              'description': description,
            }),
          );
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        return true;
      } else {
        // Log the error or handle it
        print('Failed to create course: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception while creating course: $e');
      return false;
    }
  }
}
