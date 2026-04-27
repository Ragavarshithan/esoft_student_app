import 'package:flutter/foundation.dart';

class Batch {
  final String id;
  final String? courseId;
  final String? courseName;
  final String name; 
  final String year;

  const Batch({
    required this.id,
    this.courseId,
    required this.name,
    required this.year, this.courseName,
  });

  Map<String,dynamic> toJson() => {
    'name': name,
    'year': year,
  };

  factory Batch.fromJson(Map<String,dynamic> json) => Batch(
    id: json['id'],
    name: json['name'],
    year: json['year'],
    courseId: json['courseId'],
    courseName: json['courseName'],
  );
}

class Course {
  final String id;
  final String name;
  final String description;
  final String moduleId;
  final List<String> batchId;

  const Course({
    required this.id,
    required this.name,
    required this.description,
    required this.moduleId,
    required this.batchId,
  });

  factory Course.fromJson(Map<String,dynamic> json) => Course(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    moduleId: json['moduleId'] == null ? '' : json['moduleId'],
    batchId: json['batchId'] == null ? [] : List<String>.from(json['batchId']),
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

class Endrollment {
  final String id;
  final String studentId;
  final String? studentName;
  final String moduleId;
  final String? moduleName;

  const Endrollment({
    required this.id,
    required this.studentId,
    required this.moduleId, this.studentName, this.moduleName,
  });

  factory Endrollment.fromJson(Map<String,dynamic> json) => Endrollment(
    id: json['id'],
    studentId: json['studentId'],
    moduleId: json['moduleId'],
    studentName: json['studentName'],
    moduleName: json['moduleName'],
  );

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'moduleId': moduleId,
    };
  }


}

class Module {
  final String id;
  final String courseId;
  final String? courseName;
  final String name;
  final String lecturerId;
  final String? lecturerName;
  final String? moduleId;
  final List<String>? batchId;

  const Module({
    required this.id,
    required this.courseId,
    this.courseName,
    required this.name,
    required this.lecturerId,
    this.lecturerName,  this.moduleId,  this.batchId,
  });

  factory Module.fromJson(Map<String,dynamic> json) => Module(
    id: json['id'],
    name: json['name'],
    courseId: json['courseId'],
    courseName: json["courseName"],
    lecturerId: json["lecturerId"],
    lecturerName: json["lecturerName"],
    moduleId: json['moduleId'] == null ? '' : json['moduleId'],
    batchId: json['batchId'] == null ? [] : List<String>.from(json['batchId']),
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'courseId': courseId,
      "lecturerId": lecturerId
    };
  }

}

class Assignment {
  final String id;
  final String moduleId;
  final String? moduleName;
  final String title;
  final String description;
  final DateTime dueDate;

  const Assignment({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.description,
    required this.dueDate, this.moduleName,
  });

  factory Assignment.fromJson(Map<String,dynamic> json) => Assignment(
    id: json['id'],
    moduleId: json['moduleId'],
    moduleName: json['moduleName'],
    title: json['title'],
    description: json['description'],
    dueDate: json['dueDate'],
  );

  Map<String, dynamic> toJson() {
    return {
      'moduleId': moduleId,
      'title': title,
      'description': description,
      'dueDate': dueDate,
    };
  }

}

class Attendance {
  final String id;
  final String studentId;
  final String? studentName;
  final String moduleId;
  final String? moduleName;
  final DateTime date;
  final bool? isPresent;
  final String? status;

  const Attendance({
    required this.id,
    required this.studentId,
    required this.moduleId,
    required this.date,
     this.isPresent, this.status, this.studentName, this.moduleName,
  });

  factory Attendance.fromJson(Map<String,dynamic> json) => Attendance(
    id: json['id'],
    moduleId: json['moduleId'],
    moduleName: json['moduleName'],
    studentId: json['studentId'],
    studentName: json['studentName'],
    date: json['date'],
    status: json['status'],
  );

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'moduleId': moduleId,
      'date': date,
      'status': status,
    };
  }
}

class Mark {
  final String id;
  final String studentId;
  final String? studentName;
  final String? moduleId;
  final String assignmentId;
  final String? assignmentTitle;
  final int score;
  final String? feedback;

  const Mark({
    required this.id,
    required this.studentId,
     this.moduleId,
    required this.assignmentId,
    required this.score,
     this.feedback, this.studentName, this.assignmentTitle,
  });

  factory Mark.fromJson(Map<String,dynamic> json) => Mark(
    id: json['id'],
    studentId: json['studentId'],
    studentName: json['studentName'],
    assignmentId: json['assignmentId'],
    assignmentTitle: json['assignmentTitle'],
    score: json['score'],

  );

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'assignmentId': assignmentId,
      "score": score,
    };
  }

}