import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/brand_background.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/theme/theme_provider.dart';
import '../providers/chat_list_provider.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/chat_list_item.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(filteredChatsProvider);
    final currentUser = ref.watch(currentUserProvider);
    final selectedChatId = ref.watch(selectedChatIdProvider);
    final currentTheme = ref.watch(appThemeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final bool isWideScreen = MediaQuery.of(context).size.width > 900;

    final String loopAsset = currentTheme == AppThemeMode.orange
        ? 'assets/images/fit_element_2_orange.png'
        : 'assets/images/fit_element_2.png';

    final String cornerAsset = currentTheme == AppThemeMode.orange
        ? 'assets/images/MF_Line_1_orange.png'
        : 'assets/images/MF_Line_1.png';

    Widget buildChatListContent() {
      return Stack(
        children: [
          Positioned(
            bottom: -50,
            right: -60,
            child: Image.asset(
              cornerAsset,
              height: 140,
              fit: BoxFit.contain,
              opacity: AlwaysStoppedAnimation(Theme.of(context).brightness == Brightness.dark ? 0.04 : 0.12),
            ),
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outlineVariant),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: colorScheme.primary, width: 1.5),
                      ),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(currentUser.avatarUrl),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'АККАУНТ СЕТИ МОЙ ФИТНЕС', 
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: colorScheme.primary, letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 2),
                          Text(currentUser.name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: colorScheme.onSurface)),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.swap_horizontal_circle_outlined, color: colorScheme.primary, size: 26),
                      tooltip: 'Сменить аккаунт',
                      onSelected: (id) {
                        ref.read(currentUserProvider.notifier).switchProfile(id);
                        ref.read(selectedChatIdProvider.notifier).state = null;
                      },
                      itemBuilder: (context) => ref.read(currentUserProvider.notifier).availableProfiles.map((p) => PopupMenuItem(value: p.id, child: Text(p.name))).toList(),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
                  ),
                  child: TextField(
                    onChanged: (value) => ref.read(chatSearchQueryProvider.notifier).state = value,
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Поиск тренера или группы...',
                      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: chats.isEmpty
                    ? EmptyStateView(onActionPressed: () => ref.read(chatSearchQueryProvider.notifier).state = '')
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          final chat = chats[index];
                          final isSelected = isWideScreen && selectedChatId == chat.id;

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? colorScheme.primary : Colors.transparent,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.15 : 0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: ChatListItem(
                              chat: chat,
                              onTap: () {
                                ref.read(userActiveChatsProvider.notifier).activateChatForUser(currentUser.id, chat.id);
                                ref.read(chatSearchQueryProvider.notifier).state = '';

                                if (isWideScreen) {
                                  ref.read(selectedChatIdProvider.notifier).state = chat.id;
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ChatRoomScreen(chatId: chat.id)),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
        ),
        title: const Text('Мой Фитнес Корпоративный Чат'),
        centerTitle: false,
        actions: [
          PopupMenuButton<AppThemeMode>(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Выбрать брендинг фитнес-клуба',
            onSelected: (themeMode) {
              ref.read(appThemeProvider.notifier).setTheme(themeMode);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: AppThemeMode.light,
                child: Row(
                  children: [
                    Icon(Icons.light_mode_rounded, size: 18, color: Colors.amber),
                    SizedBox(width: 10),
                    Text('Стандартная Светлая'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: AppThemeMode.dark,
                child: Row(
                  children: [
                    Icon(Icons.dark_mode_rounded, size: 18, color: Colors.indigo),
                    SizedBox(width: 10),
                    Text('Корпоративная Тёмная'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: AppThemeMode.orange,
                child: Row(
                  children: [
                    Icon(Icons.local_fire_department_rounded, size: 18, color: Colors.orange),
                    SizedBox(width: 10),
                    Text('Премиум Клуб (Оранжевая)'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BrandBackground(
        child: isWideScreen
            ? Row(
                children: [
                  SizedBox(
                    width: 360,
                    child: buildChatListContent(),
                  ),
                  Container(width: 1, color: colorScheme.outlineVariant),
                  Expanded(
                    child: selectedChatId != null
                        ? ChatRoomScreen(chatId: selectedChatId)
                        : Stack(
                            children: [
                              Positioned(
                                bottom: -60,
                                right: -40,
                                child: Image.asset(
                                  loopAsset,
                                  height: 320,
                                  fit: BoxFit.contain,
                                  opacity: AlwaysStoppedAnimation(Theme.of(context).brightness == Brightness.dark ? 0.05 : 0.14),
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/logo.png',
                                      height: 56,
                                      opacity: const AlwaysStoppedAnimation(0.25),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Выберите диалог для начала фитнес-консультации',
                                      style: TextStyle(
                                        color: colorScheme.onSurfaceVariant,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppTextStyles.fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              )
            : buildChatListContent(),
      ),
    );
  }
}