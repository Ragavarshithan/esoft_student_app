import 'package:esoft_student_app/src/features/admin/adminRoot.dart';
import 'package:esoft_student_app/src/features/admin/manageAssignment/manageAssignmentScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageBatch/manageBatch.dart';
import 'package:esoft_student_app/src/features/admin/manageCourse/manageCourseScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageLecturer/manageLecturerScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageStudent/selectCourseScreen.dart';
import 'package:esoft_student_app/src/features/auth/splashScreen.dart';
import 'package:esoft_student_app/src/features/lecturer/myCoursesScreen.dart';
import 'package:esoft_student_app/src/features/lecturer/myStudentsScreen.dart';
import 'package:esoft_student_app/src/features/student/myAssignmentsScreen.dart';
import 'package:esoft_student_app/src/features/student/myAttendanceScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/landingScreen.dart';
import '../features/admin/admin_dashboard.dart';
import '../features/admin/manageStudent/manage_students_screen.dart';
import '../features/student/student_dashboard.dart';
import '../features/student/my_marks_screen.dart';
import '../features/lecturer/lecturer_dashboard.dart';
import '../features/chat/chat_screen.dart';
import '../models/user.dart';
import '../services/mock_data_service.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final user = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = user != null;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
        switch (user.role) {
          case UserRole.admin:
            return '/admin';
          case UserRole.student:
            return '/student';
          case UserRole.lecturer:
            return '/lecturer';
        }
      }

      return null; // No redirect
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminRoot(),
      ),
      GoRoute(
        path: '/admin/students/course',
        builder: (context, state) => const Selectcoursescreen(),
      ),
      GoRoute(
        path: '/admin/batch',
        builder: (context, state) => const ManagebatchScreen(),
      ),
      GoRoute(
        path: '/admin/lecturer',
        builder: (context, state) => const ManageLecturerScreen(),
      ),
      GoRoute(
        path: '/admin/course',
        builder: (context, state) => const ManageCourseScreen(),
      ),
      GoRoute(
        path: '/admin/assignment',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/student',
        builder: (context, state) => const StudentDashboard(),
      ),
      GoRoute(
        path: '/student/marks',
        builder: (context, state) => const MyMarksScreen(),
      ),
      GoRoute(
        path: '/student/attendance',
        builder: (context, state) => const MyAttendanceScreen(),
      ),
      GoRoute(
        path: '/student/assignments',
        builder: (context, state) => const MyAssignmentsScreen(),
      ),
      GoRoute(
        path: '/lecturer',
        builder: (context, state) => const LecturerDashboard(),
      ),
      GoRoute(
        path: '/lecturer/courses',
        builder: (context, state) => const MyCourseScreen(),
      ),
      GoRoute(
        path: '/lecturer/students',
        builder: (context, state) => const MyStudentsScreen(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const ChatScreen(),
      ),
    ],
  );
});
