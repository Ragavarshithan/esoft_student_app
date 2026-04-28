import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/models/user.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';

class ViewEditLecturerScreen extends StatefulWidget {
  final String userId;
  final String lecturerId;
  const ViewEditLecturerScreen({super.key,required this.lecturerId, required this.userId});

  @override
  State<ViewEditLecturerScreen> createState() => _ViewEditLecturerScreenState();
}

class _ViewEditLecturerScreenState extends State<ViewEditLecturerScreen>
    with SingleTickerProviderStateMixin {
  final LMSService _lmsService = LMSService();

  final _lecturerNameController = TextEditingController();
  final _lecturerEmailController = TextEditingController();
  final _moduleController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _loadLecturerDetails();
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

  Future<void> _loadLecturerDetails() async {
    final lecturer = await _lmsService.getLecturerById(widget.userId);
    setState(() {
      _lecturerNameController.text = lecturer!.name;
      _lecturerEmailController.text = lecturer.email;
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _lecturerNameController.dispose();
    _lecturerEmailController.dispose();
    _moduleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View/Edit lecturer Profile'),
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
                     Center(
                       child: Text(
                        '${_lecturerNameController.text}',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D0D1A),
                          letterSpacing: -0.5,
                          fontFamily: 'Georgia',
                        ),
                                           ),
                     ),
                    const SizedBox(height: 32),
                    // Full Name
                    _buildLabel('Full Name'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _lecturerNameController,
                      hint: 'Enter lecturer full name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
                    _buildLabel('Lecturer Email'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _lecturerEmailController,
                      hint: 'name@gmail.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    _buildLabel('Module'),
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   padding: const EdgeInsets.all(8),
                    //   itemCount: widget.moduleIds?.length ?? 0,
                    //   itemBuilder: (context, index) {
                    //     final module = widget.moduleIds![index];
                    //
                    //     return Card(
                    //       margin: const EdgeInsets.only(bottom: 12),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(12),
                    //         child: Text(module),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // const SizedBox(height: 6),
                    // _buildTextField(
                    //   controller: _moduleController,
                    //   icon: Icons.book,
                    //   readOnly: true,
                    //   hint: '',
                    // ),
                    const SizedBox(height: 30),

                    _buildPrimaryButton(
                      label: 'UPDATE Lecturer',
                      onTap: () async {
                        final success = _lmsService.updateLecturer(
                            lecturerId: widget.lecturerId,userId: widget.userId, name: _lecturerNameController.text, email: _lecturerEmailController.text
                        );
                        if (await success) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('lecturer updated successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to update lecturer. Please try again.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildPrimaryButton(
                      label: 'REMOVE Lecturer',
                      onTap: () async {
                        final success = _lmsService.deleteLecturer(widget.userId);
                        if (await success) {
                          Navigator.pop(context);
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
                      color: Colors.red.shade500,
                    ),
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