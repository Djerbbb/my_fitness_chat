import 'package:flutter/material.dart';
import '../../../../../../core/theme/text_styles.dart';

class DietCardWidget extends StatefulWidget {
  final String dietType;
  final int calories;

  const DietCardWidget({
    super.key,
    required this.dietType,
    required this.calories,
  });

  @override
  State<DietCardWidget> createState() => _DietCardWidgetState();
}

class _DietCardWidgetState extends State<DietCardWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.restaurant_rounded, color: colorScheme.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.dietType, style: AppTextStyles.titleMedium.copyWith(color: colorScheme.onSurface)),
                    Text('Норма: ${widget.calories} ккал', style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(_isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded),
                color: colorScheme.primary,
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
              ),
            ],
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(color: colorScheme.outlineVariant, height: 1),
                ),
                Text('🍎 Белки: 30% • Жиры: 25% • Углеводы: 45%', style: AppTextStyles.bodyText.copyWith(fontSize: 14, color: colorScheme.onSurface)),
                const SizedBox(height: 4),
                Text(
                  'Рекомендация: Старайтесь держать баланс чистой воды и минимизировать быстрые углеводы перед сном.', 
                  style: AppTextStyles.bodyText.copyWith(fontSize: 13, color: colorScheme.onSurfaceVariant, fontStyle: FontStyle.italic)
                ),
                const SizedBox(height: 12),
              ],
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}