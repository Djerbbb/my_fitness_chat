import 'package:intl/intl.dart';

class DateFormatter {
  static String formatChatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (messageDate == yesterday) {
      return 'Вчера';
    } else {
      return DateFormat('d MMM', 'ru').format(dateTime);
    }
  }
}