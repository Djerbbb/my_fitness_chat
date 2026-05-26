class SecurityHelper {
  static String sanitizeChatInput(String input) {
    if (input.isEmpty) return input;
    
    return input
        .replaceAll(RegExp(r'<script[^>]*?>.*?</script>', caseSensitive: false, multiLine: true), '')
        .replaceAll(RegExp(r'<[^>]*>', caseSensitive: false), '') // Удаление любых сырых HTML тегов
        .trim();
  }
}