import 'package:esoft_student_app/src/features/admin/adminRoot.dart';
import 'package:esoft_student_app/src/features/auth/SignUpScreen.dart';
import 'package:esoft_student_app/src/features/auth/authService.dart';
import 'package:esoft_student_app/src/features/lecturer/lecturer_dashboard.dart';
import 'package:esoft_student_app/src/features/student/student_dashboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final String userRole;
  const LoginScreen({Key? key, required this.userRole}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
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
          // Header with logo
          _buildHeader(),
          const SizedBox(height: 32),

          // Email field
          _buildEmailField(),
          const SizedBox(height: 20),

          // Password field
          _buildPasswordField(),
          const SizedBox(height: 16),

          // Remember device checkbox
          _buildRememberDeviceCheckbox(),
          const SizedBox(height: 24),

          // Sign in button
          _buildSignInButton(),
          const SizedBox(height: 24),

          // Account creation link
          _buildAccountCreationLink(),
          // const SizedBox(height: 32),
          //
          // // Social icons placeholder
          // _buildSocialIcons(),
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
        const SizedBox(height: 16),
        const Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Please enter your credentials to access the portal.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'INSTITUTIONAL EMAIL',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'name@esoft.edu',
            hintStyle: const TextStyle(
              color: Color(0xFFB0B0B0),
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.mail_outline_rounded,
              color: Color(0xFF999999),
              size: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF001F3F),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'PASSWORD',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: Color(0xFF666666),
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'FORGOT PASSWORD?',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0066CC),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: passwordController,
          obscureText: !passwordVisible,
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: const TextStyle(
              color: Color(0xFFB0B0B0),
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: Color(0xFF999999),
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                passwordVisible
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: const Color(0xFF999999),
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF001F3F),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 0,
            ),
          ),
        ),
      ],
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

  // Widget _buildSignInButton() {
  //   return ElevatedButton(
  //     onPressed: () {
  //       // Handle sign in
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Signing in...')),
  //       );
  //     },
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: const Color(0xFF001F3F),
  //       foregroundColor: Colors.white,
  //       padding: const EdgeInsets.symmetric(vertical: 16),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       elevation: 2,
  //     ),
  //     child: const Text(
  //       'SIGN IN',
  //       style: TextStyle(
  //         fontSize: 16,
  //         fontWeight: FontWeight.w600,
  //         letterSpacing: 0.5,
  //       ),
  //     ),
  //   );
  // }

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
              content: Text('Welcome back, ${authService.currentUser!.fullName}!'),
              backgroundColor: Colors.green,
            ),
          );
          if (widget.userRole == "admin" ){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminRoot()));
          } else if (widget.userRole == "student") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentDashboard()));
          }else if (widget.userRole == "lecturer") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LecturerDashboard()));
          }
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

  Widget _buildAccountCreationLink() {
    return InkWell(
      child: Center(
        child: RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'New to Esoft Unit? ',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              TextSpan(
                text: 'Create an Account',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0066CC),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen(userRole: widget.userRole,)))
    );
  }

  Widget _buildSocialIcons() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
              (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(8),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}