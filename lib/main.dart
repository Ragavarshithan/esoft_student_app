import 'package:esoft_student_app/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart'; // Uncomment after running flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (Using manual setup)
  await Firebase.initializeApp();

  // Initialize Supabase. Replace with actual URL and Anon Key when ready.
  // Uncomment and populate this when Supabase project is created:
  /*
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  */

  runApp(const ProviderScope(child: EsoftStudentApp()));
}

class EsoftStudentApp extends ConsumerWidget {
  const EsoftStudentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Esoft Uni',
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
    );
  }
}
