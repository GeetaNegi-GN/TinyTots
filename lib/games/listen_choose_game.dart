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

class ListenChooseQuestion {
  ListenChooseQuestion({
    required this.targetCard,
    required this.choices,
  });

  final LearningCard targetCard;
  final List<LearningCard> choices;
}

class ListenChooseGameScreen extends StatefulWidget {
  const ListenChooseGameScreen({super.key, required this.config});

  final GameConfig config;

  @override
  State<ListenChooseGameScreen> createState() => _ListenChooseGameScreenState();
}

class _ListenChooseGameScreenState extends State<ListenChooseGameScreen> {
  late GameSession _session;
  late List<ListenChooseQuestion> _questions;
  bool _feedbackShowing = false;
  String? _feedbackText;

  @override
  void initState() {
    super.initState();
    _session = GameSession(gameId: widget.config.id, categoryId: 'fruits');
    _generateQuestions();
    _playTargetAudio();
  }

  void _generateQuestions() {
    final pool = kindergartenCategories.firstWhere((c) => c.id == 'fruits').cards;
    final rng = Random();
    final questions = <ListenChooseQuestion>[];

    for (int i = 0; i < 5; i++) {
      final target = pool[i % pool.length];
      final distractors = pool.where((c) => c.id != target.id).toList()..shuffle(rng);
      final choices = [target, distractors[0], distractors[1], distractors[2]]..shuffle(rng);
      questions.add(ListenChooseQuestion(targetCard: target, choices: choices));
    }
    _questions = questions;
  }

  Future<void> _playTargetAudio() async {
    if (_session.isFinished) return;
    final currentQ = _questions[_session.currentIndex];
    await PronunciationService.speak(currentQ.targetCard);
  }

  Future<void> _onChoiceSelected(LearningCard choice) async {
    if (_feedbackShowing) return;
    final currentQ = _questions[_session.currentIndex];
    _session.attempts++;

    if (choice.id == currentQ.targetCard.id) {
      // Correct!
      _session.correctCount++;
      _session.starsEarned++;
      setState(() {
        _feedbackShowing = true;
        _feedbackText = AppLocalizations.tr('games.feedback.correct');
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
                    builder: (_) => ListenChooseGameScreen(config: widget.config),
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
        _playTargetAudio();
      }
    } else {
      // Wrong attempt - gentle encouragement without punishment
      setState(() {
        _feedbackText = AppLocalizations.tr('games.feedback.tryAgain');
      });
      _playTargetAudio();
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
          const SizedBox(height: 12),
          // Audio Replay Card
          BouncyButton(
            color: AppTheme.softWhite,
            borderRadius: 28,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            onTap: _playTargetAudio,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.volume_up_rounded, color: AppTheme.navy, size: 28),
                const SizedBox(width: 10),
                Text(
                  AppLocalizations.tr('common.tapToHear'),
                  style: const TextStyle(
                    color: AppTheme.navy,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          if (_feedbackText != null) ...[
            const SizedBox(height: 10),
            Text(
              _feedbackText!,
              style: const TextStyle(
                fontSize: 17,
                color: AppTheme.navy,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
          const SizedBox(height: 16),
          // 4 Image Choices Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: GridView.builder(
                itemCount: q.choices.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, idx) {
                  final card = q.choices[idx];
                  return Material(
                    color: Color(card.colorValue),
                    borderRadius: BorderRadius.circular(28),
                    elevation: 3,
                    child: InkWell(
                      onTap: () => _onChoiceSelected(card),
                      borderRadius: BorderRadius.circular(28),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              card.imagePath,
                              fit: BoxFit.contain,
                              height: 110,
                              errorBuilder: (_, _, _) => FlashcardIllustration(
                                letterId: card.id.toUpperCase(),
                                size: 80,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
