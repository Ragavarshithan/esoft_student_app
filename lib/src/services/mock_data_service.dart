import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../models/course_data.dart';
import '../models/performance.dart' hide Mark, Attendance;
import '../models/message.dart';

class CurrentUserNotifier extends Notifier<AppUser?> {
  @override
  AppUser? build() => null;
  void setUser(AppUser? user) => state = user;
}

final currentUserProvider = NotifierProvider<CurrentUserNotifier, AppUser?>(CurrentUserNotifier.new);

// Data layer - Mock with Extended Data
class MockDataService {
  final List<AppUser> users = [
    // Admins (2)
    const AppUser(id: 'a1', name: 'Admin Flow', email: 'admin@esoft.lk', role: UserRole.admin),
    const AppUser(id: 'a2', name: 'Sarah Johnson', email: 'sarah.admin@esoft.lk', role: UserRole.admin),

    // Students (15)
    const Student(id: 's1', name: 'John Doe', email: 'john.doe@student.esoft.lk', batchId: 'b1', enrolledCourseIds: ['c1', 'c2', 'c3']),
    const Student(id: 's2', name: 'Jane Smith', email: 'jane.smith@student.esoft.lk', batchId: 'b1', enrolledCourseIds: ['c1', 'c2']),
    const Student(id: 's3', name: 'Michael Chen', email: 'michael.chen@student.esoft.lk', batchId: 'b1', enrolledCourseIds: ['c1', 'c3', 'c4']),
    const Student(id: 's4', name: 'Emma Wilson', email: 'emma.wilson@student.esoft.lk', batchId: 'b2', enrolledCourseIds: ['c2', 'c3']),
    const Student(id: 's5', name: 'David Brown', email: 'david.brown@student.esoft.lk', batchId: 'b2', enrolledCourseIds: ['c1', 'c4', 'c5']),
    const Student(id: 's6', name: 'Lisa Anderson', email: 'lisa.anderson@student.esoft.lk', batchId: 'b1', enrolledCourseIds: ['c2', 'c4']),
    const Student(id: 's7', name: 'Robert Taylor', email: 'robert.taylor@student.esoft.lk', batchId: 'b2', enrolledCourseIds: ['c1', 'c2', 'c3']),
    const Student(id: 's8', name: 'Sophie Martinez', email: 'sophie.martinez@student.esoft.lk', batchId: 'b1', enrolledCourseIds: ['c3', 'c4', 'c5']),
    const Student(id: 's9', name: 'James Garcia', email: 'james.garcia@student.esoft.lk', batchId: 'b3', enrolledCourseIds: ['c1', 'c5']),
    const Student(id: 's10', name: 'Olivia Lee', email: 'olivia.lee@student.esoft.lk', batchId: 'b2', enrolledCourseIds: ['c2', 'c3', 'c4']),
    const Student(id: 's11', name: 'William Rodriguez', email: 'william.rodriguez@student.esoft.lk', batchId: 'b1', enrolledCourseIds: ['c1', 'c2']),
    const Student(id: 's12', name: 'Isabella White', email: 'isabella.white@student.esoft.lk', batchId: 'b3', enrolledCourseIds: ['c3', 'c5']),
    const Student(id: 's13', name: 'Lucas Johnson', email: 'lucas.johnson@student.esoft.lk', batchId: 'b2', enrolledCourseIds: ['c4', 'c5']),
    const Student(id: 's14', name: 'Mia Thompson', email: 'mia.thompson@student.esoft.lk', batchId: 'b1', enrolledCourseIds: ['c1', 'c3']),
    const Student(id: 's15', name: 'Noah Jackson', email: 'noah.jackson@student.esoft.lk', batchId: 'b3', enrolledCourseIds: ['c2', 'c4', 'c5']),

    // Lecturers (8)
    const Lecturer(id: 'l1', name: 'Dr. Smith', email: 'smith@lecturer.esoft.lk', assignedCourseIds: ['c1', 'c2']),
    const Lecturer(id: 'l2', name: 'Prof. Emily Davis', email: 'emily.davis@lecturer.esoft.lk', assignedCourseIds: ['c3', 'c4']),
    const Lecturer(id: 'l3', name: 'Dr. James Wilson', email: 'james.wilson@lecturer.esoft.lk', assignedCourseIds: ['c5']),
    const Lecturer(id: 'l4', name: 'Prof. Michelle Brown', email: 'michelle.brown@lecturer.esoft.lk', assignedCourseIds: ['c1', 'c3']),
    const Lecturer(id: 'l5', name: 'Dr. Robert Chen', email: 'robert.chen@lecturer.esoft.lk', assignedCourseIds: ['c2', 'c4']),
    const Lecturer(id: 'l6', name: 'Prof. Lisa Anderson', email: 'lisa.anderson@lecturer.esoft.lk', assignedCourseIds: ['c1', 'c5']),
    const Lecturer(id: 'l7', name: 'Dr. Mark Johnson', email: 'mark.johnson@lecturer.esoft.lk', assignedCourseIds: ['c3']),
    const Lecturer(id: 'l8', name: 'Prof. Sarah Martinez', email: 'sarah.martinez@lecturer.esoft.lk', assignedCourseIds: ['c4', 'c5']),
  ];

  final List<Batch> batches = [
    const Batch(id: 'b1', name: 'Batch 21', year: '2023'),
    const Batch(id: 'b2', name: 'Batch 22', year: '2023'),
    const Batch(id: 'b3', name: 'Batch 20', year: '2022'),
  ];

  final List<Course> courses = [
    const Course(id: 'c1', name: 'Software Engineering', description: 'Introduction to Software Engineering principles and practices', moduleId: 'm1', batchId: 'b1'),
    const Course(id: 'c2', name: 'Database Management', description: 'Advanced Database Design and SQL', moduleId: 'l2', batchId: 'b1'),
    const Course(id: 'c3', name: 'Mobile Development', description: 'Flutter and Cross-platform Mobile App Development', moduleId: 'l3', batchId: 'b2'),
    const Course(id: 'c4', name: 'Web Development', description: 'Modern Web Technologies: React, Node.js and TypeScript', moduleId: 'l4', batchId: 'b1'),
    const Course(id: 'c5', name: 'Cloud Computing', description: 'Cloud Architecture and AWS fundamentals', moduleId: 'l5', batchId: 'b2'),
    const Course(id: 'c6', name: 'Artificial Intelligence', description: 'Machine Learning and AI Fundamentals', moduleId: 'l6', batchId: 'b3'),
    const Course(id: 'c7', name: 'Cybersecurity', description: 'Network Security and Data Protection', moduleId: 'l7', batchId: 'b1'),
    const Course(id: 'c8', name: 'DevOps Engineering', description: 'CI/CD Pipelines and Infrastructure as Code', moduleId: 'l8', batchId: 'b2'),
  ];

  final List<Module> modules = [
    const Module(id: 'm1', courseId: 'c1', name: 'Introduction to SE', lecturerId: 'l1'),
    const Module(id: 'm2', courseId: 'c1', name: 'Design Patterns', lecturerId: 'l4'),

    const Module(id: 'm3', courseId: 'c2', name: 'Database Design', lecturerId: 'l2'),
    const Module(id: 'm4', courseId: 'c2', name: 'SQL Optimization', lecturerId: 'l5'),

    const Module(id: 'm5', courseId: 'c3', name: 'Flutter Basics', lecturerId: 'l3'),
    const Module(id: 'm6', courseId: 'c3', name: 'API Integration', lecturerId: 'l3'),
  ];

  final List<Assignment> assignments = [
    Assignment(
      id: 'a1',
      moduleId: 'm1',
      title: 'Assignment 1 - UML Diagrams',
      description: 'Create UML diagrams for a given system',
      dueDate: DateTime.now().add(const Duration(days: 7)),
    ),
    Assignment(
      id: 'a2',
      moduleId: 'm1',
      title: 'Assignment 2 - Design Patterns',
      description: 'Implement 5 common design patterns',
      dueDate: DateTime.now().add(const Duration(days: 14)),
    ),
    Assignment(
      id: 'a3',
      moduleId: 'm2',
      title: 'Database Schema Design',
      description: 'Design a normalized database schema',
      dueDate: DateTime.now().add(const Duration(days: 10)),
    ),
    Assignment(
      id: 'a4',
      moduleId: 'm2',
      title: 'SQL Query Optimization',
      description: 'Optimize provided SQL queries',
      dueDate: DateTime.now().add(const Duration(days: 12)),
    ),
    Assignment(
      id: 'a5',
      moduleId: 'm3',
      title: 'Flutter Todo App',
      description: 'Build a todo application with Firebase',
      dueDate: DateTime.now().add(const Duration(days: 21)),
    ),
    Assignment(
      id: 'a6',
      moduleId: 'm3',
      title: 'API Integration Project',
      description: 'Integrate REST API in Flutter app',
      dueDate: DateTime.now().add(const Duration(days: 18)),
    ),
    Assignment(
      id: 'a7',
      moduleId: 'm4',
      title: 'React Dashboard',
      description: 'Build a responsive dashboard with React',
      dueDate: DateTime.now().add(const Duration(days: 16)),
    ),
    Assignment(
      id: 'a8',
      moduleId: 'm4',
      title: 'Node.js REST API',
      description: 'Create a RESTful API with Node.js',
      dueDate: DateTime.now().add(const Duration(days: 20)),
    ),
    Assignment(
      id: 'a9',
      moduleId: 'm5',
      title: 'AWS Deployment Project',
      description: 'Deploy application on AWS EC2',
      dueDate: DateTime.now().add(const Duration(days: 25)),
    ),
    Assignment(
      id: 'a10',
      moduleId: 'm6',
      title: 'ML Model Training',
      description: 'Train and evaluate machine learning model',
      dueDate: DateTime.now().add(const Duration(days: 28)),
    ),
    Assignment(
      id: 'a11',
      moduleId: 'm7',
      title: 'Network Security Report',
      description: 'Analyze and report on security vulnerabilities',
      dueDate: DateTime.now().add(const Duration(days: 14)),
    ),
    Assignment(
      id: 'a12',
      moduleId: 'm8',
      title: 'CI/CD Pipeline Setup',
      description: 'Setup automated CI/CD pipeline',
      dueDate: DateTime.now().add(const Duration(days: 19)),
    ),
  ];

  final List<Mark> marks = [
    // Marks for Assignment 1 (c1 - Software Engineering)
    const Mark(id: 'm1', studentId: 's1', moduleId: 'm1', assignmentId: 'a1', score: 85, feedback: 'Good UML diagrams, well structured'),
    const Mark(id: 'm2', studentId: 's2', moduleId: 'm1', assignmentId: 'a1', score: 78, feedback: 'Missing some relationships'),
    const Mark(id: 'm3', studentId: 's3', moduleId: 'm1', assignmentId: 'a1', score: 92, feedback: 'Excellent work!'),
    const Mark(id: 'm4', studentId: 's11', moduleId: 'm1', assignmentId: 'a1', score: 88, feedback: 'Very detailed diagrams'),
    const Mark(id: 'm5', studentId: 's14', moduleId: 'm1', assignmentId: 'a1', score: 75, feedback: 'Needs improvement in clarity'),

    // Marks for Assignment 2 (c1 - Software Engineering)
    const Mark(id: 'm6', studentId: 's1', moduleId: 'm1', assignmentId: 'a2', score: 90, feedback: 'All patterns implemented correctly'),
    const Mark(id: 'm7', studentId: 's2', moduleId: 'm1', assignmentId: 'a2', score: 82, feedback: 'Good implementation with minor issues'),
    const Mark(id: 'm8', studentId: 's3', moduleId: 'm1', assignmentId: 'a2', score: 95, feedback: 'Outstanding!'),
    const Mark(id: 'm9', studentId: 's11', moduleId: 'm1', assignmentId: 'a2', score: 87, feedback: 'Well documented code'),
    const Mark(id: 'm10', studentId: 's14', moduleId: 'm1', assignmentId: 'a2', score: 79, feedback: 'Some patterns need refactoring'),

    // Marks for Assignment 3 (c2 - Database Management)
    const Mark(id: 'm11', studentId: 's1', moduleId: 'm2', assignmentId: 'a3', score: 88, feedback: 'Proper normalization'),
    const Mark(id: 'm12', studentId: 's2', moduleId: 'm2', assignmentId: 'a3', score: 84, feedback: 'Good schema design'),
    const Mark(id: 'm13', studentId: 's6', moduleId: 'm2', assignmentId: 'a3', score: 91, feedback: 'Excellent relationships'),
    const Mark(id: 'm14', studentId: 's10', moduleId: 'm2', assignmentId: 'a3', score: 76, feedback: 'Some redundancy in tables'),
    const Mark(id: 'm15', studentId: 's4', moduleId: 'm2', assignmentId: 'a3', score: 85, feedback: 'Well done'),



    // Marks for Assignment 5 (c3 - Mobile Development)
    const Mark(id: 'm21', studentId: 's3', moduleId: 'm3', assignmentId: 'a5', score: 94, feedback: 'Great Flutter implementation'),
    const Mark(id: 'm22', studentId: 's4', moduleId: 'm3', assignmentId: 'a5', score: 87, feedback: 'Good UI design'),
    const Mark(id: 'm23', studentId: 's8', moduleId: 'm3', assignmentId: 'a5', score: 91, feedback: 'Firebase integration excellent'),
    const Mark(id: 'm24', studentId: 's10', moduleId: 'm3', assignmentId: 'a5', score: 83, feedback: 'Functional but needs UI polish'),
    const Mark(id: 'm25', studentId: 's12', moduleId: 'm3', assignmentId: 'a5', score: 88, feedback: 'Well structured code'),





    // Marks for Assignment 8 (c4 - Web Development)
    const Mark(id: 'm36', studentId: 's3', moduleId: 'm4', assignmentId: 'a8', score: 93, feedback: 'RESTful API best practices'),
    const Mark(id: 'm37', studentId: 's5', moduleId: 'm4', assignmentId: 'a8', score: 87, feedback: 'Good authentication'),
    const Mark(id: 'm38', studentId: 's6', moduleId: 'm4', assignmentId: 'a8', score: 90, feedback: 'Excellent endpoints'),
    const Mark(id: 'm39', studentId: 's13', moduleId: 'm4', assignmentId: 'a8', score: 81, feedback: 'Needs validation'),
    const Mark(id: 'm40', studentId: 's15', moduleId: 'm4', assignmentId: 'a8', score: 85, feedback: 'Good API design'),
  ];

  final List<Attendance> attendanceRecords = [
    // Week 1 - c1 (Software Engineering)
    Attendance(id: 'att1', studentId: 's1', moduleId: 'm1', date: DateTime.now().subtract(const Duration(days: 7)), isPresent: true),
    Attendance(id: 'att2', studentId: 's2', moduleId: 'm1', date: DateTime.now().subtract(const Duration(days: 7)), isPresent: true),
    Attendance(id: 'att3', studentId: 's3', moduleId: 'm1', date: DateTime.now().subtract(const Duration(days: 7)), isPresent: true),
    Attendance(id: 'att4', studentId: 's11', moduleId: 'm1', date: DateTime.now().subtract(const Duration(days: 7)), isPresent: false),
    Attendance(id: 'att5', studentId: 's14', moduleId: 'm1', date: DateTime.now().subtract(const Duration(days: 7)), isPresent: true),

    // Week 1 - c2 (Database Management)
    Attendance(id: 'att6', studentId: 's1', moduleId: 'm2', date: DateTime.now().subtract(const Duration(days: 7)), isPresent: true),
    Attendance(id: 'att7', studentId: 's2', moduleId: 'm2', date: DateTime.now().subtract(const Duration(days: 7)), isPresent: true),
    Attendance(id: 'att8', studentId: 's6', moduleId: 'm2', date: DateTime.now().subtract(const Duration(days: 7)), isPresent: true),
    Attendance(id: 'att9', studentId: 's10', moduleId: 'm2', date: DateTime.now().subtract(const Duration(days: 7)), isPresent: true),
    Attendance(id: 'att10', studentId: 's4', moduleId: 'm2', date: DateTime.now().subtract(const Duration(days: 7)), isPresent: false),

  ];


  // Simulate logging in
  AppUser? login(String role) {
    if (role == 'admin') return users.firstWhere((u) => u.role == UserRole.admin);
    if (role == 'student') return users.firstWhere((u) => u.role == UserRole.student);
    if (role == 'lecturer') return users.firstWhere((u) => u.role == UserRole.lecturer);
    return null;
  }

  // Helper methods for querying data
  // List<Student> getStudentsByBatch(String batchId) {
  //   return users.whereType<Student>().where((s) => s.batchId == batchId).toList();
  // }
  //
  // List<Course> getCoursesByLecturer(String lecturerId) {
  //   return courses.where((c) => c.lecturerId == lecturerId).toList();
  // }
  //
  // List<Assignment> getAssignmentsByCourse(String courseId) {
  //   return assignments.where((a) => a.courseId == courseId).toList();
  // }
  //
  // List<Mark> getMarksByStudent(String studentId) {
  //   return marks.where((m) => m.studentId == studentId).toList();
  // }
  //
  // List<Mark> getMarksByAssignment(String assignmentId) {
  //   return marks.where((m) => m.assignmentId == assignmentId).toList();
  // }
  //
  // List<Attendance> getAttendanceByCourse(String courseId) {
  //   return attendanceRecords.where((a) => a.courseId == courseId).toList();
  // }
  //
  // List<Attendance> getAttendanceByStudent(String studentId) {
  //   return attendanceRecords.where((a) => a.studentId == studentId).toList();
  // }


}

final mockDataServiceProvider = Provider<MockDataService>((ref) {
  return MockDataService();
});