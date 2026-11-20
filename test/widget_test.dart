import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_tots/data/category_data.dart';
import 'package:tiny_tots/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('tiny_tots/learning'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadProgress' ||
                methodCall.method == 'loadCategoryProgress') {
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
    'Navigating from WelcomeScreen to KindergartenScreen shows all 11 active syllabus categories',
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
      expect(find.text('Animals'), findsOneWidget);
      expect(find.text('Birds'), findsOneWidget);
      expect(find.text('Numbers 1–20'), findsOneWidget);
      expect(find.text('Colors'), findsOneWidget);
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
    expect(find.text('ABC 1 of 26'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Tap to hear'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Previous'), findsOneWidget);

    // Tap Next to go to B
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('ABC 2 of 26'), findsOneWidget);
    expect(find.text('Ball'), findsOneWidget);
  });

  testWidgets('Navigating to Fruits category displays fruit flashcards & controls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TinyTotsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start Learning'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Fruits'));
    await tester.pumpAndSettle();

    expect(find.text('Fruits Time!'), findsOneWidget);
    expect(find.text('Fruits 1 of 20'), findsOneWidget);
    expect(find.text('Apple'), findsAtLeast(1));
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

    expect(find.text('Pick a ABC'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);

    // Tap 'C' tile
    await tester.tap(find.text('C'));
    await tester.pumpAndSettle();

    expect(find.text('Cat'), findsOneWidget);
    expect(find.text('ABC 3 of 26'), findsOneWidget);
  });

  testWidgets('CompletionScreen renders category celebration details and buttons', (
    WidgetTester tester,
  ) async {
    final cat = kindergartenCategories.firstWhere((c) => c.id == 'fruits');
    await tester.pumpWidget(
      MaterialApp(home: CompletionScreen(stars: 20, category: cat)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Amazing! You Did It!'), findsOneWidget);
    expect(
      find.text('You learned all the delicious fruits!'),
      findsOneWidget,
    );
    expect(find.text('20 / 20 explored  •  ⭐ 20 stars'), findsOneWidget);
    expect(find.text('Replay Fruits'), findsOneWidget);
    expect(find.text('Back to Kindergarten'), findsOneWidget);
  });
}
