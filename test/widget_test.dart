import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_tots/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('tiny_tots/learning'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadProgress') {
              return {'explored': '', 'lastIndex': 0};
            }
            return null;
          },
        );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('tiny_tots/learning'),
          null,
        );
  });

  testWidgets('WelcomeScreen renders app brand, owl mascot, and class cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TinyTotsApp());
    await tester.pumpAndSettle();

    expect(find.text('TinyTots'), findsOneWidget);
    expect(find.text('Little Steps, Big Learning!'), findsOneWidget);
    expect(find.text('Hello Little Learner! 👋'), findsOneWidget);
    expect(find.text('What would you like to explore today?'), findsOneWidget);
    expect(find.text('Kindergarten'), findsOneWidget);
    expect(find.text('LKG'), findsOneWidget);
    expect(find.text('UKG'), findsOneWidget);
    expect(find.text('Start Learning'), findsOneWidget);
    expect(find.text('Coming Soon'), findsNWidgets(2));
  });

  testWidgets(
    'Navigating from WelcomeScreen to KindergartenScreen shows syllabus categories',
    (WidgetTester tester) async {
      await tester.pumpWidget(const TinyTotsApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Learning'));
      await tester.pumpAndSettle();

      expect(find.text('Kindergarten'), findsOneWidget);
      expect(find.text('Let’s Start Learning!'), findsOneWidget);
      expect(find.text('ABC / English Alphabet'), findsOneWidget);
      expect(find.text('Fruits'), findsOneWidget);
      expect(find.text('Vegetables'), findsOneWidget);
    },
  );

  testWidgets('Navigating to AbcScreen displays alphabet flashcards & controls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TinyTotsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start Learning'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('ABC / English Alphabet'));
    await tester.pumpAndSettle();

    expect(find.text('ABC Time!'), findsOneWidget);
    expect(find.text('Alphabet 1 of 26'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Tap to hear'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Previous'), findsOneWidget);

    // Tap Next to go to B
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Alphabet 2 of 26'), findsOneWidget);
    expect(find.text('Ball'), findsOneWidget);
  });

  testWidgets('Grid view opens, displays letter tiles, and jumps to letter', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TinyTotsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start Learning'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('ABC / English Alphabet'));
    await tester.pumpAndSettle();

    // Open grid view
    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Pick a letter'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);

    // Tap 'C' tile
    await tester.tap(find.text('C'));
    await tester.pumpAndSettle();

    expect(find.text('Cat'), findsOneWidget);
    expect(find.text('Alphabet 3 of 26'), findsOneWidget);
  });

  testWidgets('CompletionScreen renders celebration details and buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: CompletionScreen(stars: 26)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Amazing! You Did It!'), findsOneWidget);
    expect(
      find.text('You explored all 26 letters\nof the alphabet!'),
      findsOneWidget,
    );
    expect(find.text('26 / 26 explored  •  ⭐ 26 stars'), findsOneWidget);
    expect(find.text('Replay ABC'), findsOneWidget);
    expect(find.text('Back to Kindergarten'), findsOneWidget);
  });
}
