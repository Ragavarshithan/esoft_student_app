import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';

class ViewEditAssignmentScreen extends StatefulWidget {
  final String assignmentTitle;
  final DateTime dueDate;
  final String description;
  final String course;
  final String moduleId;
  final String module;
  final String assignmentId;
  const ViewEditAssignmentScreen({super.key, required this.course, required this.module, required this.assignmentTitle, required this.dueDate, required this.description, required this.moduleId, required this.assignmentId});

  @override
  State<ViewEditAssignmentScreen> createState() => _ViewEditAssignmentScreenState();
}

class _ViewEditAssignmentScreenState extends State<ViewEditAssignmentScreen> {
  final _lmsService = LMSService();

  final _assignmentTitleController = TextEditingController();
  final _courseController = TextEditingController();
  final _moduleController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _assignmentTitleController.text = widget.assignmentTitle;
    _courseController.text = widget.course;
    _moduleController.text = widget.module;
    _dueDateController.text =
    "${widget.dueDate.day}/${widget.dueDate.month}/${widget.dueDate.year}";
    _descriptionController.text = widget.description;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "View/Edit Assignment",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [




            const SizedBox(height: 20),

            /// Assignment Title
            _buildLabel("Assignment Title"),
            _buildInput(
                hint: "e.g. Advanced Macroeconomics Research",
                controller: _assignmentTitleController
            ),

            /// Course
            _buildLabel("Course"),
            _buildInput(
                readOnly: true,
                hint: "",
                controller: _courseController
            ),

            /// Module
            _buildLabel("Module"),
            _buildInput(
                readOnly: true,
                hint: "",
                controller: _moduleController
            ),

            /// Date
            _buildLabel("Due Date"),
            _buildDateField(
                context,
                _dueDateController
            ),

            /// Description
            _buildLabel("Assignment Description"),
            _buildInput(
              hint: "Outline the learning objectives and submission requirements...",
              controller: _descriptionController,
              maxLines: 4,
            ),

            const SizedBox(height: 30),

            _buildPrimaryButton(
              label: 'UPDATE ASSIGNMENT',
              onTap: () async{
                final name = _assignmentTitleController.text.trim();
                final description = _descriptionController.text;
                final dueDate = _dueDateController.text;
                final moduleId = widget.moduleId;
                final assignmentId = widget.assignmentId;


                if (name.isEmpty ||
                    description.isEmpty ||
                    moduleId.isEmpty || dueDate.isEmpty ) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                final success = await _lmsService.updateAssignment(
                    assignmentId, name, description, _parseDate(dueDate), moduleId);

                if (await success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Assignment updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to update Assignment. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),

            _buildPrimaryButton(
              label: 'REMOVE ASSIGNMENT',
              onTap: () async {
                final success = _lmsService.deleteAssignment(widget.assignmentId);
                if (await success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Assignment deleted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to delete Assignment. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              color: Colors.red.shade500,
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
  DateTime _parseDate(String date) {
    try {
      // Try standard ISO format first (yyyy-MM-dd)
      return DateTime.parse(date);
    } catch (_) {
      // Handle dd/M/yyyy or dd/MM/yyyy
      final parts = date.split('/');
      return DateTime(
        int.parse(parts[2]), // year
        int.parse(parts[1]), // month
        int.parse(parts[0]), // day
      );
    }
  }
  /// TEXT INPUT
  Widget _buildInput({required String hint, int maxLines = 1, required TextEditingController controller, bool readOnly = false}) {
    return TextField(
      controller: controller,
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
    Color color =  const Color(0xFF1A1A2E),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: color,
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