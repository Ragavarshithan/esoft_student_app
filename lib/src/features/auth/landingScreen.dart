import 'package:esoft_student_app/src/features/auth/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/mock_data_service.dart';

class Landingscreen extends ConsumerWidget {
  const Landingscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school, size: 100, color: Color(0xFF0A1F44)),
              const SizedBox(height: 24),
              Text(
                'Esoft Uni Performance',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0A1F44),
                    ),
              ),
              const SizedBox(height: 48),
              _LoginButton(
                title: 'Login as Admin',
                icon: Icons.admin_panel_settings,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(userRole: "admin",))),
              ),
              const SizedBox(height: 16),
              _LoginButton(
                title: 'Login as Student',
                icon: Icons.person,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(userRole: "student",))),
              ),
              const SizedBox(height: 16),
              _LoginButton(
                title: 'Login as Lecturer',
                icon: Icons.school_outlined,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(userRole: "lecturer",))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login(WidgetRef ref, String role) {
    final mockService = ref.read(mockDataServiceProvider);
    final user = mockService.login(role);
    ref.read(currentUserProvider.notifier).setUser(user);
  }
}

class _LoginButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const _LoginButton({
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(title, style: const TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A1F44),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
