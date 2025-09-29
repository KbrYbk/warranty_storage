import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_receipt_screen.dart';
//import 'screens/receipt_details_screen.dart';
import 'screens/expired_receipts_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

void main() => runApp(const WarrantyApp());

// Сохраняем тему
Future<void> saveTheme(ThemeMode themeMode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('themeMode', themeMode.index);
}

// Загружаем тему
Future<ThemeMode> loadTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final index = prefs.getInt('themeMode') ?? ThemeMode.system.index;
  return ThemeMode.values[index];
}

// Сохраняем уведомления
Future<void> saveNotifications(bool enabled) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('notifications', enabled);
}

// Загружаем уведомления
Future<bool> loadNotifications() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('notifications') ?? true;
}

class WarrantyApp extends StatefulWidget {
  const WarrantyApp({super.key});

  @override
  State<WarrantyApp> createState() => _WarrantyAppState();
}

class _WarrantyAppState extends State<WarrantyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final theme = await loadTheme();
    final notifications = await loadNotifications();
    setState(() {
      _themeMode = theme;
      _notificationsEnabled = notifications;
    });
  }

  void _changeTheme(ThemeMode mode) {
    setState(() => _themeMode = mode);
    saveTheme(mode);
  }

  void _toggleNotifications(bool enabled) {
    setState(() => _notificationsEnabled = enabled);
    saveNotifications(enabled);
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // Если есть системные цвета (Android 12+) → используем
        // Иначе → seedColor (fallback для старых Android)
        final ColorScheme lightScheme =
            lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.red);
        final ColorScheme darkScheme =
            darkDynamic ??
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
          // themeMode: ThemeMode.system, // переключение по системной теме
          themeMode: _themeMode,
          initialRoute: '/home',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => HomeScreen(onThemeChanged: _changeTheme),
            '/add': (context) => const AddReceiptScreen(),
            '/expired': (context) => ExpiredReceiptsScreen(receipts: []),
            '/profile': (context) => const ProfileScreen(),
            '/settings': (_) => SettingsScreen(
              onThemeChanged: _changeTheme,
              notificationsEnabled: _notificationsEnabled,
              onNotificationsChanged: _toggleNotifications,
            ),
          },
        );
      },
    );
  }
}
