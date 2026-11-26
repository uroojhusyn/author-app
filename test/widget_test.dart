import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BlogHubApp());
    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(BlogHubApp), findsOneWidget);
  });
}
