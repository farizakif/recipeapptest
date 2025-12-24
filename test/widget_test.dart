import 'package:flutter_test/flutter_test.dart';
import 'package:recipeapptest/app.dart';

void main() {
  testWidgets('Recipe app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RecipeApp());

    // Verify that the app starts successfully
    expect(find.text('Recipe App'), findsOneWidget);
  });
}
