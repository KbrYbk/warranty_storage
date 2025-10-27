// lib/services/theme_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Сервис для управления темой приложения.
/// Хранит текущую тему в SharedPreferences и публикует её через ValueNotifier.
class ThemeService {
  // Нотайфер, на который можно подписываться
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

  static const _key = 'themeMode';

  /// Загружает тему из SharedPreferences (если есть).
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_key);
    if (index != null && index >= 0 && index < ThemeMode.values.length) {
      themeMode.value = ThemeMode.values[index];
    } else {
      themeMode.value = ThemeMode.system;
    }
  }

  /// Сохраняет тему и обновляет notifier (все подписчики увидят изменение).
  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, mode.index);
    themeMode.value = mode;
  }

  /// Вспомогательный getter
  ThemeMode get current => themeMode.value;

  /// Не забыть закрыть, если нужно (в простом приложении обычно не требуется).
  void dispose() {
    themeMode.dispose();
  }
}
