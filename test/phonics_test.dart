import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_tots/data/phonics_data.dart';
import 'package:tiny_tots/phonics/beginning_sounds_screen.dart';
import 'package:tiny_tots/phonics/first_words_screen.dart';
import 'package:tiny_tots/phonics/letter_sounds_screen.dart';
import 'package:tiny_tots/phonics/phonics_completion_screen.dart';
import 'package:tiny_tots/phonics/phonics_hub_screen.dart';
import 'package:tiny_tots/phonics/sound_blending_screen.dart';
import 'package:tiny_tots/phonics/sound_picture_match_screen.dart';
import 'package:tiny_tots/services/progress_service.dart';

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

  group('Phonics Models & Datasets Architecture', () {
    test('getPhonicsLetterData contains 26 letter sounds A-Z with primary phonemes', () {
      final dataset = getPhonicsLetterData();
      expect(dataset.length, 26);
      expect(dataset.first.letter, 'A');
      expect(dataset.first.phoneme, '/a/');
      expect(dataset.first.exampleWord, 'Apple');
    });

    test('getCvcBlendingWords contains 12 beginner CVC blending words', () {
      final cvc = getCvcBlendingWords();
      expect(cvc.length, 12);
      expect(cvc.first.word, 'CAT');
      expect(cvc.first.letters, containsAll(['C', 'A', 'T']));
      expect(cvc.first.phonemes, containsAll(['/k/', '/a/', '/t/']));
    });

    test('ProgressService loads and saves phonics progress independently', () async {
      await ProgressService.savePhonicsProgress('letter_sounds', {'A', 'B'});
      final saved = await ProgressService.loadPhonicsProgress('letter_sounds');
      expect(saved, containsAll(['A', 'B']));
    });
  });

  group('Sounds & Words UI Widget Tests', () {
    testWidgets('PhonicsHubScreen renders header, mascot, and 5 activity cards', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: PhonicsHubScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Sounds & Words 🔊'), findsOneWidget);
      expect(find.text('Learn letter sounds, blending, and first words!'), findsOneWidget);
      expect(find.text('Letter Sounds'), findsOneWidget);
      expect(find.text('Beginning Sounds'), findsOneWidget);
      expect(find.text('Sound & Picture Match'), findsOneWidget);
      expect(find.text('Sound Blending'), findsOneWidget);
      expect(find.text('First Words'), findsOneWidget);
    });

    testWidgets('LetterSoundsScreen renders grid tiles with letters & phonemes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: LetterSoundsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Letter Sounds'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('/a/'), findsOneWidget);
    });

    testWidgets('BeginningSoundsScreen displays prompt, progress, and choice cards', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: BeginningSoundsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Beginning Sounds'), findsOneWidget);
      expect(find.text('Question 1 of 5'), findsOneWidget);
      expect(find.text('Tap to hear'), findsOneWidget);
    });

    testWidgets('SoundPictureMatchScreen displays phoneme sound and choices', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: SoundPictureMatchScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Sound & Picture Match'), findsOneWidget);
      expect(find.text('Question 1 of 5'), findsOneWidget);
    });

    testWidgets('SoundBlendingScreen displays CVC letter tiles, phonemes, and blend button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: SoundBlendingScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Sound Blending'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
      expect(find.text('/k/'), findsOneWidget);
      expect(find.text('Blend Sounds 🔉'), findsOneWidget);
    });

    testWidgets('FirstWordsScreen displays CVC word, audio button, and navigation controls', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: FirstWordsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('First Words'), findsOneWidget);
      expect(find.text('CAT'), findsOneWidget);
      expect(find.text('Tap to hear'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Previous'), findsOneWidget);
    });

    testWidgets('PhonicsCompletionScreen renders celebration UI, score, and buttons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PhonicsCompletionScreen(
            title: 'Letter Sounds',
            completionMessage: 'You learned all letter sounds!',
            starsEarned: 26,
            onReplay: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Amazing! You Did It!'), findsOneWidget);
      expect(find.text('You learned all letter sounds!'), findsOneWidget);
      expect(find.text('⭐ 26 stars earned!'), findsOneWidget);
      expect(find.text('Play Again'), findsOneWidget);
      expect(find.text('Back to Sounds & Words'), findsOneWidget);
    });
  });
}
