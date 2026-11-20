import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_tots/data/tracing_data.dart';
import 'package:tiny_tots/services/progress_service.dart';
import 'package:tiny_tots/tracing/free_practice_screen.dart';
import 'package:tiny_tots/tracing/letter_selection_screen.dart';
import 'package:tiny_tots/tracing/number_selection_screen.dart';
import 'package:tiny_tots/tracing/trace_hub_screen.dart';
import 'package:tiny_tots/tracing/tracing_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('tiny_tots/learning'),
          (MethodCall methodCall) async {
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

  group('Tracing Models & Datasets Architecture', () {
    test('Uppercase tracing dataset contains all 26 letters A-Z', () {
      final upper = getUppercaseLetterTracingData();
      expect(upper.length, 26);
      expect(upper.first.displayChar, 'A');
      expect(upper.last.displayChar, 'Z');
      expect(upper.first.associatedWord, 'Apple');
    });

    test('Lowercase tracing dataset contains all 26 letters a-z', () {
      final lower = getLowercaseLetterTracingData();
      expect(lower.length, 26);
      expect(lower.first.displayChar, 'a');
      expect(lower.last.displayChar, 'z');
    });

    test('Number tracing dataset contains numbers 0-9', () {
      final numbers = getNumberTracingData();
      expect(numbers.length, 10);
      expect(numbers.first.displayChar, '0');
      expect(numbers.last.displayChar, '9');
      expect(numbers[3].count, 3);
    });

    test('ProgressService loads and saves tracing progress independently', () async {
      await ProgressService.saveTracingProgress('upper', {'A', 'B'});
      final saved = await ProgressService.loadTracingProgress('upper');
      expect(saved, containsAll(['A', 'B']));
    });
  });

  group('Trace & Write UI Widget Tests', () {
    testWidgets('TraceHubScreen renders header, mascot, and 3 activity cards', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: TraceHubScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Trace & Write! ✏️'), findsOneWidget);
      expect(find.text('Practice writing letters and numbers!'), findsOneWidget);
      expect(find.text('Trace Letters'), findsOneWidget);
      expect(find.text('Trace Numbers'), findsOneWidget);
      expect(find.text('Free Practice'), findsOneWidget);
    });

    testWidgets('LetterSelectionScreen renders title, uppercase/lowercase toggle, and tiles', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: LetterSelectionScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Trace Letters'), findsOneWidget);
      expect(find.text('Uppercase A-Z'), findsOneWidget);
      expect(find.text('Lowercase a-z'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('NumberSelectionScreen renders title and 0-9 number tiles', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: NumberSelectionScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Trace Numbers'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('TracingScreen renders tracing canvas and controls', (
      WidgetTester tester,
    ) async {
      final dataset = getUppercaseLetterTracingData();
      await tester.pumpWidget(
        MaterialApp(
          home: TracingScreen(
            character: dataset.first,
            dataset: dataset,
            currentIndex: 0,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Trace A'), findsOneWidget);
      expect(find.text('A - Apple'), findsOneWidget);
      expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);
      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Previous'), findsOneWidget);
    });

    testWidgets('FreePracticeScreen renders canvas, title, and character selector', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: FreePracticeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Free Practice'), findsOneWidget);
      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
    });
  });
}
