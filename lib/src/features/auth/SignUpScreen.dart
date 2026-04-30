import 'package:esoft_student_app/src/features/auth/authService.dart';
import 'package:esoft_student_app/src/features/auth/loginScreen.dart';
import 'package:esoft_student_app/src/features/auth/otpScreen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreedToTerms = false;
  bool _obscurePassword = true;
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
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F5),
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
                    // Logo + Brand
                    _buildBrandHeader(),
                    const SizedBox(height: 36),

                    // Title
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D0D1A),
                        letterSpacing: -0.5,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    // const SizedBox(height: 8),
                    // const Text(
                    //   'Join the Esoft Uni digital curator\ncommunity.',
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     color: Color(0xFF8A8A9A),
                    //     height: 1.5,
                    //     fontFamily: 'Georgia',
                    //   ),
                    // ),
                    const SizedBox(height: 32),

                    // Full Name
                    _buildLabel('Full Name'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _nameController,
                      hint: 'Enter your full name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),



                    // Institutional Email
                    _buildLabel('Email'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _emailController,
                      hint: 'name@esoft.uni',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // Password
                    _buildLabel('Password'),
                    const SizedBox(height: 6),
                    _buildPasswordField(),
                    const SizedBox(height: 20),

                    // Terms Checkbox
                    _buildTermsRow(),
                    const SizedBox(height: 28),

                    // Create Account Button
                    _buildPrimaryButton(
                      label: 'CREATE ACCOUNT',
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),

                    // Already a Member
                    Center(
                      child: Text(
                        'ALREADY A USER?',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF8A8A9A),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Sign In Button (outline)
                    _buildOutlineButton(
                      label: 'SIGN IN',
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    // const SizedBox(height: 30),
                    //
                    // // Footer
                    // _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.school, size: 20, color: Colors.white),
        ),
        const SizedBox(width: 10),
        const Text(
          'Esoft UNI',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
            letterSpacing: -0.2,
          ),
        ),
      ],
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8EF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
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

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8EF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
        decoration: InputDecoration(
          hintText: 'Min. 8 characters',
          hintStyle:
          const TextStyle(fontSize: 14, color: Color(0xFFAAAAAB)),
          prefixIcon: const Icon(Icons.lock_outline,
              size: 18, color: Color(0xFFAAAAAB)),
          suffixIcon: GestureDetector(
            onTap: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            child: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 18,
              color: const Color(0xFFAAAAAB),
            ),
          ),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildTermsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: _agreedToTerms,
            onChanged: (v) => setState(() => _agreedToTerms = v!),
            activeColor: const Color(0xFF1A1A2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(color: Color(0xFFBBBBCC), width: 1.5),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF5A5A6A),
                height: 1.5,
              ),
              children: [
                TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    color: Color(0xFF3D5AFE),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Academic Integrity Policy',
                  style: TextStyle(
                    color: Color(0xFF3D5AFE),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: ' of Esoft University.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildPrimaryButton({
  //   required String label,
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       width: double.infinity,
  //       height: 52,
  //       decoration: BoxDecoration(
  //         color: const Color(0xFF1A1A2E),
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       alignment: Alignment.center,
  //       child: Text(
  //         label,
  //         style: const TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w700,
  //           color: Colors.white,
  //           letterSpacing: 1.5,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () async {
        final fullName = _nameController.text.trim();
        final email = _emailController.text.trim();
        final password = _passwordController.text;

        // Basic validation
        if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill in all fields'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (!_agreedToTerms) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please agree to the terms and conditions'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (password.length < 8) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password must be at least 8 characters'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Show loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Creating account...')),
        );

        // Attempt registration
        final authService = AuthService();
        final success = await authService.register(
          name: fullName,
          email: email,
          password: password,
        );

        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully! Please verify your email.'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to OTP screen
          Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(email: email)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration failed.'),
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
  Widget _buildOutlineButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFCCCCD6), width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Text(
        'INSTITUTIONAL PORTAL  •  SECURE AUTHENTICATION  •  ESOFT UNI © 2026',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          color: const Color(0xFFAAAAAB),
          letterSpacing: 0.8,
          height: 1.6,
        ),
      ),
    );
  }
}