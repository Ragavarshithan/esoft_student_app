import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/models/user.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';

class NewAttendanceScreen extends StatefulWidget {
  final String courseId;
  final String courseName;
  final String moduleId;
  final String moduleName;

  const NewAttendanceScreen({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.moduleId,
    required this.moduleName,
  });

  @override
  State<NewAttendanceScreen> createState() => _NewAttendanceScreenState();
}

class _NewAttendanceScreenState extends State<NewAttendanceScreen> {
  final LMSService _lmsService = LMSService();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  
  List<Batch> _batches = [];
  String? _selectedBatchId;
  List<Student> _students = [];
  Map<String, bool?> _attendanceStatus = {};
  bool _isLoadingBatches = true;
  bool _isLoadingStudents = false;

  @override
  void initState() {
    super.initState();
    _loadBatches();
  }

  Future<void> _loadBatches() async {
    final batches = await _lmsService.getBatchByCourseId(courseId: widget.courseId);
    if (mounted) {
      setState(() {
        _batches = batches;
        _isLoadingBatches = false;
      });
    }
  }

  Future<void> _loadStudents(String batchId) async {
    setState(() {
      _isLoadingStudents = true;
      _students = [];
      _attendanceStatus = {};
    });

    final students = await _lmsService.getStudentsByBatchId(batchId: batchId);
    if (mounted) {
      setState(() {
        _students = students;
        for (var student in students) {
          _attendanceStatus[student.id] = null;
        }
        _isLoadingStudents = false;
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E3A8A),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E3A8A),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  String _formatDate(DateTime date) {
    const days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return "${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}";
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  Future<void> markAllPresent() async {
    for (var student in _students) {
      if (_attendanceStatus[student.studentId] != true) {
        setState(() {
          _attendanceStatus[student.studentId] = true;
        });
        await _lmsService.markAttendance(
          studentId: student.studentId,
          moduleId: widget.moduleId,
          date: _selectedDate,
          status: 'PRESENT',
        );
      }
    }
  }

  Future<void> setAttendance(String studentId, bool value) async {
    setState(() {
      _attendanceStatus[studentId] = value;
    });
    
    final success = await _lmsService.markAttendance(
      studentId: studentId,
      moduleId: widget.moduleId,
      date: _selectedDate,
      status: value ? 'PRESENT' : 'ABSENT',
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update attendance')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("New Attendance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "ATTENDANCE REGISTRY",
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.moduleName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.courseName,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            /// Batch Dropdown
            _isLoadingBatches
                ? const LinearProgressIndicator()
                : Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: const Text("Select Batch"),
                  isExpanded: true,
                  value: _selectedBatchId,
                  items: _batches.map((batch) {
                    return DropdownMenuItem(
                      value: batch.id,
                      child: Text(batch.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedBatchId = value);
                      _loadStudents(value);
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Date + Time
            Row(
              children: [
                _tappableChip(
                  icon: Icons.calendar_today,
                  text: _formatDate(_selectedDate),
                  onTap: _pickDate,
                ),
                const SizedBox(width: 10),
                _tappableChip(
                  icon: Icons.access_time,
                  text: _formatTime(_selectedTime),
                  onTap: _pickTime,
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Student Roll (${_students.length})",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (_students.isNotEmpty)
                  TextButton(
                    onPressed: markAllPresent,
                    child: const Text("MARK ALL PRESENT"),
                  )
              ],
            ),

            const SizedBox(height: 10),

            /// List
            Expanded(
              child: _isLoadingStudents
                  ? const Center(child: CircularProgressIndicator())
                  : _students.isEmpty
                  ? Center(child: Text(_selectedBatchId == null ? "Select a batch to see students" : "No students found in this batch"))
                  : ListView.builder(
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  final student = _students[index];
                  final status = _attendanceStatus[student.id];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),

                        /// Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                student.email,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),

                        /// Actions
                        Row(
                          children: [
                            _statusButton(
                              icon: Icons.check,
                              color: Colors.green,
                              active: status == true,
                              onTap: () => setAttendance(student.studentId, true),
                            ),
                            const SizedBox(width: 8),
                            _statusButton(
                              icon: Icons.close,
                              color: Colors.red,
                              active: status == false,
                              onTap: () => setAttendance(student.studentId, false),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),

            /// Done Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("DONE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _tappableChip({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A8A).withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1E3A8A).withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF1E3A8A)),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(fontSize: 12, color: Color(0xFF1E3A8A), fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.edit, size: 11, color: Color(0xFF1E3A8A)),
          ],
        ),
      ),
    );
  }

  Widget _statusButton({
    required IconData icon,
    required Color color,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.2) : Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(icon,
            size: 18, color: active ? color : Colors.grey.shade600),
      ),
    );
  }
}