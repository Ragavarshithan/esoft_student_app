import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';


class newCourseScreen extends StatefulWidget {
  const newCourseScreen({super.key});

  @override
  State<newCourseScreen> createState() => _newCourseScreenState();
}

class _newCourseScreenState extends State<newCourseScreen> {

  final _courseTitleController = TextEditingController();
  final _moduleController = TextEditingController();
  final _courseDurationController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "New Course",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TITLE
            const Text(
              "Create New Course",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Container(
              width: 40,
              height: 4,
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            /// Assignment Title
            _buildLabel("New Course Title"),
            _buildInput(
              hint: "e.g. Software Engineering",
              controller: _courseTitleController
            ),

            /// Course
            _buildLabel("Duration"),
            _buildInput(
                hint: "",
                controller: _courseDurationController,
                textinputtype: TextInputType.number
            ),


            _buildLabel("Course Description"),
            _buildInput(
              hint: "create course description...",
              controller: _descriptionController,
              maxLines: 4,
            ),

            const SizedBox(height: 30),

            _buildPrimaryButton(
              label: 'CREATE COURSE',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  /// LABEL
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 12),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 13,
        ),
      ),
    );
  }

  /// TEXT INPUT
  Widget _buildInput({required String hint, int maxLines = 1, required TextEditingController controller, bool readOnly = false, TextInputType textinputtype = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: textinputtype,
      readOnly: readOnly,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }





  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () async {
        final courseName = _courseTitleController.text.trim();
        final description = _descriptionController.text.trim();

        // Basic validation
        if (courseName.isEmpty || description.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter both course title and description'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Show loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Creating course...')),
        );

        final success = await LMSService().createCourse(
          name: courseName,
          description: description,
        );

        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Course created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Clear inputs
          _courseTitleController.clear();
          _descriptionController.clear();
          _moduleController.clear();
          _courseDurationController.clear();

          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create course. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }


}