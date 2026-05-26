import 'package:flutter/material.dart';
import '../../../../../../core/theme/text_styles.dart';

class HealthPointsCardWidget extends StatelessWidget {
  final int amount;

  const HealthPointsCardWidget({
    super.key,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: colorScheme.onPrimary, shape: BoxShape.circle),
            child: Icon(Icons.favorite_rounded, color: colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('+$amount БАЛЛОВ ЗДОРОВЬЯ', style: AppTextStyles.titleMedium.copyWith(color: colorScheme.onPrimary, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                Text(
                  'Начислено за пульсовую тренировку в системе FitPay', 
                  style: TextStyle(color: colorScheme.onPrimary.withOpacity(0.85), fontSize: 12, fontFamily: AppTextStyles.fontFamily),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}