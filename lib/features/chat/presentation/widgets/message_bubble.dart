import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/models/message_model.dart';
import '../../data/models/message_type.dart';
import '../providers/message_provider.dart';
import '../providers/user_profile_provider.dart';
import 'workout_card_widget.dart';
import 'diet_card_widget.dart';
import 'health_points_card_widget.dart';

class MessageBubble extends ConsumerWidget {
  final MessageModel message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  void _showContextMenu(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.85, end: 1.0),
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: ((value - 0.85) / 0.15).clamp(0.0, 1.0),
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 260,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 6))
                  ],
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: ['👍', '❤️', '💪', '🔥', '🍏'].map((emoji) {
                          final isSelected = message.reaction == emoji;
                          return InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              ref.read(chatMessagesProvider(message.chatId).notifier).toggleReaction(message.id, emoji);
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isSelected ? colorScheme.primary.withOpacity(0.2) : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Text(emoji, style: const TextStyle(fontSize: 24)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Divider(height: 1, color: colorScheme.outlineVariant),
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.copy_rounded, color: colorScheme.primary, size: 20),
                      title: Text('Копировать', style: TextStyle(color: colorScheme.onSurface, fontSize: 14)),
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: message.text));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Текст скопирован')));
                      },
                    ),
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                      title: const Text('Удалить', style: TextStyle(color: Colors.red, fontSize: 14)),
                      onTap: () {
                        Navigator.pop(context);
                        ref.read(chatMessagesProvider(message.chatId).notifier).deleteMessage(message.id);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentProfile = ref.watch(currentUserProvider);
    final bool isMe = message.senderId == currentProfile.id;
    
    final bubbleColor = isMe ? colorScheme.primary : colorScheme.surfaceContainerHigh;
    final textColor = isMe ? colorScheme.onPrimary : colorScheme.onSurface;
    final timeColor = textColor.withOpacity(0.65);

    final markdownStyle = MarkdownStyleSheet(
      p: AppTextStyles.bodyText.copyWith(color: textColor),
      strong: AppTextStyles.bodyText.copyWith(
        color: isMe ? colorScheme.onPrimary : colorScheme.primary, 
        fontWeight: FontWeight.w800,
      ),
      em: AppTextStyles.bodyText.copyWith(color: textColor, fontStyle: FontStyle.italic),
      h1: AppTextStyles.titleLarge.copyWith(color: textColor, fontSize: 19, fontWeight: FontWeight.bold),
      blockquote: AppTextStyles.bodyText.copyWith(color: textColor.withOpacity(0.9), fontStyle: FontStyle.italic),
      blockquoteDecoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
        border: Border(left: BorderSide(color: isMe ? colorScheme.onPrimary.withOpacity(0.6) : colorScheme.primary, width: 4)),
      ),
      listBullet: AppTextStyles.bodyText.copyWith(color: textColor),
    );

    return GestureDetector(
      onLongPress: () => _showContextMenu(context, ref),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(
                top: 6, 
                bottom: message.reaction != null ? 18 : 6, 
                left: isMe ? 64 : 16, 
                right: isMe ? 16 : 64,
              ),
              padding: message.type == MessageType.text ? const EdgeInsets.symmetric(horizontal: 14, vertical: 10) : EdgeInsets.zero,
              decoration: message.type == MessageType.text
                  ? BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 16),
                      ),
                    )
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.type == MessageType.text)
                    MarkdownBody(data: message.text, styleSheet: markdownStyle)
                  else if (message.type == MessageType.workoutCard)
                    WorkoutCardWidget(
                      title: message.workoutTitle ?? 'Программа', 
                      duration: message.workoutDuration ?? '30 мин', 
                      exercises: message.workoutExercises ?? [],
                      chatId: message.chatId,
                    )
                  else if (message.type == MessageType.dietCard)
                    DietCardWidget(dietType: message.dietType ?? 'Баланс', calories: message.calories ?? 2000)
                  else if (message.type == MessageType.healthPoints)
                    HealthPointsCardWidget(amount: message.healthPointsAmount ?? 100),
                  
                  Padding(
                    padding: EdgeInsets.only(
                      top: 4,
                      right: message.type == MessageType.text ? 0 : 12,
                      bottom: message.type == MessageType.text ? 0 : 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(DateFormat('HH:mm').format(message.timestamp), style: AppTextStyles.caption.copyWith(color: timeColor, fontSize: 10)),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          Icon(message.status == MessageStatus.read ? Icons.done_all_rounded : Icons.done_rounded, size: 13, color: isMe ? Colors.greenAccent : colorScheme.primary),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.reaction != null)
            Positioned(
              bottom: -4,
              right: isMe ? 24 : null,
              left: isMe ? null : 24,
              child: GestureDetector(
                onTap: () {
                  ref.read(chatMessagesProvider(message.chatId).notifier).toggleReaction(message.id, message.reaction!);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow, 
                    borderRadius: BorderRadius.circular(20), 
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4, offset: const Offset(0, 2))
                    ],
                    border: Border.all(color: colorScheme.outlineVariant, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(message.reaction!, style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 4),
                      Text('1', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}