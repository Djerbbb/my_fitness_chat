import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/chat_model.dart';
import 'message_provider.dart';
import 'user_profile_provider.dart';

class UserActiveChatsNotifier extends Notifier<Map<String, Set<String>>> {
  @override
  Map<String, Set<String>> build() {
    return {
      'user_me': {'chat_me_trainer', 'chat_group_crossfit'},
      'trainer': {'chat_me_trainer', 'chat_group_crossfit'},
      'nutritionist': {'chat_group_crossfit'},
    };
  }

  void activateChatForUser(String userId, String chatId) {
    final currentSet = state[userId] ?? {};
    state = {
      ...state,
      userId: {...currentSet, chatId},
    };
  }
}

final userActiveChatsProvider = NotifierProvider<UserActiveChatsNotifier, Map<String, Set<String>>>(UserActiveChatsNotifier.new);
final chatSearchQueryProvider = StateProvider<String>((ref) => '');

final chatListProvider = Provider<List<ChatModel>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  final activeRoomsMap = ref.watch(userActiveChatsProvider);
  final activeRoomIds = activeRoomsMap[currentUser.id] ?? {};

  List<ChatModel> list = [];

  final allRoomsConfig = {
    'chat_me_trainer': {
      'user_me': {'title': 'Александр (Ваш Тренер)', 'avatar': 'https://png.klev.club/uploads/posts/2024-04/png-klev-club-v3lo-p-avatarka-png-2.png', 'isTrainer': true, 'isGroup': false},
      'trainer': {'title': 'Иван (Клиент)', 'avatar': 'https://png.klev.club/uploads/posts/2024-04/png-klev-club-v3lo-p-avatarka-png-2.png', 'isTrainer': false, 'isGroup': false},
    },
    'chat_me_nutritionist': {
      'user_me': {'title': 'Ольга (Нутрициолог)', 'avatar': 'https://png.klev.club/uploads/posts/2024-04/png-klev-club-v3lo-p-avatarka-png-2.png', 'isTrainer': true, 'isGroup': false},
      'nutritionist': {'title': 'Иван (Клиент)', 'avatar': 'https://png.klev.club/uploads/posts/2024-04/png-klev-club-v3lo-p-avatarka-png-2.png', 'isTrainer': false, 'isGroup': false},
    },
    'chat_trainer_nutritionist': {
      'trainer': {'title': 'Ольга (Нутрициолог)', 'avatar': 'https://png.klev.club/uploads/posts/2024-04/png-klev-club-v3lo-p-avatarka-png-2.png', 'isTrainer': true, 'isGroup': false},
      'nutritionist': {'title': 'Александр (Ваш Тренер)', 'avatar': 'https://png.klev.club/uploads/posts/2024-04/png-klev-club-v3lo-p-avatarka-png-2.png', 'isTrainer': true, 'isGroup': false},
    },
    'chat_group_crossfit': {
      'user_me': {'title': 'Группа Кроссфит «Мой Фитнес»', 'avatar': 'https://cdn-icons-png.flaticon.com/512/69/69589.png', 'isTrainer': false, 'isGroup': true},
      'trainer': {'title': 'Группа Кроссфит «Мой Фитнес»', 'avatar': 'https://cdn-icons-png.flaticon.com/512/69/69589.png', 'isTrainer': false, 'isGroup': true},
      'nutritionist': {'title': 'Группа Кроссфит «Мой Фитнес»', 'avatar': 'https://cdn-icons-png.flaticon.com/512/69/69589.png', 'isTrainer': false, 'isGroup': true},
    }
  };

  for (final roomId in activeRoomIds) {
    final configMap = allRoomsConfig[roomId];
    if (configMap == null) continue;
    final config = configMap[currentUser.id];
    if (config == null) continue;

    final roomMessages = ref.watch(chatMessagesProvider(roomId));
    final lastMsgText = roomMessages.isNotEmpty ? roomMessages.last.text : 'Нет сообщений';
    final lastMsgTime = roomMessages.isNotEmpty ? roomMessages.last.timestamp : DateTime.now().subtract(const Duration(days: 30));

    list.add(ChatModel(
      id: roomId,
      title: config['title'] as String,
      avatarUrl: config['avatar'] as String,
      isGroup: config['isGroup'] as bool,
      isTrainer: config['isTrainer'] as bool,
      lastMessage: lastMsgText,
      lastMessageTime: lastMsgTime,
      unreadCount: 0,
    ));
  }

  list.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
  return list;
});

final filteredChatsProvider = Provider<List<ChatModel>>((ref) {
  final activeChats = ref.watch(chatListProvider);
  final query = ref.watch(chatSearchQueryProvider).toLowerCase();

  if (query.isEmpty) return activeChats;
  return activeChats.where((chat) => chat.title.toLowerCase().contains(query)).toList();
});

final selectedChatIdProvider = StateProvider<String?>((ref) => null);