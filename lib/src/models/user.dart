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

  factory AppUser.fromJson(Map<String,dynamic> json) => AppUser(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    role: json['role'],
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

class Student extends AppUser {
  final String batchId;
  final List<String>? enrolledCourseIds;

  const Student({
    required super.id,
    required super.name,
    required super.email,
    required this.batchId,
    this.enrolledCourseIds,
  }) : super(role: UserRole.student);

  factory Student.fromJson(Map<String,dynamic> json) => Student(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    batchId: json['batchId'],
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

class Lecturer extends AppUser {
  final List<String>? assignedCourseIds;

  const Lecturer({
    required super.id,
    required super.name,
    required super.email,
    this.assignedCourseIds,
  }) : super(role: UserRole.lecturer);
}
