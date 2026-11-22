import 'package:flutter_test/flutter_test.dart';
import 'package:boogle_home/main.dart';

void main() {
  testWidgets('Boogle Home starts', (WidgetTester tester) async {
    await tester.pumpWidget(const BoogleHome());

    expect(find.text('Boogle Home'), findsWidgets);
  });
}