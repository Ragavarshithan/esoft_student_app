class Mark {
  final String id;
  final String studentId;
  final String courseId;
  final String assignmentId;
  final int score;
  final String feedback;

  const Mark({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.assignmentId,
    required this.score,
    this.feedback = '',
  });
}

class Attendance {
  final String id;
  final String studentId;
  final String courseId;
  final DateTime date;
  final bool isPresent;

  const Attendance({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.date,
    required this.isPresent,
  });
}

class ClassActivity {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final DateTime date;

  const ClassActivity({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.date,
  });
}
