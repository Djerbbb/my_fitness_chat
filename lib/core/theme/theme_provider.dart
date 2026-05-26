import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppThemeMode { light, dark, orange }

class ThemeNotifier extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() => AppThemeMode.dark;

  void setTheme(AppThemeMode mode) {
    state = mode;
  }

  void toggleNextTheme() {
    switch (state) {
      case AppThemeMode.light:
        state = AppThemeMode.dark;
        break;
      case AppThemeMode.dark:
        state = AppThemeMode.orange;
        break;
      case AppThemeMode.orange:
        state = AppThemeMode.light;
        break;
    }
  }
}

final appThemeProvider = NotifierProvider<ThemeNotifier, AppThemeMode>(ThemeNotifier.new);