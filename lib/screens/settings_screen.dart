import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class SettingsScreen extends StatefulWidget {
  final ThemeService themeService;
  final bool notificationsEnabled;
  final void Function(bool) onNotificationsChanged;

  const SettingsScreen({
    super.key,
    required this.themeService,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = widget.notificationsEnabled;
  }

  void _showThemeDialog() {
    final currentTheme = widget.themeService.themeMode.value;

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Выберите тему"),
          children: [
            _themeOption("Системная", ThemeMode.system, currentTheme),
            _themeOption("Светлая", ThemeMode.light, currentTheme),
            _themeOption("Тёмная", ThemeMode.dark, currentTheme),
          ],
        );
      },
    );
  }

  Widget _themeOption(String title, ThemeMode mode, ThemeMode current) {
    return RadioListTile<ThemeMode>(
      title: Text(title),
      value: mode,
      groupValue: current,
      onChanged: (val) {
        if (val != null) {
          widget.themeService.setTheme(val);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Тема изменена: $title")),
          );
        }
      },
    );
  }

  void _onNotificationsChanged(bool val) {
    setState(() => _notifications = val);
    widget.onNotificationsChanged(val);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(val
            ? "Уведомления включены"
            : "Уведомления выключены"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = widget.themeService.themeMode.value;

    String themeText;
    switch (themeMode) {
      case ThemeMode.light:
        themeText = "Светлая";
        break;
      case ThemeMode.dark:
        themeText = "Тёмная";
        break;
      default:
        themeText = "Системная";
    }

    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: const Text("Тема"),
            subtitle: Text("Текущая тема: $themeText"),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showThemeDialog,
          ),
          const Divider(),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text("Пуш-уведомления"),
            subtitle: const Text("Разрешить или запретить уведомления"),
            value: _notifications,
            onChanged: _onNotificationsChanged,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("О приложении"),
            subtitle: const Text("Версия 1.0 — Warranty Storage"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Warranty Storage",
                applicationVersion: "1.0",
                children: const [
                  Text(
                    "Приложение для хранения гарантийных чеков локально на устройстве.",
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
