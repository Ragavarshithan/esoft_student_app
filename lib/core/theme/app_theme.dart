// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class AppTheme {
//   // Brand Colors
//   static const Color primaryColor = Color(0xFF4F46E5); // Indigo
//   static const Color secondaryColor = Color(0xFF10B981); // Emerald
//   static const Color backgroundColor = Color(0xFFF9FAFB); // Light Gray
//   static const Color surfaceColor = Colors.white;
//   static const Color textPrimaryColor = Color(0xFF111827); // Dark Gray
//   static const Color textSecondaryColor = Color(0xFF6B7280); // Gray
//   static const Color errorColor = Color(0xFFEF4444); // Red
//
//   static ThemeData get lightTheme {
//     return ThemeData(
//       useMaterial3: true,
//       colorScheme: ColorScheme.light(
//         primary: primaryColor,
//         secondary: secondaryColor,
//         surface: surfaceColor,
//         background: backgroundColor,
//         error: errorColor,
//         onPrimary: Colors.white,
//         onSecondary: Colors.white,
//         onSurface: textPrimaryColor,
//         onBackground: textPrimaryColor,
//       ),
//       scaffoldBackgroundColor: backgroundColor,
//       textTheme: GoogleFonts.interTextTheme().copyWith(
//         displayLarge: GoogleFonts.inter(color: textPrimaryColor, fontWeight: FontWeight.bold),
//         titleLarge: GoogleFonts.inter(color: textPrimaryColor, fontWeight: FontWeight.w600),
//         bodyLarge: GoogleFonts.inter(color: textPrimaryColor),
//         bodyMedium: GoogleFonts.inter(color: textSecondaryColor),
//       ),
//       appBarTheme: const AppBarTheme(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: textPrimaryColor),
//         titleTextStyle: TextStyle(
//           color: textPrimaryColor,
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primaryColor,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//           textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: surfaceColor,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: primaryColor, width: 2),
//         ),
//         labelStyle: const TextStyle(color: textSecondaryColor),
//       ),
//       cardTheme: CardTheme(
//         color: surfaceColor,
//         elevation: 2,
//         shadowColor: Colors.black.withOpacity(0.05),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//       ),
//     );
//   }
// }
