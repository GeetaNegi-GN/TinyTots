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

class LetterSoundsScreen extends StatefulWidget {
  const LetterSoundsScreen({super.key});

  @override
  State<LetterSoundsScreen> createState() => _LetterSoundsScreenState();
}

class _LetterSoundsScreenState extends State<LetterSoundsScreen> {
  Set<String> _explored = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final saved = await ProgressService.loadPhonicsProgress('letter_sounds');
    if (mounted) setState(() => _explored = saved);
  }

  @override
  Widget build(BuildContext context) {
    final dataset = getPhonicsLetterData();

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
                  AppLocalizations.tr('phonics.letterSounds.title'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.navy,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: GridView.builder(
                itemCount: dataset.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 95,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final item = dataset[index];
                  final seen = _explored.contains(item.letter);

                  return Material(
                    color: Color(item.colorValue),
                    borderRadius: BorderRadius.circular(22),
                    elevation: 3,
                    child: InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LetterSoundDetailScreen(
                              dataset: dataset,
                              currentIndex: index,
                            ),
                          ),
                        );
                        _loadProgress();
                      },
                      borderRadius: BorderRadius.circular(22),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.letter,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    color: AppTheme.navy,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  item.phoneme,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.navy.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (seen)
                            const Positioned(
                              right: 6,
                              top: 5,
                              child: Text('⭐', style: TextStyle(fontSize: 14)),
                            ),
                        ],
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

class LetterSoundDetailScreen extends StatefulWidget {
  const LetterSoundDetailScreen({
    super.key,
    required this.dataset,
    required this.currentIndex,
  });

  final List<PhonicsItem> dataset;
  final int currentIndex;

  @override
  State<LetterSoundDetailScreen> createState() => _LetterSoundDetailScreenState();
}

class _LetterSoundDetailScreenState extends State<LetterSoundDetailScreen> {
  late int _idx;

  @override
  void initState() {
    super.initState();
    _idx = widget.currentIndex;
    _visitCurrent();
  }

  PhonicsItem get currentItem => widget.dataset[_idx];

  Future<void> _visitCurrent() async {
    final item = currentItem;
    final saved = await ProgressService.loadPhonicsProgress('letter_sounds');
    if (!saved.contains(item.letter)) {
      final updated = {...saved, item.letter};
      await ProgressService.savePhonicsProgress('letter_sounds', updated);
    }
    _speakCurrent();
  }

  Future<void> _speakCurrent() async {
    final item = currentItem;
    await PronunciationService.speak(LearningCard(
      id: item.letter,
      uppercase: item.letter,
      lowercase: item.letter.toLowerCase(),
      word: item.exampleWord,
      emoji: '🔊',
      colorValue: item.colorValue,
      imagePath: item.imagePath,
      secondaryText: '${item.letter} says ${item.phoneme} as in ${item.exampleWord}',
    ));
  }

  void _goNext() {
    if (_idx < widget.dataset.length - 1) {
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
    final item = currentItem;

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
                  '${item.letter} Sound',
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppTheme.navy,
                    fontWeight: FontWeight.w900,
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
                  color: Color(item.colorValue),
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: AppTheme.cardShadow(shadowColor: Color(item.colorValue)),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.7), width: 3),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.letter,
                            style: const TextStyle(
                              fontSize: 78,
                              height: 1,
                              color: AppTheme.navy,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.letter.toLowerCase(),
                            style: const TextStyle(
                              fontSize: 52,
                              height: 1,
                              color: AppTheme.navy,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.yellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Sound: ${item.phoneme}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.navy,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 150,
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
                            item.imagePath,
                            fit: BoxFit.contain,
                            height: 130,
                            errorBuilder: (_, _, _) => FlashcardIllustration(
                              letterId: item.letter,
                              size: 100,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        item.exampleWord,
                        style: const TextStyle(
                          fontSize: 28,
                          color: AppTheme.navy,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 16),
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
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
                    onTap: _idx == widget.dataset.length - 1 ? null : _goNext,
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
