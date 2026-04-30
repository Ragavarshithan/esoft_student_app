import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/models/user.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';

class ViewEditModuleScreen extends StatefulWidget {
  final Module moduleData;
  const ViewEditModuleScreen({super.key ,required this.moduleData});

  @override
  State<ViewEditModuleScreen> createState() => _ViewEditModuleScreenState();
}

class _ViewEditModuleScreenState extends State<ViewEditModuleScreen> {
  final _lmsService = LMSService();

  final _moduleTitleController = TextEditingController();
  final _courseNameController = TextEditingController();
  final _creditsController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<Lecturer> _lecturers = [];
  String? _selectedLecturerId;
  bool _isLoadingLecturers = false;

  @override
  void initState() {
    super.initState();
    _moduleTitleController.text = widget.moduleData.name;
    _creditsController.text = 2.5.toString();
    _descriptionController.text = widget.moduleData.name;
    _courseNameController.text = widget.moduleData.courseName!;
    _selectedLecturerId = widget.moduleData.lecturerId;
    
    // Initialize with current lecturer info to show immediately
    _lecturers = [
      Lecturer(
        id: widget.moduleData.lecturerId, 
        name: widget.moduleData.lecturerName ?? 'Unknown Lecturer', 
        email: '', 
        lecturerId: '' 
      )
    ];

    _loadLecturers();
  }

  Future<void> _loadLecturers() async {
    try {
      final lecturers = await _lmsService.getAllLecturers();
      setState(() {
        _lecturers = lecturers;
        
        // If the current lecturer isn't in the fetched list, add them back
        // to prevent DropdownButton crash and ensure they are displayed.
        if (_selectedLecturerId != null && 
            !_lecturers.any((l) => l.id == _selectedLecturerId)) {
          _lecturers.insert(0, Lecturer(
            id: widget.moduleData.lecturerId,
            name: widget.moduleData.lecturerName ?? 'Unknown Lecturer',
            email: '',
            lecturerId: '',
          ));
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingLecturers = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load lecturers')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "View/Edit Module",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TITLE
             Text(
              "${widget.moduleData.name}",
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
            _buildLabel("Module Title"),
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

            /// Lecturer
            _buildLabel("Lecturer"),
            _isLoadingLecturers
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedLecturerId,
                        hint: const Text("Select Lecturer"),
                        isExpanded: true,
                        items: _lecturers.map((lecturer) {
                          return DropdownMenuItem<String>(
                            value: lecturer.id,
                            child: Text(lecturer.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLecturerId = value;
                          });
                        },
                      ),
                    ),
                  ),



            const SizedBox(height: 30),

            _buildPrimaryButton(
              label: 'UPDATE MODULE',
              onTap: () async {
                if(
                  _moduleTitleController.text.isEmpty ||
                  _courseNameController.text.isEmpty ||
                  _creditsController.text.isEmpty ||
                      _selectedLecturerId!.isEmpty ||
                  _descriptionController.text.isEmpty
                ){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields'),
                      backgroundColor: Colors.red,
                    ),

                  );
                  return;
                }
                final success = await _lmsService.updateModule(
                  moduleId: widget.moduleData.id,
                  name: _moduleTitleController.text,
                  courseId: widget.moduleData.courseId,
                 lecturerId: _selectedLecturerId ?? widget.moduleData.lecturerId
                );
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('module updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context, true);
                } else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to update module. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 20),

            _buildPrimaryButton(
              label: 'REMOVE MODULE',
              color: Colors.red,
              onTap: () async {
                final success = _lmsService.deleteModule(widget.moduleData.id);
                if (await success) {
                  Navigator.pop(context, true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('lecturer deleted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to delete lecturer. Please try again.'),
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





  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onTap,
    Color color = const Color(0xFF1A1A2E),
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