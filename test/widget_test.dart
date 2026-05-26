import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_fitness_chat/app.dart';

void main() {
  testWidgets('Chat smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyFitnessChatApp(),
      ),
    );

    expect(find.text('Мой Фитнес Чат'), findsOneWidget);
  });
}