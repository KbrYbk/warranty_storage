import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_receipt_screen.dart';
import 'screens/receipt_details_screen.dart';
import 'screens/expired_receipts_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

void main() => runApp(const WarrantyApp());

class WarrantyApp extends StatelessWidget {
  const WarrantyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // Если есть системные цвета (Android 12+) → используем
        // Иначе → seedColor (fallback для старых Android)
        final ColorScheme lightScheme =
            lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.red);
        final ColorScheme darkScheme = darkDynamic ??
            ColorScheme.fromSeed(
              seedColor: Colors.red,
              brightness: Brightness.dark,
            );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Гарантийные чеки',
          theme: ThemeData(
            colorScheme: lightScheme,

            useMaterial3: true,
            appBarTheme: AppBarTheme(
              centerTitle: true,
              scrolledUnderElevation: 0,
              backgroundColor: lightScheme.surface, // <-- фон для AppBar
              foregroundColor: lightScheme.onSurface, // <-- текст/иконки
             // elevation: 1,                                  // лёгкая "подложка"
            ),

          ),
          darkTheme: ThemeData(
            colorScheme: darkScheme,
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              centerTitle: true,
              scrolledUnderElevation: 0,
              backgroundColor: darkScheme.surface,
              foregroundColor: darkScheme.onSurface,
              //elevation: 1,                                  // лёгкая "подложка"
            ),
          ),
          themeMode: ThemeMode.system, // переключение по системной теме
          initialRoute: '/home',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomeScreen(),
            '/add': (context) => const AddReceiptScreen(),
            '/expired': (context) => const ExpiredReceiptsScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
        );
      },
    );
  }
}
