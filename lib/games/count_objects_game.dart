import 'dart:math';
import 'package:flutter/material.dart';
import '../config/game_config.dart';
import '../data/category_data.dart';
import '../localization/app_localizations.dart';
import '../models/game_session.dart';
import '../models/learning_card.dart';
import '../services/progress_service.dart';
import '../services/pronunciation_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bouncy_button.dart';
import '../widgets/card_illustrations.dart';
import '../widgets/playground_background.dart';
import 'game_completion_screen.dart';

class CountQuestion {
  CountQuestion({
    required this.targetCard,
    required this.correctCount,
    required this.numberOptions,
  });

  final LearningCard targetCard;
  final int correctCount;
  final List<int> numberOptions;
}

class CountObjectsGameScreen extends StatefulWidget {
  const CountObjectsGameScreen({super.key, required this.config});

  final GameConfig config;

  @override
  State<CountObjectsGameScreen> createState() => _CountObjectsGameScreenState();
}

class _CountObjectsGameScreenState extends State<CountObjectsGameScreen> {
  late GameSession _session;
  late List<CountQuestion> _questions;
  bool _feedbackShowing = false;
  String? _feedbackText;

  @override
  void initState() {
    super.initState();
    _session = GameSession(gameId: widget.config.id, categoryId: 'numbers');
    _generateQuestions();
    _playPromptAudio();
  }

  void _generateQuestions() {
    final pool = kindergartenCategories.firstWhere((c) => c.id == 'fruits').cards;
    final rng = Random();
    final questions = <CountQuestion>[];

    for (int i = 0; i < 5; i++) {
      final card = pool[i % pool.length];
      final count = rng.nextInt(6) + 1; // 1 to 6 objects
      final opts = <int>{count};
      while (opts.length < 3) {
        final r = rng.nextInt(7) + 1;
        opts.add(r);
      }
      final numberOptions = opts.toList()..shuffle(rng);
      questions.add(CountQuestion(
        targetCard: card,
        correctCount: count,
        numberOptions: numberOptions,
      ));
    }
    _questions = questions;
  }

  Future<void> _playPromptAudio() async {
    if (_session.isFinished) return;
    final q = _questions[_session.currentIndex];
    final text = 'How many ${q.targetCard.word}s? ${q.correctCount}';
    await PronunciationService.speak(LearningCard(
      id: q.targetCard.id,
      uppercase: '${q.correctCount}',
      lowercase: q.targetCard.word,
      word: q.targetCard.word,
      emoji: q.targetCard.emoji,
      colorValue: q.targetCard.colorValue,
      imagePath: q.targetCard.imagePath,
      secondaryText: text,
    ));
  }

  Future<void> _onOptionSelected(int chosenCount) async {
    if (_feedbackShowing) return;
    final q = _questions[_session.currentIndex];
    _session.attempts++;

    if (chosenCount == q.correctCount) {
      // Correct!
      _session.correctCount++;
      _session.starsEarned++;
      setState(() {
        _feedbackShowing = true;
        _feedbackText = AppLocalizations.tr('games.feedback.countTogether');
      });

      await Future<void>.delayed(const Duration(milliseconds: 1200));

      if (!mounted) return;
      if (_session.currentIndex + 1 >= _session.totalQuestions) {
        await ProgressService.saveGameProgress(
          widget.config.id,
          starsEarned: _session.starsEarned,
          completedRounds: 1,
        );
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => GameCompletionScreen(
              config: widget.config,
              starsEarned: _session.starsEarned,
              onPlayAgain: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CountObjectsGameScreen(config: widget.config),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        setState(() {
          _session.currentIndex++;
          _feedbackShowing = false;
          _feedbackText = null;
        });
        _playPromptAudio();
      }
    } else {
      setState(() {
        _feedbackText = AppLocalizations.tr('games.feedback.tryAgain');
      });
      _playPromptAudio();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_session.isFinished) return const SizedBox.shrink();
    final q = _questions[_session.currentIndex];

    return PlaygroundBackground(
      showHills: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                BouncyButton(
                  color: AppTheme.softWhite,
                  borderRadius: 20,
                  padding: const EdgeInsets.all(10),
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_rounded, color: AppTheme.navy),
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.tr(widget.config.titleKey),
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppTheme.navy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.yellow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '⭐ ${_session.starsEarned}',
                    style: const TextStyle(
                      color: AppTheme.navy,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
            child: Row(
              children: [
                Text(
                  AppLocalizations.tr('games.questionProgress', args: {
                    'current': '${_session.currentIndex + 1}',
                    'total': '${_session.totalQuestions}',
                  }),
                  style: const TextStyle(
                    color: AppTheme.navy,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.tr('games.countPrompt', args: {'object': '${q.targetCard.word}s'}),
            style: const TextStyle(
              fontSize: 22,
              color: AppTheme.navy,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (_feedbackText != null) ...[
            const SizedBox(height: 6),
            Text(
              _feedbackText!,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.navy,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Countable Objects Container
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.softWhite,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: AppTheme.cardShadow(),
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(
                    q.correctCount,
                    (_) => Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(q.targetCard.colorValue),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          q.targetCard.imagePath,
                          width: 65,
                          height: 65,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => FlashcardIllustration(
                            letterId: q.targetCard.id.toUpperCase(),
                            size: 55,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 3 Number Option Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: q.numberOptions.map((n) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: BouncyButton(
                      color: AppTheme.yellow,
                      borderRadius: 24,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      onTap: () => _onOptionSelected(n),
                      child: Center(
                        child: Text(
                          '$n',
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.navy,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
