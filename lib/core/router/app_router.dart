import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../src/features/auth/landingScreen.dart';


// Global Key for navigator
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  // In Phase 2, we will watch the auth state here for redirects
  
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const Landingscreen(),
      ),
      // Future routes will be added here
    ],
    // redirect: (context, state) {
    //   // TODO: Implement auth redirect logic later
    //   return null;
    // },
  );
});
