class Batch {
  final String id;
  final String name; 
  final String year;

  const Batch({
    required this.id,
    required this.name,
    required this.year,
  });
}

class Course {
  final String id;
  final String name;
  final String description;
  final String lecturerId;
  final String batchId;

  const Course({
    required this.id,
    required this.name,
    required this.description,
    required this.lecturerId,
    required this.batchId,
  });
}

class Assignment {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final DateTime dueDate;

  const Assignment({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.dueDate,
  });
}
