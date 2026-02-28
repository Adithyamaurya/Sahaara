import 'package:flutter_test/flutter_test.dart';
import 'package:sahara/main.dart';

void main() {
  testWidgets('Sahra app loads with splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SahraApp());

    // Verify app loads (Sahra text on splash)
    expect(find.text('Sahaara'), findsOneWidget);
  });
}
