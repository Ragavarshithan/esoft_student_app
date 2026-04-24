import 'package:flutter/material.dart';

class ViewEditStudentScreen extends StatefulWidget {
  final String studentName;
  final String studentEmail;
  final String course;
  final String batch;
  const ViewEditStudentScreen({super.key,required this.course, required this.batch, required this.studentName, required this.studentEmail});

  @override
  State<ViewEditStudentScreen> createState() => _ViewEditStudentScreenState();
}

class _ViewEditStudentScreenState extends State<ViewEditStudentScreen>
    with SingleTickerProviderStateMixin {
  final _studentNameController = TextEditingController();
  final _studentEmailController = TextEditingController();
  final _courseController = TextEditingController();
  final _emailController = TextEditingController();
  final _batchController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _studentNameController.text = widget.studentName;
    _studentEmailController.text = widget.studentEmail;
    _courseController.text = widget.course;
    _batchController.text = widget.batch;
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
    _studentNameController.dispose();
    _studentEmailController.dispose();
    _courseController.dispose();
    _emailController.dispose();
    _batchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View/Edit Student Profile'),
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
                        '${widget.studentName}',
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
                      controller: _studentNameController,
                      hint: 'Enter student full name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
                    _buildLabel('Student Email'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _studentEmailController,
                      hint: 'name@gmail.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    _buildLabel('Course'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _courseController,
                      icon: Icons.book,
                      readOnly: true,
                      hint: '',
                    ),
                    const SizedBox(height: 20),

                    // Password
                    _buildLabel('Batch'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _batchController,
                      icon: Icons.badge_outlined,
                      readOnly: true,
                      hint: '',
                    ),
                    const SizedBox(height: 30),

                    _buildPrimaryButton(
                      label: 'UPDATE STUDENT',
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    _buildPrimaryButton(
                      label: 'REMOVE STUDENT',
                      onTap: () {},
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
      onTap: () async {
        final fullName = _studentNameController.text.trim();
        final course = _courseController.text.trim();
        final email = _emailController.text.trim();
        final batch = _batchController.text;

        // Basic validation
        if (fullName.isEmpty ||
            course.isEmpty ||
            email.isEmpty ||
            batch.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill in all fields'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Show loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Creating student profile...')),
        );




      },
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