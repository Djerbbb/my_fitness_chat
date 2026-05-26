import 'message_type.dart';

enum MessageStatus { sending, sent, read }

class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final MessageType type;
  final MessageStatus status;
  final String? reaction;

  final String? workoutTitle;
  final String? workoutDuration;
  final List<String>? workoutExercises;
  final String? dietType;
  final int? calories;
  final int? healthPointsAmount;

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    this.type = MessageType.text,
    this.status = MessageStatus.read,
    this.reaction,
    this.workoutTitle,
    this.workoutDuration,
    this.workoutExercises,
    this.dietType,
    this.calories,
    this.healthPointsAmount,
  });

  MessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? senderName,
    String? text,
    DateTime? timestamp,
    bool? isMe,
    MessageType? type,
    MessageStatus? status,
    String? reaction,
    String? workoutTitle,
    String? workoutDuration,
    List<String>? workoutExercises,
    String? dietType,
    int? calories,
    int? healthPointsAmount,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      status: status ?? this.status,
      reaction: reaction ?? this.reaction,
      workoutTitle: workoutTitle ?? this.workoutTitle,
      workoutDuration: workoutDuration ?? this.workoutDuration,
      workoutExercises: workoutExercises ?? this.workoutExercises,
      dietType: dietType ?? this.dietType,
      calories: calories ?? this.calories,
      healthPointsAmount: healthPointsAmount ?? this.healthPointsAmount,
    );
  }
}