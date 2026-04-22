class UserCredential {
  final String id;
  final String fullName;
  final String studentId;
  final String email;
  final String password;
  final DateTime createdAt;

  UserCredential({
    required this.id,
    required this.fullName,
    required this.studentId,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  // For demonstration purposes - create from signup data
  factory UserCredential.create({
    required String fullName,
    required String studentId,
    required String email,
    required String password,
  }) {
    return UserCredential(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      studentId: studentId,
      email: email,
      password: password,
      createdAt: DateTime.now(),
    );
  }

  // For JSON serialization (if needed later)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'studentId': studentId,
      'email': email,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserCredential.fromJson(Map<String, dynamic> json) {
    return UserCredential(
      id: json['id'],
      fullName: json['fullName'],
      studentId: json['studentId'],
      email: json['email'],
      password: json['password'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}