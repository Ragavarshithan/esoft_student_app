class Batch {
  final String id;
  final String? courseId;
  final String name; 
  final String year;

  const Batch({
    required this.id,
    this.courseId,
    required this.name,
    required this.year,
  });

  Map<String,dynamic> toJson() => {
    'name': name,
    'year': year,
  };

  factory Batch.fromJson(Map<String,dynamic> json) => Batch(
    id: json['id'],
    name: json['name'],
    year: json['year'],
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

class Module {
  final String id;
  final String courseId;
  final String name;
  final String lecturerId;

  const Module({
    required this.id,
    required this.courseId,
    required this.name,
    required this.lecturerId,
  });
}

class Assignment {
  final String id;
  final String moduleId;
  final String title;
  final String description;
  final DateTime dueDate;

  const Assignment({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.description,
    required this.dueDate,
  });
}

class Attendance {
  final String id;
  final String studentId;
  final String moduleId;
  final DateTime date;
  final bool isPresent;

  const Attendance({
    required this.id,
    required this.studentId,
    required this.moduleId,
    required this.date,
    required this.isPresent,
  });
}

class Mark {
  final String id;
  final String studentId;
  final String moduleId;
  final String assignmentId;
  final double score;
  final String feedback;

  const Mark({
    required this.id,
    required this.studentId,
    required this.moduleId,
    required this.assignmentId,
    required this.score,
    required this.feedback,
  });
}