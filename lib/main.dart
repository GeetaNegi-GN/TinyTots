import 'dart:math';
import 'package:flutter/material.dart';
import 'data/alphabet_data.dart';
import 'models/learning_card.dart';
import 'services/progress_service.dart';
import 'services/pronunciation_service.dart';
import 'theme/app_theme.dart';
import 'widgets/bouncy_button.dart';
import 'widgets/card_illustrations.dart';
import 'widgets/mascot_widget.dart';
import 'widgets/playground_background.dart';

void main() => runApp(const TinyTotsApp());

class TinyTotsApp extends StatelessWidget {
  const TinyTotsApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'TinyTots',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const WelcomeScreen(),
      );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaygroundBackground(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              children: [
                const BrandHeader(),
                const SizedBox(height: 16),
                const SpeechBubble(
                  title: 'Hello Little Learner! 👋',
                  subtitle: 'What would you like to explore today?',
                ),
                const SizedBox(height: 24),
                ClassCard(
                  title: 'Kindergarten',
                  subtitle: 'Let’s learn together!',
                  illustrationId: 'ABC',
                  color: AppTheme.yellow,
                  action: 'Start Learning',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const KindergartenScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const ClassCard(
                  title: 'LKG',
                  subtitle: 'A new adventure is on its way!',
                  illustrationId: 'Numbers',
                  color: AppTheme.skyBlue,
                  locked: true,
                ),
                const SizedBox(height: 16),
                const ClassCard(
                  title: 'UKG',
                  subtitle: 'A new adventure is on its way!',
                  illustrationId: 'Shapes',
                  color: AppTheme.lavender,
                  locked: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.lavender.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: const OwlMascotWidget(
              pose: OwlPose.waving,
              size: 68,
            ),
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TinyTots',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.navy,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Little Steps, Big Learning!',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      );
}

class SpeechBubble extends StatelessWidget {
  const SpeechBubble({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.softWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.cardShadow(),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              color: AppTheme.navy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.navy.withValues(alpha: 0.8),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ClassCard extends StatelessWidget {
  const ClassCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.illustrationId,
    required this.color,
    this.action,
    this.onTap,
    this.locked = false,
  });

  final String title, subtitle, illustrationId;
  final Color color;
  final String? action;
  final VoidCallback? onTap;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
            boxShadow: AppTheme.cardShadow(shadowColor: color),
            border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.65),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CategoryIllustration(categoryId: illustrationId, size: 44),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        color: AppTheme.navy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.navy.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.navy.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      locked ? Icons.lock_rounded : Icons.play_arrow_rounded,
                      size: 16,
                      color: AppTheme.navy,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      locked ? 'Coming Soon' : action!,
                      style: const TextStyle(
                        fontSize: 12,
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
    );
  }
}

class KindergartenScreen extends StatelessWidget {
  const KindergartenScreen({super.key});

  static const categories = [
    ('ABC / English Alphabet', 'ABC', true),
    ('Fruits', 'Fruits', false),
    ('Vegetables', 'Vegetables', false),
    ('Animals', 'Animals', false),
    ('Birds', 'Birds', false),
    ('Numbers', 'Numbers', false),
    ('Colors', 'Colors', false),
    ('Shapes', 'Shapes', false),
    ('Body Parts', 'Body Parts', false),
    ('Days of the Week', 'Days', false),
  ];

  @override
  Widget build(BuildContext context) {
    return PlaygroundBackground(
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
                const OwlMascotWidget(pose: OwlPose.welcome, size: 48),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kindergarten',
                        style: TextStyle(
                          fontSize: 24,
                          color: AppTheme.navy,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Let’s Start Learning!',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.navy,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => GridView.builder(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth > 560 ? 3 : 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.05,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final item = categories[index];
                  return CategoryTile(
                    title: item.$1,
                    illustrationId: item.$2,
                    active: item.$3,
                    onTap: item.$3
                        ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AbcScreen(),
                              ),
                            )
                        : null,
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

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.title,
    required this.illustrationId,
    required this.active,
    this.onTap,
  });

  final String title, illustrationId;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppTheme.mintGreen : AppTheme.disabledBg.withValues(alpha: 0.7),
      elevation: active ? 3 : 0,
      shadowColor: AppTheme.mintGreen.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    active ? Icons.play_arrow_rounded : Icons.lock_rounded,
                    color: AppTheme.navy,
                    size: 18,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.65),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CategoryIllustration(
                        categoryId: illustrationId,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: AppTheme.navy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    active ? 'Start learning' : 'Coming Soon',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.navy.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AbcScreen extends StatefulWidget {
  const AbcScreen({super.key});

  @override
  State<AbcScreen> createState() => _AbcScreenState();
}

class _AbcScreenState extends State<AbcScreen> {
  PageController? _controller;
  LearningProgress _progress = const LearningProgress(
    explored: {},
    lastIndex: 0,
  );
  int _index = 0;
  int _speakToken = 0;
  bool _ready = false, _speaking = false, _celebrated = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _progress = await ProgressService.load();
    _index = _progress.lastIndex.clamp(0, alphabetCards.length - 1);
    _controller = PageController(initialPage: _index);
    if (!mounted) return;
    setState(() => _ready = true);
    _visit(_index, reward: false);
  }

  Future<void> _visit(int index, {bool reward = true}) async {
    final card = alphabetCards[index];
    final fresh = !_progress.explored.contains(card.id);
    final explored = {..._progress.explored, card.id};
    _progress = LearningProgress(explored: explored, lastIndex: index);
    await ProgressService.save(_progress);
    if (!mounted) return;
    setState(() {});
    if (fresh && reward) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppTheme.navy,
          duration: Duration(seconds: 2),
          content: Row(
            children: [
              Text('⭐', style: TextStyle(fontSize: 22)),
              SizedBox(width: 8),
              Text(
                'Great job! You earned a star!',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      );
    }
    if (fresh && explored.length == alphabetCards.length && !_celebrated) {
      _celebrated = true;
      await Future<void>.delayed(const Duration(milliseconds: 550));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CompletionScreen(stars: explored.length),
          ),
        );
      }
    }
  }

  Future<void> _speak(LearningCard card) async {
    final currentToken = ++_speakToken;
    setState(() => _speaking = true);
    await PronunciationService.speak(card);
    await Future<void>.delayed(const Duration(milliseconds: 2100));
    if (mounted && _speakToken == currentToken) {
      setState(() => _speaking = false);
    }
  }

  void _go(int target) {
    if (target >= 0 && target < alphabetCards.length) {
      _controller?.animateToPage(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    PronunciationService.stop();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        backgroundColor: AppTheme.cream,
        body: Center(child: CircularProgressIndicator(color: AppTheme.navy)),
      );
    }

    return PlaygroundBackground(
      showHills: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
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
                const Text(
                  'ABC Time!',
                  style: TextStyle(
                    fontSize: 22,
                    color: AppTheme.navy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                BouncyButton(
                  color: AppTheme.softWhite,
                  borderRadius: 20,
                  padding: const EdgeInsets.all(10),
                  onTap: () async {
                    final selected = await Navigator.push<int>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AlphabetGrid(progress: _progress),
                      ),
                    );
                    if (selected != null) _go(selected);
                  },
                  child: const Icon(Icons.grid_view_rounded, color: AppTheme.navy),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
            child: ProgressHeader(
              explored: _progress.explored.length,
              index: _index,
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: alphabetCards.length,
              onPageChanged: (index) {
                setState(() => _index = index);
                _visit(index);
              },
              itemBuilder: (context, index) => Flashcard(
                card: alphabetCards[index],
                speaking: _speaking && index == _index,
                onSpeak: () => _speak(alphabetCards[index]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: BouncyButton(
                    color: AppTheme.lavender,
                    onTap: _index == 0 ? null : () => _go(_index - 1),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_rounded, size: 20),
                        SizedBox(width: 8),
                        Text('Previous'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: BouncyButton(
                    color: AppTheme.skyBlue,
                    onTap: _index == 25 ? null : () => _go(_index + 1),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Next'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 20),
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

class ProgressHeader extends StatelessWidget {
  const ProgressHeader({
    super.key,
    required this.explored,
    required this.index,
  });

  final int explored, index;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              Text(
                'Alphabet ${index + 1} of 26',
                style: const TextStyle(
                  color: AppTheme.navy,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
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
                  '⭐ $explored',
                  style: const TextStyle(
                    color: AppTheme.navy,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: (index + 1) / 26,
              minHeight: 12,
              backgroundColor: AppTheme.disabledBg,
              valueColor: const AlwaysStoppedAnimation(AppTheme.mintGreen),
            ),
          ),
        ],
      );
}

class Flashcard extends StatelessWidget {
  const Flashcard({
    super.key,
    required this.card,
    required this.speaking,
    required this.onSpeak,
  });

  final LearningCard card;
  final bool speaking;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              decoration: BoxDecoration(
                color: Color(card.colorValue),
                borderRadius: BorderRadius.circular(36),
                boxShadow: AppTheme.cardShadow(shadowColor: Color(card.colorValue)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.7), width: 3),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onSpeak,
                  borderRadius: BorderRadius.circular(36),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                card.uppercase,
                                style: const TextStyle(
                                  fontSize: 78,
                                  height: 1,
                                  color: AppTheme.navy,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                card.lowercase,
                                style: const TextStyle(
                                  fontSize: 52,
                                  height: 1,
                                  color: AppTheme.navy,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 155,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: AnimatedScale(
                              scale: speaking ? 1.12 : 1.0,
                              duration: const Duration(milliseconds: 230),
                              child: FlashcardIllustration(
                                letterId: card.id,
                                size: 120,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            card.word,
                            style: const TextStyle(
                              fontSize: 28,
                              color: AppTheme.navy,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: speaking ? AppTheme.navy : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.navy.withValues(alpha: 0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  speaking
                                      ? Icons.volume_up_rounded
                                      : Icons.volume_up_outlined,
                                  color: speaking ? Colors.white : AppTheme.navy,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  speaking ? 'Listening...' : 'Tap to hear',
                                  style: TextStyle(
                                    color: speaking ? Colors.white : AppTheme.navy,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
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
            ),
          ),
        ),
      );
}

class AlphabetGrid extends StatelessWidget {
  const AlphabetGrid({super.key, required this.progress});

  final LearningProgress progress;

  @override
  Widget build(BuildContext context) {
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
                const Text(
                  'Pick a letter',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.navy,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: GridView.builder(
                itemCount: alphabetCards.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 90,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final card = alphabetCards[index];
                  final seen = progress.explored.contains(card.id);
                  return Material(
                    color: Color(card.colorValue),
                    borderRadius: BorderRadius.circular(22),
                    child: InkWell(
                      onTap: () => Navigator.pop(context, index),
                      borderRadius: BorderRadius.circular(22),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              card.uppercase,
                              style: const TextStyle(
                                fontSize: 36,
                                color: AppTheme.navy,
                                fontWeight: FontWeight.w900,
                              ),
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

class CompletionScreen extends StatelessWidget {
  const CompletionScreen({super.key, required this.stars});

  final int stars;

  @override
  Widget build(BuildContext context) {
    return PlaygroundBackground(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Confetti(),
              const SizedBox(height: 12),
              const OwlMascotWidget(
                pose: OwlPose.celebrating,
                size: 110,
              ),
              const SizedBox(height: 16),
              const Text(
                'Amazing! You Did It!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  color: AppTheme.navy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You explored all 26 letters\nof the alphabet!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.3,
                  color: AppTheme.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.yellow,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: AppTheme.cardShadow(shadowColor: AppTheme.yellow),
                ),
                child: Text(
                  '26 / 26 explored  •  ⭐ $stars stars',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.navy,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 240,
                child: BouncyButton(
                  color: AppTheme.skyBlue,
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const AbcScreen()),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.replay_rounded, size: 22),
                      SizedBox(width: 8),
                      Text('Replay ABC'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                icon: const Icon(Icons.home_rounded, color: AppTheme.navy),
                label: const Text(
                  'Back to Kindergarten',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.navy,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Confetti extends StatelessWidget {
  const Confetti({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            9,
            (i) => Transform.rotate(
              angle: (i - 4) * pi / 12,
              child: Text(
                i.isEven ? '✨' : '⭐',
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),
        ),
      );
}
