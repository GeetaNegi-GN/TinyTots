import 'dart:math';
import 'package:flutter/material.dart';
import '../data/phonics_data.dart';
import '../localization/app_localizations.dart';
import '../models/learning_card.dart';
import '../models/phonics_model.dart';
import '../services/progress_service.dart';
import '../services/pronunciation_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bouncy_button.dart';
import '../widgets/card_illustrations.dart';
import '../widgets/playground_background.dart';
import 'phonics_completion_screen.dart';

class BeginningSoundQuestion {
  BeginningSoundQuestion({
    required this.targetItem,
    required this.choices,
  });

  final PhonicsItem targetItem;
  final List<PhonicsItem> choices;
}

class BeginningSoundsScreen extends StatefulWidget {
  const BeginningSoundsScreen({super.key});

  @override
  State<BeginningSoundsScreen> createState() => _BeginningSoundsScreenState();
}

class _BeginningSoundsScreenState extends State<BeginningSoundsScreen> {
  late List<BeginningSoundQuestion> _questions;
  int _currentIndex = 0;
  int _starsEarned = 0;
  bool _feedbackShowing = false;
  String? _feedbackText;

  @override
  void initState() {
    super.initState();
    _generateQuestions();
    _playTargetAudio();
  }

  void _generateQuestions() {
    final pool = getPhonicsLetterData();
    final rng = Random();
    final questions = <BeginningSoundQuestion>[];

    for (int i = 0; i < 5; i++) {
      final target = pool[i % pool.length];
      final distractors = pool.where((item) => item.letter != target.letter).toList()..shuffle(rng);
      final choices = [target, distractors[0], distractors[1], distractors[2]]..shuffle(rng);
      questions.add(BeginningSoundQuestion(targetItem: target, choices: choices));
    }
    _questions = questions;
  }

  Future<void> _playTargetAudio() async {
    if (_currentIndex >= _questions.length) return;
    final q = _questions[_currentIndex];
    await PronunciationService.speak(LearningCard(
      id: q.targetItem.letter,
      uppercase: q.targetItem.letter,
      lowercase: q.targetItem.letter.toLowerCase(),
      word: q.targetItem.exampleWord,
      emoji: '🔊',
      colorValue: q.targetItem.colorValue,
      imagePath: q.targetItem.imagePath,
      secondaryText: 'Which picture begins with the sound ${q.targetItem.phoneme}?',
    ));
  }

  Future<void> _onChoiceSelected(PhonicsItem choice) async {
    if (_feedbackShowing) return;
    final q = _questions[_currentIndex];

    if (choice.letter == q.targetItem.letter) {
      // Correct!
      _starsEarned++;
      setState(() {
        _feedbackShowing = true;
        _feedbackText = AppLocalizations.tr('games.feedback.correct');
      });

      await Future<void>.delayed(const Duration(milliseconds: 1200));

      if (!mounted) return;
      if (_currentIndex + 1 >= _questions.length) {
        final saved = await ProgressService.loadPhonicsProgress('beginning_sounds');
        final updated = {...saved, 'session_${DateTime.now().millisecondsSinceEpoch}'};
        await ProgressService.savePhonicsProgress('beginning_sounds', updated);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PhonicsCompletionScreen(
              title: AppLocalizations.tr('phonics.beginningSounds.title'),
              completionMessage: 'Fantastic! You identified the beginning sounds!',
              starsEarned: _starsEarned,
              onReplay: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BeginningSoundsScreen(),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        setState(() {
          _currentIndex++;
          _feedbackShowing = false;
          _feedbackText = null;
        });
        _playTargetAudio();
      }
    } else {
      setState(() {
        _feedbackText = AppLocalizations.tr('games.feedback.tryAgain');
      });
      _playTargetAudio();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= _questions.length) return const SizedBox.shrink();
    final q = _questions[_currentIndex];

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
                  AppLocalizations.tr('phonics.beginningSounds.title'),
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
                    '⭐ $_starsEarned',
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
                    'current': '${_currentIndex + 1}',
                    'total': '${_questions.length}',
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
            AppLocalizations.tr('phonics.beginningPrompt', args: {'sound': q.targetItem.phoneme}),
            style: const TextStyle(
              fontSize: 21,
              color: AppTheme.navy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          BouncyButton(
            color: AppTheme.softWhite,
            borderRadius: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            onTap: _playTargetAudio,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.volume_up_rounded, color: AppTheme.navy),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.tr('common.tapToHear'),
                  style: const TextStyle(
                    color: AppTheme.navy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
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
                  final item = q.choices[idx];
                  return Material(
                    color: Color(item.colorValue),
                    borderRadius: BorderRadius.circular(26),
                    elevation: 3,
                    child: InkWell(
                      onTap: () => _onChoiceSelected(item),
                      borderRadius: BorderRadius.circular(26),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.asset(
                              item.imagePath,
                              fit: BoxFit.contain,
                              height: 105,
                              errorBuilder: (_, _, _) => FlashcardIllustration(
                                letterId: item.letter,
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
