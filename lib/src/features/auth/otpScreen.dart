import 'package:esoft_student_app/src/features/admin/adminRoot.dart';
import 'package:esoft_student_app/src/features/auth/SignUpScreen.dart';
import 'package:esoft_student_app/src/features/auth/authService.dart';
import 'package:esoft_student_app/src/features/lecturer/lecturer_dashboard.dart';
import 'package:esoft_student_app/src/features/student/student_dashboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'loginScreen.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController pinController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    pinController = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    pinController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF5F5F5),
              Color(0xFFEEEEEE),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeOut,
                  ),
                ),
                child: FadeTransition(
                  opacity: _animationController,
                  child: _buildOtpCard(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Text(
            'We have sent a verification code to:',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          Text(
            widget.email,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 30),
          _otpField(),
          const SizedBox(height: 30),
          _buildVerifyButton(),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to Sign Up'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.mark_email_read_outlined, size: 28, color: Colors.white),
        ),
        const SizedBox(height: 16),
        const Text(
          'Verify OTP',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }

  Widget _otpField() {
    return Pinput(
      controller: pinController,
      keyboardType: TextInputType.number,
      length: 6, // Changed to 6 as it's common, but keep 4 if backend says 4
      separatorBuilder: (index) => const SizedBox(width: 8),
      defaultPinTheme: PinTheme(
        width: 45,
        height: 55,
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return ElevatedButton(
      onPressed: () async {
        final otp = pinController.text.trim();
        if (otp.length < 4) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a valid OTP')),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verifying...')),
        );

        final authService = AuthService();
        final success = await authService.verifyOtp(
          email: widget.email,
          otp: otp,
        );

        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verification successful! You can now sign in.'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to Login Screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid OTP. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text('VERIFY OTP', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
    );
  }
}