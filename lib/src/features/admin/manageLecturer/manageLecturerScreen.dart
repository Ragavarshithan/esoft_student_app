import 'package:esoft_student_app/src/features/admin/manageLecturer/addLecturerScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageLecturer/viewEditLecturerScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageStudent/manage_students_screen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/models/user.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../services/mock_data_service.dart';

class ManageLecturerScreen extends ConsumerStatefulWidget {
  const ManageLecturerScreen({super.key});

  @override
  ConsumerState<ManageLecturerScreen> createState() => _ManageLecturerScreen();
}

class _ManageLecturerScreen extends ConsumerState<ManageLecturerScreen> {
  final LMSService _lmsService = LMSService();
  List<Lecturer> _lecturers = [];

  @override
  void initState() {
    super.initState();
    _loadLecturers();
  }

  Future<void> _loadLecturers() async {
    final lecturers = await _lmsService.getAllLecturers();
    setState(() {
      _lecturers = lecturers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final lecturers = mockService.users.whereType<Lecturer>().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecturers'),
      ),
      body: _lecturers.isEmpty
          ? const Center(child: Text('No lecturers found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _lecturers.length,
        itemBuilder: (context, index) {
          final lecturer = _lecturers[index];

          return InkWell(
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1E3A8A),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(lecturer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ViewEditLecturerScreen(lecturerId: lecturer.lecturerId,userId: lecturer.id, )));
                    if(result == true){
                      _loadLecturers();
                    }
                    },
                ),
              ),
            ),
            onTap: () {

            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
        final result = Navigator.push(context, MaterialPageRoute(builder: (context) => AddLecturerScreen()));
        if(result == true){
          _loadLecturers();
        }
        },
      ),
    );
  }
}
