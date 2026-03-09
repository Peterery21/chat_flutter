import 'package:flutter_test/flutter_test.dart';
import 'package:chat_flutter_example/main.dart';

void main() {
  testWidgets('Login screen shows form', (tester) async {
    await tester.pumpWidget(const ChatExampleApp());
    expect(find.text('Chat Flutter Demo'), findsOneWidget);
  });
}
