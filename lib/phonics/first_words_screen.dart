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

class FirstWordsScreen extends StatefulWidget {
  const FirstWordsScreen({super.key});

  @override
  State<FirstWordsScreen> createState() => _FirstWordsScreenState();
}

class _FirstWordsScreenState extends State<FirstWordsScreen> {
  late List<BlendingWord> _dataset;
  int _idx = 0;
  Set<String> _explored = {};

  @override
  void initState() {
    super.initState();
    _dataset = getCvcBlendingWords();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final saved = await ProgressService.loadPhonicsProgress('first_words');
    if (mounted) setState(() => _explored = saved);
    _visitCurrent();
  }

  BlendingWord get currentWord => _dataset[_idx];

  Future<void> _visitCurrent() async {
    final word = currentWord;
    if (!_explored.contains(word.word)) {
      final updated = {..._explored, word.word};
      await ProgressService.savePhonicsProgress('first_words', updated);
      if (mounted) setState(() => _explored = updated);
    }
    _speakCurrent();
  }

  Future<void> _speakCurrent() async {
    final word = currentWord;
    await PronunciationService.speak(LearningCard(
      id: word.word,
      uppercase: word.word,
      lowercase: word.word.toLowerCase(),
      word: word.word,
      emoji: '🔊',
      colorValue: word.colorValue,
      imagePath: word.imagePath,
      secondaryText: word.word,
    ));
  }

  void _goNext() {
    if (_idx < _dataset.length - 1) {
      setState(() => _idx++);
      _visitCurrent();
    }
  }

  void _goPrev() {
    if (_idx > 0) {
      setState(() => _idx--);
      _visitCurrent();
    }
  }

  @override
  Widget build(BuildContext context) {
    final word = currentWord;

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
                const SizedBox(width: 14),
                Text(
                  AppLocalizations.tr('phonics.firstWords.title'),
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppTheme.navy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                Text(
                  AppLocalizations.tr('learning.progress', args: {
                    'category': 'Words',
                    'index': '${_idx + 1}',
                    'total': '${_dataset.length}',
                  }),
                  style: const TextStyle(
                    color: AppTheme.navy,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
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
                    '⭐ ${_explored.length}',
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
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(word.colorValue),
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: AppTheme.cardShadow(shadowColor: Color(word.colorValue)),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.7), width: 3),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        word.word,
                        style: const TextStyle(
                          fontSize: 64,
                          height: 1,
                          color: AppTheme.navy,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 160,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.navy.withValues(alpha: 0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            word.imagePath,
                            fit: BoxFit.contain,
                            height: 140,
                            errorBuilder: (_, _, _) => FlashcardIllustration(
                              letterId: word.word.substring(0, 1),
                              size: 100,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      BouncyButton(
                        color: AppTheme.softWhite,
                        borderRadius: 28,
                        onTap: _speakCurrent,
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
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: BouncyButton(
                    color: AppTheme.lavender,
                    onTap: _idx == 0 ? null : _goPrev,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_back_rounded, size: 20),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.tr('common.previous')),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: BouncyButton(
                    color: AppTheme.skyBlue,
                    onTap: _idx == _dataset.length - 1 ? null : _goNext,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.tr('common.next')),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
