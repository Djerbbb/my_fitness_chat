import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/brand_background.dart';
import '../../../../core/widgets/custom_avatar.dart';
import '../providers/chat_list_provider.dart';
import '../providers/message_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input_bar.dart';
import '../../../../core/theme/theme_provider.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatRoomScreen({
    super.key,
    required this.chatId,
  });

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottomButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset > 200) {
      if (!_showScrollToBottomButton) {
        setState(() => _showScrollToBottomButton = true);
      }
    } else {
      if (_showScrollToBottomButton) {
        setState(() => _showScrollToBottomButton = false);
      }
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void _showMarkdownGuide(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.text_fields_rounded, color: colorScheme.primary),
            const SizedBox(width: 10),
            const Text('Гайд форматирования'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('**Жирный текст** -> Выделение цветом бренда'),
            SizedBox(height: 6),
            Text('*Курсив* -> Наклонный шрифт сообщений'),
            SizedBox(height: 6),
            Text('# Заголовок -> Крупный текст H1'),
            SizedBox(height: 6),
            Text('> Цитата -> Блок советов тренера с синей линией'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Понятно')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider(widget.chatId));
    final chatInfo = ref.watch(chatListProvider).firstWhere((c) => c.id == widget.chatId);
    final isTyping = ref.watch(isTrainerTypingProvider(widget.chatId));
    final colorScheme = Theme.of(context).colorScheme;
    final currentTheme = ref.watch(appThemeProvider);
    final String loopAsset = currentTheme == AppThemeMode.orange
        ? 'assets/images/fit_element_2_orange.png'
        : 'assets/images/fit_element_2.png';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: MediaQuery.of(context).size.width <= 900,
        titleSpacing: MediaQuery.of(context).size.width > 900 ? 16 : 0,
        title: Row(
          children: [
            CustomAvatar(
              imageUrl: chatInfo.avatarUrl,
              isTrainer: chatInfo.isTrainer,
              radius: 18,
              isOnline: true,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(chatInfo.title, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(
                    isTyping ? 'печатает...' : (chatInfo.isTrainer ? 'Онлайн • Эксперт' : 'Онлайн'),
                    style: TextStyle(
                      fontSize: 12, 
                      color: isTyping ? colorScheme.primary : const Color(0xFF10B981), 
                      fontWeight: isTyping ? FontWeight.bold : FontWeight.w400
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            tooltip: 'Гайд по Markdown',
            onPressed: () => _showMarkdownGuide(context),
          ),
        ],
      ),
      body: BrandBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                bottom: 40,
                right: -50,
                child: Image.asset(
                  loopAsset,
                  height: 260,
                  fit: BoxFit.contain,
                  opacity: const AlwaysStoppedAnimation(0.06),
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: Center(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[messages.length - 1 - index];
                          
                          return TweenAnimationBuilder<double>(
                            key: ValueKey(message.id),
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 16 * (1.0 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: MessageBubble(message: message),
                          );
                        },
                      ),
                    ),
                  ),
                  if (isTyping)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              '${chatInfo.title.split(' ')[0]} печатает', 
                              style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant, fontStyle: FontStyle.italic)
                            ),
                            const SizedBox(width: 6),
                            Row(
                              children: List.generate(3, (i) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 1.5), 
                                width: 4, 
                                height: 4, 
                                decoration: BoxDecoration(
                                  color: colorScheme.onSurfaceVariant.withOpacity(0.4 + (i * 0.2)), 
                                  shape: BoxShape.circle
                                )
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  MessageInputBar(
                    onSendMessage: (text) {
                      ref.read(chatMessagesProvider(widget.chatId).notifier).sendMessage(text);
                      _scrollToBottom();
                    },
                  ),
                ],
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                bottom: _showScrollToBottomButton ? 80 : -60,
                right: MediaQuery.of(context).size.width > 600 ? (MediaQuery.of(context).size.width - 600) / 2 + 16 : 16,
                child: FloatingActionButton.small(
                  onPressed: _scrollToBottom,
                  backgroundColor: colorScheme.surfaceContainerLow,
                  foregroundColor: colorScheme.primary,
                  elevation: 4,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.arrow_downward_rounded, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}