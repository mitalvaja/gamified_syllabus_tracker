import 'package:flutter_test/flutter_test.dart';
import 'package:gamified_syllabus_tracker/app/app.dart';

void main() {
  testWidgets('Gamified Syllabus Tracker app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GamifiedSyllabusApp());
    expect(find.byType(GamifiedSyllabusApp), findsOneWidget);
  });
}
