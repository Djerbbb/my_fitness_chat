import '../models/chat_model.dart';
import '../models/message_model.dart';

class MockChatDatasource {
  List<ChatModel> getMockChats() {
    return [
      ChatModel(
        id: 'chat_1',
        title: 'Александр (Ваш Тренер)',
        avatarUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMqrUu9AC7JX67KTcUOqikRmgT7uuzI1Yb0A&s',
        isGroup: false,
        isTrainer: true,
        lastMessage: 'Привет! Хочу подтянуть выносливость и сбросить немного веса к лету.',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
        unreadCount: 0,
      ),
      ChatModel(
        id: 'chat_3',
        title: 'Ольга (Нутрициолог)',
        avatarUrl: 'https://png.pngtree.com/png-vector/20230317/ourmid/pngtree-cute-drawing-cartoon-girl-for-profile-picture-vector-png-image_6650753.png',
        isGroup: false,
        isTrainer: true,
        lastMessage: 'Вы начали официальный диалог со специалистом сети «Мой Фитнес». Все консультации защищены.',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 45)),
        unreadCount: 0,
      ),
    ];
  }

  List<ChatModel> getCompanyDirectory() {
    return [
      ChatModel(
        id: 'chat_1',
        title: 'Александр (Ваш Тренер)',
        avatarUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMqrUu9AC7JX67KTcUOqikRmgT7uuzI1Yb0A&s',
        isGroup: false,
        isTrainer: true,
        lastMessage: 'Привет! Хочу подтянуть выносливость...',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
        unreadCount: 0,
      ),
      ChatModel(
        id: 'chat_3',
        title: 'Ольга (Нутрициолог)',
        avatarUrl: 'https://png.pngtree.com/png-vector/20230317/ourmid/pngtree-cute-drawing-cartoon-girl-for-profile-picture-vector-png-image_6650753.png',
        isGroup: false,
        isTrainer: true,
        lastMessage: 'Вы начали официальный диалог со специалистом...',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 45)),
        unreadCount: 0,
      ),
    ];
  }

  List<MessageModel> getMockMessages(String chatId) {
    final now = DateTime.now();
    if (chatId == 'chat_1') {
      return [
        MessageModel(
          id: 'm1_1',
          chatId: 'chat_1',
          senderId: 'trainer',
          senderName: 'Александр',
          text: '# Привет!\nРад видеть тебя в приложении *Мой Фитнес*. Давай обсудим наши цели на этот месяц.',
          timestamp: now.subtract(const Duration(days: 1)),
        ),
        MessageModel(
          id: 'm1_2',
          chatId: 'chat_1',
          senderId: 'user_me',
          senderName: 'Иван',
          text: 'Привет! Хочу подтянуть выносливость и сбросить немного веса к лету.',
          timestamp: now.subtract(const Duration(hours: 3)),
        ),
      ];
    }
    return [
      MessageModel(
        id: 'default_$chatId',
        chatId: chatId,
        senderId: 'system',
        senderName: 'Система',
        text: 'Вы начали официальный диалог со специалистом сети «Мой Фитнес». Все консультации защищены.',
        timestamp: now.subtract(const Duration(minutes: 45)),
      )
    ];
  }
}