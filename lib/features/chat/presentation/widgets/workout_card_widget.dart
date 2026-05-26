import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/text_styles.dart';
import '../providers/message_provider.dart';

class WorkoutCardWidget extends ConsumerStatefulWidget {
  final String title;
  final String duration;
  final List<String> exercises;
  final String chatId;

  const WorkoutCardWidget({
    super.key,
    required this.title,
    required this.duration,
    required this.exercises,
    required this.chatId,
  });

  @override
  ConsumerState<WorkoutCardWidget> createState() => _WorkoutCardWidgetState();
}

class _WorkoutCardWidgetState extends ConsumerState<WorkoutCardWidget> {
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
        border: Border.all(color: colorScheme.primary.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.fitness_center_rounded, color: colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: AppTextStyles.titleMedium.copyWith(fontSize: 16, color: colorScheme.onSurface)),
                    Text('Длительность: ${widget.duration}', style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
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
                ...widget.exercises.map((exercise) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('💪 ', style: TextStyle(fontSize: 12)),
                          Expanded(child: Text(exercise, style: AppTextStyles.bodyText.copyWith(fontSize: 14, color: colorScheme.onSurface))),
                        ],
                      ),
                    )),
                const SizedBox(height: 12),
              ],
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ref.read(chatMessagesProvider(widget.chatId).notifier).sendMessage(
                  '🏃‍♂️ **Я начал тренировку:** «${widget.title}» (${widget.duration})'
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Пульсовая зона активирована. Тренировка запущена!'))
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Старт тренировки', style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}