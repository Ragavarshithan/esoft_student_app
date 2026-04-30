import 'dart:convert';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../features/auth/authService.dart';

class LMSService {
  static const String _baseUrl = 'http://13.233.87.143:8080/api';

  // Helper method to get headers
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';
    return {
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }
  // Helper method to handle token refresh logic automatically
  Future<http.Response> _makeRequest(
      Future<http.Response> Function(Map<String, String>) request) async {
    var headers = await _getHeaders();
    var response = await request(headers);
    if (response.statusCode == 401 || response.statusCode == 403) {
      final newToken = await AuthService().refreshToken();
      if (newToken != null && newToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $newToken';
        response = await request(headers);
      }
    }
    return response;
  }

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

  Future<List<Batch>> getBatchByCourseId({
    required String courseId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      var response = await http.get(
        Uri.parse('$_baseUrl/courses/$courseId/batches'),
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
            Uri.parse('$_baseUrl/$courseId/batches'),
            headers: {
              'Content-Type': 'application/json',
              if (token.isNotEmpty) 'Authorization': 'Bearer $token',
            },
          );
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body);
        final batches = data.map((item) => Batch.fromJson(item)).toList();
        return batches;
      } else {
        // Log the error or handle it
        print('Failed to create course: ${response.body}');
        return[];
      }
    } catch (e) {
      print('Exception while creating course: $e');
      return [];
    }
  }

  Future<bool> createBatch({
    required String name,
    required int year,
    required String courseId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      var response = await http.post(
        Uri.parse('$_baseUrl/batches'),
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': name,
          'year': year,
          'courseId': courseId,
        }),
      );

      // If token expired, try to refresh and retry
      if (response.statusCode == 401 || response.statusCode == 403) {
        final newToken = await AuthService().refreshToken();
        if (newToken != null && newToken.isNotEmpty) {
          response = await http.post(
            Uri.parse('$_baseUrl/batches'),
            headers: {
              'Content-Type': 'application/json',
              if (token.isNotEmpty) 'Authorization': 'Bearer $token',
            },
            body: json.encode({
              'name': name,
              'year': year,
              'courseId': courseId,
            }),
          );
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        return true;
      } else {
        // Log the error or handle it
        print('Failed to create batch: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception while creating batch: $e');
      return false;
    }
  }


  Future<String> createUser({
    required String name,
    required String email,
    required UserRole role,
    String? batchId,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "name": name,
        "email": email,
        "role": role.name.toUpperCase(),
      };


      if (role == UserRole.student) {
        if (batchId == null || batchId.isEmpty) {
          throw Exception("Batch ID is required for student");
        }
        body["batchId"] = batchId;
      }

      final response = await _makeRequest((headers) => http.post(
        Uri.parse('$_baseUrl/admin/users'),
        headers: headers,
        body: json.encode(body),
      ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return "user created successfully";
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    return  "error occurred on creating user";;
  }


  Future<List<Lecturer>> getAllLecturers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      var response = await http.get(
        Uri.parse('$_baseUrl/lecturers'),
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      // If token expired, try to refresh and retry
      if (response.statusCode == 401 || response.statusCode == 403) {
        final newToken = await AuthService().refreshToken();
        if (newToken != null && newToken.isNotEmpty) {

        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body);
        final lecturers = data.map((item) => Lecturer.fromJson(item)).toList();
        return lecturers;
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

  Future<Lecturer?> getLecturerById(String lecturerId) async {
    try {
      final response = await _makeRequest((headers) => http.get(
        Uri.parse('$_baseUrl/lecturers/$lecturerId'),
        headers: headers,
      ));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Lecturer.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Exception while fetching lecturer: $e');
      return null;
    }
  }

  Future<bool> updateLecturer({
    required String userId,
    required String lecturerId,
    required String name,
    required String email,
  }) async {
    try {
      final response = await _makeRequest((headers) => http.put(
        Uri.parse('$_baseUrl/lecturers/$userId'),
        headers: headers,
        body: json.encode({
          "userId":lecturerId,
          "name": name,
          "email": email,
        }),
      ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    return  false;
  }


  Future<bool> deleteLecturer(String lecturerId) async {
    try {
      final response = await _makeRequest((headers) => http.delete(
        Uri.parse('$_baseUrl/lecturers/$lecturerId'),
        headers: headers,
      ));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Exception while fetching lecturer: $e');
      return false;
    }
  }

  Future<List<Student>> getStudentsByBatchId({required String batchId}) async {
    try {
      final response = await _makeRequest((headers) => http.get(
        Uri.parse('$_baseUrl/batches/$batchId/students'),
        headers: headers,
      ));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final students = data.map((item) => Student.fromJson(item)).toList();
        return students;
      }
      return [];
    } catch (e) {
      print('Exception while loading students for batch: $e');
      return [];
    }
  }

  Future<bool> updateStudent({
    required String studentId,
    required String userId,
    required String name,
    required String email,
    required String batchId
  }) async {
    try {
      final response = await _makeRequest((headers) => http.put(
        Uri.parse('$_baseUrl/students/$userId'),
        headers: headers,
        body: json.encode({
          "userId":userId,
          "name": name,
          "email": email,
          "batchId": batchId
        }),
      ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    return  false;
  }

  Future<bool> deleteStudent(String studentId) async {
    try {
      final response = await _makeRequest((headers) => http.delete(
        Uri.parse('$_baseUrl/students/$studentId'),
        headers: headers,
      ));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Exception while fetching lecturer: $e');
      return false;
    }
  }

  Future<List<Module>> getModuleBycourseId({required String courseId}) async {
    try {
      final response = await _makeRequest((headers) => http.get(
        Uri.parse('$_baseUrl/courses/$courseId/modules'),
        headers: headers,
      ));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final modules = data.map((item) => Module.fromJson(item)).toList();
        return modules;
      }
      return [];
    } catch (e) {
      print('Exception while loading students for batch: $e');
      return [];
    }
  }

  Future<bool> updateModule({
    required String moduleId,
    required String name,
    required String courseId,
    required String lecturerId
  }) async {
    try {
      final response = await _makeRequest((headers) => http.put(
        Uri.parse('$_baseUrl/modules/$moduleId'),
        headers: headers,
        body: json.encode({
          "name": name,
          "courseId": courseId,
          "lecturerId": lecturerId
        }),
      ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    return  false;
  }

  Future<bool> deleteModule(String moduleId) async {
    try {
      final response = await _makeRequest((headers) => http.delete(
        Uri.parse('$_baseUrl/modules/$moduleId'),
        headers: headers,
      ));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Exception while fetching lecturer: $e');
      return false;
    }
  }

  Future<bool> createModule({
    required String name,
    required String courseId,
    required String lecturerId,
  }) async {
    try {
      final response = await _makeRequest((headers) => http.post(
        Uri.parse('$_baseUrl/modules'),
        headers: headers,
        body: json.encode({
          'name': name,
          'courseId': courseId,
          'lecturerId': lecturerId,
        }),
      ));
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Exception while creating module: $e');
      return false;
    }
  }

  Future<List<Assignment>> getAssignmentsByModuleId(String moduleId) async {
    try {
      final response = await _makeRequest((headers) => http.get(
        Uri.parse('$_baseUrl/assignments/module/$moduleId'),
        headers: headers,
      ));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Assignment.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Exception while loading assignments: $e');
      return [];
    }
  }

  Future<bool> updateAssignment(String assignmentId, String title, String description, DateTime dueDate,String moduleId) async {
    try {
      final response = await _makeRequest((headers) => http.put(
        Uri.parse('$_baseUrl/assignments/$assignmentId'),
        headers: headers,
        body: json.encode({
          'title': title,
          'description': description,
          'dueDate': dueDate.toIso8601String(),
          'moduleId': moduleId
        }),
      ));
      return response.statusCode == 200;
    } catch (e) {
      print('Exception while updating assignment: $e');
      return false;
    }
  }


  Future<bool> deleteAssignment(String assignmentId) async {
    try {
      final response = await _makeRequest((headers) => http.delete(
        Uri.parse('$_baseUrl/assignments/$assignmentId'),
        headers: headers,
      ));
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Exception while deleting assignment: $e');
      return false;
    }
  }

  Future<bool> createAssignment({
    required String moduleId,
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    try {
      final response = await _makeRequest((headers) => http.post(
        Uri.parse('$_baseUrl/assignments'),
        headers: headers,
        body: json.encode({
          'moduleId': moduleId,
          'title': title,
          'description': description,
          'dueDate': dueDate.toIso8601String(),
        }),
      ));
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Exception while creating assignment: $e');
      return false;
    }
  }

  Future<List<Attendance>> getAttendance(String moduleId, String studentId) async {
    try {
      final response = await _makeRequest((headers) => http.get(
        Uri.parse('$_baseUrl/attendance?moduleId=$moduleId&studentId=$studentId'),
        headers: headers,
      ));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Attendance.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Exception while loading attendance: $e');
      return [];
    }
  }


}
