import 'package:esoft_student_app/src/models/creadential.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // In-memory storage for demo purposes
  final List<UserCredential> _users = [];
  UserCredential? _currentUser;

  // Get current user
  UserCredential? get currentUser => _currentUser;

  // Register new user
  Future<bool> register({
    required String fullName,
    required String studentId,
    required String email,
    required String password,
  }) async {
    // Check if email already exists
    if (_users.any((user) => user.email == email)) {
      return false; // Email already registered
    }

    // Create new user
    final newUser = UserCredential.create(
      fullName: fullName,
      studentId: studentId,
      email: email,
      password: password,
    );

    _users.add(newUser);
    return true;
  }

  // Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      // Find user by email
      final user = _users.firstWhere(
            (user) => user.email == email && user.password == password,
      );

      _currentUser = user;
      return true;
    } catch (e) {
      return false; // User not found or invalid credentials
    }
  }

  // Logout
  void logout() {
    _currentUser = null;
  }

  // Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  // Get all registered users (for demo purposes)
  List<UserCredential> get allUsers => List.unmodifiable(_users);
}