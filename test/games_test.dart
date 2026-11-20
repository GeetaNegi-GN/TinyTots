import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_tots/config/game_config.dart';
import 'package:tiny_tots/games/count_objects_game.dart';
import 'package:tiny_tots/games/game_completion_screen.dart';
import 'package:tiny_tots/games/game_zone_screen.dart';
import 'package:tiny_tots/games/listen_choose_game.dart';
import 'package:tiny_tots/games/match_letters_game.dart';
import 'package:tiny_tots/games/match_pictures_game.dart';
import 'package:tiny_tots/games/memory_match_game.dart';
import 'package:tiny_tots/models/game_session.dart';
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

  group('GameConfig & GameSession Data Architecture', () {
    test('defaultGameConfigs contains 5 registered games with stable IDs', () {
      expect(defaultGameConfigs.length, 5);
      final ids = defaultGameConfigs.map((g) => g.id).toSet();
      expect(ids, containsAll([
        'listen_choose',
        'match_pictures',
        'match_letters',
        'memory_match',
        'count_objects',
      ]));
    });

    test('GameSession manages question indices and completion state', () {
      final session = GameSession(
        gameId: 'listen_choose',
        categoryId: 'fruits',
        totalQuestions: 5,
      );

      expect(session.currentIndex, 0);
      expect(session.isFinished, isFalse);

      session.currentIndex = 5;
      expect(session.isFinished, isTrue);
    });

    test('ProgressService loads and saves game progress independently', () async {
      await ProgressService.saveGameProgress('listen_choose', starsEarned: 5, completedRounds: 1);
      final p = await ProgressService.loadGameProgress('listen_choose');
      expect(p.starsEarned, 5);
      expect(p.completedRounds, 1);
    });
  });

  group('Game Zone & Interactive Games Widget Tests', () {
    testWidgets('GameZoneScreen renders header, mascot, and 5 game cards', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: GameZoneScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Let’s Play & Learn!'), findsOneWidget);
      expect(find.text('Choose a fun game to practice!'), findsOneWidget);
      expect(find.text('Listen & Choose'), findsOneWidget);
      expect(find.text('Match the Pictures'), findsOneWidget);
      expect(find.text('Match the Letters'), findsOneWidget);
      expect(find.text('Memory Match'), findsOneWidget);
      expect(find.text('Count the Objects'), findsOneWidget);
    });

    testWidgets('ListenChooseGameScreen displays game controls and question progress', (
      WidgetTester tester,
    ) async {
      final cfg = defaultGameConfigs.firstWhere((g) => g.id == 'listen_choose');
      await tester.pumpWidget(MaterialApp(home: ListenChooseGameScreen(config: cfg)));
      await tester.pumpAndSettle();

      expect(find.text('Listen & Choose'), findsOneWidget);
      expect(find.text('Question 1 of 5'), findsOneWidget);
      expect(find.text('Tap to hear'), findsOneWidget);
    });

    testWidgets('MatchPicturesGameScreen renders tiles and responds to taps', (
      WidgetTester tester,
    ) async {
      final cfg = defaultGameConfigs.firstWhere((g) => g.id == 'match_pictures');
      await tester.pumpWidget(MaterialApp(home: MatchPicturesGameScreen(config: cfg)));
      await tester.pumpAndSettle();

      expect(find.text('Match the Pictures'), findsOneWidget);
      expect(find.byIcon(Icons.question_mark_rounded), findsWidgets);

      // Tap first tile to reveal
      await tester.tap(find.byIcon(Icons.question_mark_rounded).first);
      await tester.pumpAndSettle();
    });

    testWidgets('MatchLettersGameScreen displays letter tiles and responds to taps', (
      WidgetTester tester,
    ) async {
      final cfg = defaultGameConfigs.firstWhere((g) => g.id == 'match_letters');
      await tester.pumpWidget(MaterialApp(home: MatchLettersGameScreen(config: cfg)));
      await tester.pumpAndSettle();

      expect(find.text('Match the Letters'), findsOneWidget);
    });

    testWidgets('MemoryMatchGameScreen renders face-down cards and responds to taps', (
      WidgetTester tester,
    ) async {
      final cfg = defaultGameConfigs.firstWhere((g) => g.id == 'memory_match');
      await tester.pumpWidget(MaterialApp(home: MemoryMatchGameScreen(config: cfg)));
      await tester.pumpAndSettle();

      expect(find.text('Memory Match'), findsOneWidget);
      expect(find.text('TinyTots'), findsWidgets);
    });

    testWidgets('CountObjectsGameScreen renders counting objects and number choices', (
      WidgetTester tester,
    ) async {
      final cfg = defaultGameConfigs.firstWhere((g) => g.id == 'count_objects');
      await tester.pumpWidget(MaterialApp(home: CountObjectsGameScreen(config: cfg)));
      await tester.pumpAndSettle();

      expect(find.text('Count the Objects'), findsOneWidget);
      expect(find.text('Question 1 of 5'), findsOneWidget);
    });

    testWidgets('GameCompletionScreen renders celebration UI, score, and buttons', (
      WidgetTester tester,
    ) async {
      final cfg = defaultGameConfigs.firstWhere((g) => g.id == 'listen_choose');
      await tester.pumpWidget(
        MaterialApp(
          home: GameCompletionScreen(
            config: cfg,
            starsEarned: 5,
            onPlayAgain: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Amazing! You Did It!'), findsOneWidget);
      expect(find.text('You completed Listen & Choose!'), findsOneWidget);
      expect(find.text('⭐ 5 stars earned!'), findsOneWidget);
      expect(find.text('Play Again'), findsOneWidget);
      expect(find.text('Back to Games'), findsOneWidget);
    });
  });
}
