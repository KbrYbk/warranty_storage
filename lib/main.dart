import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/receipt.dart';
import 'services/theme_service.dart';

// Экраны
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_receipt_screen.dart';
import 'screens/expired_receipts_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // нужно для async-кода в main
  // Инициализация Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ReceiptAdapter());
  await Hive.openBox<Receipt>(
    'receipts',
  ); // Открываем коробку (хранилище чеков)
  // Инициализируем ThemeService и загружаем сохранённую тему
  final themeService = ThemeService();
  await themeService.load();
  // Запускаем приложение
  runApp(WarrantyApp(themeService: themeService));
}

class WarrantyApp extends StatefulWidget {
  final ThemeService themeService;

  const WarrantyApp({super.key, required this.themeService});

  @override
  State<WarrantyApp> createState() => _WarrantyAppState();
}

class _WarrantyAppState extends State<WarrantyApp> {
  bool _notificationsEnabled = true;
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

 /* Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getBool('notifications') ?? true;
    setState(() => _notificationsEnabled = notifications);
  }*/
// Загружаем настройку уведомлений
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  // Сохраняем настройку уведомлений
  Future<void> _toggleNotifications(bool enabled) async {
    setState(() => _notificationsEnabled = enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', enabled);
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // Если есть системные цвета (Android 12+) → используем
        // Иначе → seedColor (fallback для старых Android)
        final lightScheme =
            lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.red);
        final darkScheme =
            darkDynamic ??
            ColorScheme.fromSeed(
              seedColor: Colors.red,
              brightness: Brightness.dark,
            );
        // Подписываемся на ValueNotifier — MaterialApp будет менять themeMode автоматически
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: widget.themeService.themeMode,
          builder: (context, currentMode, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Гарантийные чеки',
              theme: ThemeData(colorScheme: lightScheme, useMaterial3: true),
              darkTheme: ThemeData(colorScheme: darkScheme, useMaterial3: true),
              themeMode: currentMode,
              initialRoute: '/home',
              routes: {
                '/login': (context) => const LoginScreen(),
                '/register': (context) => const RegisterScreen(),
                '/home': (context) => HomeScreen(themeService: widget.themeService),
                '/add': (context) => const AddReceiptScreen(),
                '/expired': (context) {
                  final box = Hive.box<Receipt>('receipts');
                  final allReceipts = box.values.toList();
                  return ExpiredReceiptsScreen(receipts: allReceipts);
                },
                '/profile': (context) => const ProfileScreen(),
                '/settings': (ctx) => SettingsScreen(
                  // теперь передаём сам сервис, чтобы экран всегда видел актуальную тему
                  themeService: widget.themeService,
                  // другие параметры (уведомления и т.д.) — оставь свои
                  notificationsEnabled: _notificationsEnabled,
                  onNotificationsChanged: _toggleNotifications,
                ),
              },
            );
          },
        );
      },
    );
  }
}
