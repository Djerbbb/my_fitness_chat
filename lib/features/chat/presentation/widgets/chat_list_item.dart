import 'package:flutter/material.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/custom_avatar.dart';
import '../../data/models/chat_model.dart';

class ChatListItem extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CustomAvatar(
              imageUrl: chat.avatarUrl,
              isTrainer: chat.isTrainer,
              radius: 26,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.title,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: chat.isTrainer ? colorScheme.primary : colorScheme.onSurface,
                            fontWeight: chat.isTrainer ? FontWeight.w700 : FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormatter.formatChatTime(chat.lastMessageTime),
                        style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          style: AppTextStyles.bodyText.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(minWidth: 20),
                          child: Text(
                            '${chat.unreadCount}',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: colorScheme.onPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}