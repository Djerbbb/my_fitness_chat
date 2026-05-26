import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme_provider.dart';

class BrandBackground extends ConsumerWidget {
  final Widget child;

  const BrandBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentTheme = ref.watch(appThemeProvider);
    
    final bool isWideScreen = MediaQuery.of(context).size.width > 900;

    final String lineAsset = currentTheme == AppThemeMode.orange
        ? 'assets/images/brand_line_orange.png'
        : 'assets/images/brand_line.png';

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg_brand.png',
            fit: BoxFit.cover,
            opacity: AlwaysStoppedAnimation(isDark ? 0.04 : 0.09), 
          ),
        ),
        Positioned(
          top: 0,
          left: isWideScreen ? 360 : 0,
          right: 0,
          child: Image.asset(
            lineAsset,
            fit: BoxFit.fitWidth,
            opacity: AlwaysStoppedAnimation(currentTheme == AppThemeMode.orange ? 0.25 : (isDark ? 0.06 : 0.14)),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}