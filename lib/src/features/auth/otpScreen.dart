import 'package:esoft_student_app/src/features/admin/adminRoot.dart';
import 'package:esoft_student_app/src/features/auth/SignUpScreen.dart';
import 'package:esoft_student_app/src/features/auth/authService.dart';
import 'package:esoft_student_app/src/features/lecturer/lecturer_dashboard.dart';
import 'package:esoft_student_app/src/features/student/student_dashboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController pinController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late AnimationController _animationController;
  bool rememberDevice = false;
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    pinController = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF5F5F5),
              const Color(0xFFEEEEEE),
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
                  child: _buildLoginCard(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
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
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ONE-TIME PASSWORD',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF666666),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('RESEND CODE'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
          _otpField(),
          const SizedBox(height: 20),
          // Remember device checkbox
          _buildRememberDeviceCheckbox(),
          const SizedBox(height: 24),

          // Sign in button
          _buildSignInButton(),
          const SizedBox(height: 24),
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
            color: const Color(0xFF001F3F),
            borderRadius: BorderRadius.circular(8),
          ),
          child:const Icon(Icons.school, size: 28, color: Colors.white),
        ),
        const SizedBox(height: 16),
        const Text(
          'Esoft UNI',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }


  Widget _otpField() {
    return Pinput(
      controller: pinController,
      keyboardType: TextInputType.number,
      length: 4,
      separatorBuilder: (index) => const SizedBox(width: 10),
      defaultPinTheme: PinTheme(
        width: 55,
        height: 55,
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFEDEDED),
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      hapticFeedbackType: HapticFeedbackType.lightImpact,

      onCompleted: (pin) {
        debugPrint('OTP: $pin');
      },

      onChanged: (value) {
        debugPrint('Typing: $value');
      },
    );
  }

  Widget _buildRememberDeviceCheckbox() {
    return SizedBox(
      height: 24,
      child: CheckboxListTile(
        value: rememberDevice,
        onChanged: (value) {
          setState(() {
            rememberDevice = value ?? false;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        title: const Text(
          'Remember this device',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
            fontWeight: FontWeight.w500,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }



  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: () async {
        final email = emailController.text.trim();
        final password = passwordController.text;

        // Basic validation
        if (email.isEmpty || password.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter both email and password'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signing in...')),
        );

        // Attempt login
        final authService = AuthService();
        final success = await authService.login(
          email: email,
          password: password,
        );

        if (success) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome back, ${authService.currentUser!.name}!'),
              backgroundColor: Colors.green,
            ),
          );
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminRoot()));
          // Navigate to home screen or dashboard
          // Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF001F3F),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
      child: const Text(
        'SIGN IN',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }


}