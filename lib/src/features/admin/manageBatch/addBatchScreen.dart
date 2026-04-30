import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';

class AddBatchScreen extends StatefulWidget {
  final String courseId;
  final String courseName;
  const AddBatchScreen({super.key, required this.courseId, required this.courseName});

  @override
  State<AddBatchScreen> createState() => _AddBatchScreenState();
}

class _AddBatchScreenState extends State<AddBatchScreen>
    with SingleTickerProviderStateMixin {
  final _newBatchNameController = TextEditingController();
  final _courseNameController = TextEditingController();
  final _yearController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _courseNameController.text = widget.courseName;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _newBatchNameController.dispose();
    _courseNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Batch'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 48),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Create New Batch',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D0D1A),
                        letterSpacing: -0.5,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Full Name
                    _buildLabel('New Batch Name'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _newBatchNameController,
                      hint: 'Enter batch name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
                    _buildLabel('Course'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _courseNameController,
                      hint: '',
                      icon: Icons.book,
                      readOnly: true,
                    ),

                    const SizedBox(height: 20),
                    _buildLabel('year'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _yearController,
                      hint: '',
                      icon: Icons.book,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 30),

                    _buildPrimaryButton(
                      label: 'CREATE BATCH',
                      onTap: () async {
                        final batchName = _newBatchNameController.text.trim();
                        final courseId = widget.courseId;
                        final year = _yearController.text.trim();

                        if (batchName.isEmpty || year.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please enter both course title and description'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Creating batch...')),
                        );

                        final success = await LMSService().createBatch(
                          name: batchName,
                          year: int.parse(year),
                          courseId: courseId,
                        );
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Batch created successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          // Clear inputs
                          _newBatchNameController.clear();
                          _yearController.clear();
                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Failed to create batch. Please try again.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF3A3A4A),
        letterSpacing: 0.1,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8EF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
          const TextStyle(fontSize: 14, color: Color(0xFFAAAAAB)),
          prefixIcon: Icon(icon, size: 18, color: const Color(0xFFAAAAAB)),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
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