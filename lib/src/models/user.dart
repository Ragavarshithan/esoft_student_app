enum UserRole { admin, student, lecturer }

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
}

class Student extends AppUser {
  final String batchId;
  final List<String> enrolledCourseIds;

  const Student({
    required super.id,
    required super.name,
    required super.email,
    required this.batchId,
    required this.enrolledCourseIds,
  }) : super(role: UserRole.student);
}

class Lecturer extends AppUser {
  final List<String> assignedCourseIds;

  const Lecturer({
    required super.id,
    required super.name,
    required super.email,
    required this.assignedCourseIds,
  }) : super(role: UserRole.lecturer);
}
