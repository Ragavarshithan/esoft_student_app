import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';

class newModuleScreen extends StatefulWidget {
  final String courseId;
  final String courseName;
  const newModuleScreen({super.key,required this.courseId, required this.courseName});

  @override
  State<newModuleScreen> createState() => _newModuleScreenState();
}

class _newModuleScreenState extends State<newModuleScreen> {
  final LMSService _lmsService = LMSService();
  final _moduleTitleController = TextEditingController();
  final _courseNameController = TextEditingController();
  final _creditsController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _courseNameController.text = widget.courseName!;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "New Module",
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
              "Create New Module",
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
            _buildLabel("New Module Title"),
            _buildInput(
              hint: "e.g. solid principles",
              controller: _moduleTitleController
            ),

            /// Module
            _buildLabel("Course"),
            _buildInput(
                hint: "",
                controller: _courseNameController,
                readOnly: true
            ),

            /// Course
            _buildLabel("Credits"),
            _buildInput(
                hint: "",
                controller: _creditsController,
                textinputtype: TextInputType.number
            ),






            const SizedBox(height: 30),

            _buildPrimaryButton(
              label: 'CREATE MODULE',
              onTap: () async{
                final name = _moduleTitleController.text.trim();
                final courseId = widget.courseId;
                final lecturerId = "";

                if (name.isEmpty ||
                    courseId.isEmpty ||
                    lecturerId.isEmpty ) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                final success = await _lmsService.createModule(
                    name: name, courseId: courseId,
                    lecturerId: lecturerId);

                if (await success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('module created successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to create module. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
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


  /// DATE FIELD
  Widget _buildDateField(BuildContext context, TextEditingController dateController) {
    return TextField(
      readOnly: true,
      controller: dateController,
      decoration: InputDecoration(
        hintText: "Select Date",
        prefixIcon: const Icon(Icons.calendar_today, size: 18),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          dateController.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
        }
      },
    );
  }


  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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