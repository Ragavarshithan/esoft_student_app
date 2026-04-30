import 'package:esoft_student_app/src/models/user.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';

class AddLecturerScreen extends StatefulWidget {
  const AddLecturerScreen({super.key});

  @override
  State<AddLecturerScreen> createState() => _AddLecturerScreenState();
}

class _AddLecturerScreenState extends State<AddLecturerScreen>
    with SingleTickerProviderStateMixin {
  final _lecturerNameController = TextEditingController();
  final _lecturerEmailController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
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
    _lecturerNameController.dispose();
    _lecturerEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Lecturer'),
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
                      'Create Lecturer Profile',
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

                    const SizedBox(height: 30),

                    _buildPrimaryButton(
                      label: 'CREATE LECTURER',
                      onTap: () {},
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
  }) {
    return GestureDetector(
      onTap: () async {
        final fullName = _lecturerNameController.text.trim();
        final email = _lecturerEmailController.text.trim();

        // Basic validation
        if (fullName.isEmpty ||
            email.isEmpty ) {
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
          const SnackBar(content: Text('Creating lecturer profile...')),
        );
        final success = await LMSService().createUser(
          name: fullName,
          email: email,
          role: UserRole.lecturer,
        );

        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (success == "user created successfully") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('lecturer created successfully!'),
              backgroundColor: Colors.green,
            ),
          );


          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create lecturer. Please try again.'),
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