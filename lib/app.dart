import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/chat/presentation/screens/chat_list_screen.dart';

class MyFitnessChatApp extends ConsumerWidget {
  const MyFitnessChatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(appThemeProvider);

    ThemeData selectedTheme;
    switch (currentThemeMode) {
      case AppThemeMode.light:
        selectedTheme = AppTheme.lightTheme;
        break;
      case AppThemeMode.dark:
        selectedTheme = AppTheme.darkTheme;
        break;
      case AppThemeMode.orange:
        selectedTheme = AppTheme.orangeTheme;
        break;
    }

    return MaterialApp(
      title: 'Мой Фитнес',
      debugShowCheckedModeBanner: false,
      theme: selectedTheme,
      home: const ChatListScreen(),
    );
  }
}