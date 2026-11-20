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

class SoundBlendingScreen extends StatefulWidget {
  const SoundBlendingScreen({super.key});

  @override
  State<SoundBlendingScreen> createState() => _SoundBlendingScreenState();
}

class _SoundBlendingScreenState extends State<SoundBlendingScreen> {
  late List<BlendingWord> _dataset;
  int _idx = 0;
  int? _activeLetterIdx;
  bool _blended = false;

  @override
  void initState() {
    super.initState();
    _dataset = getCvcBlendingWords();
    _visitCurrent();
  }

  BlendingWord get currentWord => _dataset[_idx];

  Future<void> _visitCurrent() async {
    final word = currentWord;
    final saved = await ProgressService.loadPhonicsProgress('blending');
    if (!saved.contains(word.word)) {
      final updated = {...saved, word.word};
      await ProgressService.savePhonicsProgress('blending', updated);
    }
  }

  Future<void> _speakPhoneme(int letterIndex) async {
    final word = currentWord;
    setState(() => _activeLetterIdx = letterIndex);

    final ph = word.phonemes[letterIndex];
    final letter = word.letters[letterIndex];

    await PronunciationService.speak(LearningCard(
      id: letter,
      uppercase: letter,
      lowercase: letter.toLowerCase(),
      word: ph,
      emoji: '🔊',
      colorValue: word.colorValue,
      imagePath: word.imagePath,
      secondaryText: 'Sound $ph',
    ));

    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (mounted) setState(() => _activeLetterIdx = null);
  }

  Future<void> _blendFullWord() async {
    final word = currentWord;
    for (int i = 0; i < word.letters.length; i++) {
      setState(() => _activeLetterIdx = i);
      final ph = word.phonemes[i];
      final letter = word.letters[i];
      await PronunciationService.speak(LearningCard(
        id: letter,
        uppercase: letter,
        lowercase: letter.toLowerCase(),
        word: ph,
        emoji: '🔊',
        colorValue: word.colorValue,
        imagePath: word.imagePath,
        secondaryText: ph,
      ));
      await Future<void>.delayed(const Duration(milliseconds: 700));
    }

    if (!mounted) return;
    setState(() {
      _activeLetterIdx = null;
      _blended = true;
    });

    // Speak blended full word
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
      setState(() {
        _idx++;
        _activeLetterIdx = null;
        _blended = false;
      });
      _visitCurrent();
    }
  }

  void _goPrev() {
    if (_idx > 0) {
      setState(() {
        _idx--;
        _activeLetterIdx = null;
        _blended = false;
      });
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
                  AppLocalizations.tr('phonics.soundBlending.title'),
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
                    'category': 'Blending',
                    'index': '${_idx + 1}',
                    'total': '${_dataset.length}',
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Individual Letter Tiles (C - A - T)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(word.letters.length, (i) {
                          final isActive = _activeLetterIdx == i;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: BouncyButton(
                              color: isActive ? AppTheme.yellow : Colors.white,
                              borderRadius: 22,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              onTap: () => _speakPhoneme(i),
                              child: Column(
                                children: [
                                  Text(
                                    word.letters[i],
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.navy,
                                    ),
                                  ),
                                  Text(
                                    word.phonemes[i],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.navy.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 18),
                      // Blend Action Button
                      BouncyButton(
                        color: AppTheme.skyBlue,
                        borderRadius: 26,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        onTap: _blendFullWord,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.volume_up_rounded, color: AppTheme.navy, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.tr('phonics.blendButton'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.navy,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Real Photograph Image Container (revealed on blending or tap)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 140,
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
                        child: _blended
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.asset(
                                  word.imagePath,
                                  fit: BoxFit.contain,
                                  height: 120,
                                  errorBuilder: (_, _, _) => FlashcardIllustration(
                                    letterId: word.word.substring(0, 1),
                                    size: 90,
                                  ),
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.touch_app_rounded, color: AppTheme.navy, size: 36),
                                  const SizedBox(height: 4),
                                  Text(
                                    AppLocalizations.tr('phonics.blendPrompt'),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.navy.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      if (_blended) ...[
                        const SizedBox(height: 10),
                        Text(
                          word.word,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.navy,
                          ),
                        ),
                      ],
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
