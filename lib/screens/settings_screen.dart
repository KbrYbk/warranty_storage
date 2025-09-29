import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final void Function(ThemeMode) onThemeChanged;
  final bool notificationsEnabled;
  final void Function(bool) onNotificationsChanged;

  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _notifications;
  late ThemeMode _currentTheme;

  @override
  void initState() {
    super.initState();
    _notifications = widget.notificationsEnabled;
    _currentTheme = ThemeMode.system; // Можно загружать из main через widget
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Выберите тему"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Системная"),
                onTap: () {
                  setState(() => _currentTheme = ThemeMode.system);
                  widget.onThemeChanged(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Светлая"),
                onTap: () {
                  setState(() => _currentTheme = ThemeMode.light);
                  widget.onThemeChanged(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Тёмная"),
                onTap: () {
                  setState(() => _currentTheme = ThemeMode.dark);
                  widget.onThemeChanged(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String get _themeText {
    switch (_currentTheme) {
      case ThemeMode.light:
        return "Светлая";
      case ThemeMode.dark:
        return "Тёмная";
      default:
        return "Системная";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: const Text("Тема"),
            subtitle: Text("Текущая тема: $_themeText"),
            trailing: const Icon(Icons.color_lens_outlined),
            onTap: _showThemeDialog,
          ),
          SwitchListTile(
            title: const Text("Уведомления"),
            subtitle: const Text("Включить или отключить уведомления"),
            value: _notifications,
            onChanged: (val) {
              setState(() => _notifications = val);
              widget.onNotificationsChanged(val);
            },
          ),
        ],
      ),
    );
  }
}
