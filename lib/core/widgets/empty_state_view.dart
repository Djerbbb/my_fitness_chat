import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme_provider.dart';

class EmptyStateView extends ConsumerWidget {
  final VoidCallback onActionPressed;

  const EmptyStateView({super.key, required this.onActionPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appThemeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String elementAsset = currentTheme == AppThemeMode.orange
        ? 'assets/images/fit_element_1_orange.png'
        : 'assets/images/fit_element_1.png';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              elementAsset,
              height: 140,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            Text(
              'Чатов пока нет',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Используйте поиск сверху, чтобы найти своего тренера или нутрициолога сети.',
              textAlign: TextAlign.center,
              style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: onActionPressed,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Сбросить поиск'),
            ),
          ],
        ),
      ),
    );
  }
}