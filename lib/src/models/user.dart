enum UserRole { admin, student, lecturer }

UserRole userRoleFromString(String role) {
  switch (role.toUpperCase()) {
    case 'ADMIN':
      return UserRole.admin;
    case 'STUDENT':
      return UserRole.student;
    case 'LECTURER':
      return UserRole.lecturer;
    default:
      throw Exception('Invalid role');
  }
}

String userRoleToString(UserRole role) {
  return role.name.toUpperCase();
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AppUser.fromJson(Map<String,dynamic> json) => AppUser(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    role: userRoleFromString(json['role']),
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': userRoleToString(role),
    };
  }


}

class Student extends AppUser {
  final String batchId;
  final String studentId;
  final String batchName;
  final List<String>? enrolledCourseIds;

  const Student({
    required super.id,
    required super.name,
    required super.email,
    required this.batchId,
    required this.studentId,
    this.enrolledCourseIds,
    required this.batchName,
  }) : super(role: UserRole.student);

  factory Student.fromJson(Map<String,dynamic> json) => Student(
    id: json['userId'],
    studentId: json['studentId'],
    name: json['studentName'],
    email: json['studentName'],
    batchId: json['batchId'],
    batchName: json['batchName'],
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'batchId': batchId,
    };
  }


}

class Lecturer extends AppUser {
  final List<String>? assignedCourseIds;
  final String lecturerId;

  const Lecturer({
    required super.id,
    required super.name,
    required super.email,
    this.assignedCourseIds, required this.lecturerId,
  }) : super(role: UserRole.lecturer);

  factory Lecturer.fromJson(Map<String, dynamic> json) => Lecturer(
    id: json['id'].toString(),
    name: json['userName'],
    email: json['userEmail'],
    lecturerId: json['userId'],
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}
