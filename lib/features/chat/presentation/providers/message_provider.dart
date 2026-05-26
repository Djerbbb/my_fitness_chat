import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/message_model.dart';
import '../../data/models/message_type.dart';
import 'user_profile_provider.dart';

class ChatMessagesNotifier extends FamilyNotifier<List<MessageModel>, String> {
  @override
  List<MessageModel> build(String arg) {
    if (arg == 'chat_me_trainer') { 
      return [
        MessageModel(
          id: 'm1',
          chatId: 'chat_me_trainer',
          senderId: 'trainer',
          senderName: 'Александр',
          text: 'Привет, Иван! Рад видеть тебя в нашем корпоративном фитнес-чате. Я изучил твои антропометрические данные и цели по снижению жировой прослойки. Подготовил для тебя первый вводный план активности и питания. Ознакомься с карточками ниже 👇',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          status: MessageStatus.read,
        ),
        MessageModel(
          id: 'm2',
          chatId: 'chat_me_trainer',
          senderId: 'trainer',
          senderName: 'Александр',
          text: '',
          type: MessageType.workoutCard,
          workoutTitle: 'Жиросжигающий Full Body Комплекс',
          workoutDuration: '45 мин',
          workoutExercises: [
            'Разминка на суставы (5 мин)',
            'Приседания с собственным весом (3 подката по 15 раз)',
            'Отжимания от платформы (3 подхода по 12 раз)',
            'Планка классическая (3 подхода по 45 секунд)',
            'Гиперэкстензия на коврике (3 подхода по 15 раз)',
            'Заминка и легкая растяжка (5 мин)'
          ],
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
          status: MessageStatus.read,
        ),
        MessageModel(
          id: 'm3',
          chatId: 'chat_me_trainer',
          senderId: 'trainer',
          senderName: 'Александр',
          text: '',
          type: MessageType.dietCard,
          dietType: 'Сбалансированный рацион (Сушка)',
          calories: 1850,
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
          status: MessageStatus.read,
        ),
        MessageModel(
          id: 'm4',
          chatId: 'chat_me_trainer',
          senderId: 'system', 
          senderName: 'Система',
          text: '',
          type: MessageType.healthPoints,
          healthPointsAmount: 120,
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          status: MessageStatus.read,
        ),
        MessageModel(
          id: 'm5',
          chatId: 'chat_me_trainer',
          senderId: 'trainer',
          senderName: 'Александр',
          text: 'Как выполнишь тренировку — нажми кнопку прямо внутри карточки, система зафиксирует пульсовую зону и начислит тебе баллы в FitPay. Если возникнут вопросы по технике — пиши сюда!',
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 25)),
          status: MessageStatus.read,
        ),
      ];
    }
    
    return [
      MessageModel(
        id: 'default_$arg',
        chatId: arg,
        senderId: 'trainer_generic',
        senderName: 'Фитнес-консультант',
        text: 'Здравствуйте! Я ваш фитнес-консультант. Готов ответить на любые вопросы по тренировкам, восстановлению и спортивным добавкам. Опишите вашу текущую активность.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        status: MessageStatus.read,
      )
    ];
  }

  void sendMessage(String text) {
    final currentUser = ref.read(currentUserProvider);

    final newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: arg,
      senderId: currentUser.id, 
      senderName: currentUser.name, 
      text: text,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    state = [...state, newMessage];
    _simulateTrainerResponse();
  }

  void toggleReaction(String messageId, String emoji) {
    state = state.map((msg) {
      if (msg.id == messageId) {
        return msg.copyWith(
          reaction: msg.reaction == emoji ? null : emoji,
        );
      }
      return msg;
    }).toList();
  }

  void deleteMessage(String messageId) {
    state = state.where((msg) => msg.id != messageId).toList();
  }

  void _simulateTrainerResponse() async {
    final currentUserId = ref.read(currentUserProvider).id;
    final bool isMeUser = currentUserId == 'user_me';
    
    final opponentId = isMeUser ? 'trainer' : 'user_me';
    final opponentName = isMeUser ? 'Александр' : 'Иван';

    await Future.delayed(const Duration(milliseconds: 800));
    ref.read(isTrainerTypingProvider(arg).notifier).state = true;

    await Future.delayed(const Duration(seconds: 2));
    ref.read(isTrainerTypingProvider(arg).notifier).state = false;

    final trainerMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: arg,
      senderId: opponentId, 
      senderName: opponentName,
      text: 'Отлично, я принял информацию! Постараюсь учесть это при корректировке следующего недельного сплита. Продолжай в том же духе 👍',
      timestamp: DateTime.now(),
      status: MessageStatus.read,
    );

    state = [...state, trainerMessage];
  }
}

final isTrainerTypingProvider = StateProvider.family<bool, String>((ref, chatId) => false);

// Главный провайдер сообщений, привязанный к конкретному ID чата
final chatMessagesProvider = NotifierProviderFamily<ChatMessagesNotifier, List<MessageModel>, String>(
  ChatMessagesNotifier.new,
);