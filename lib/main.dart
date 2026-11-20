import 'dart:math';
import 'package:flutter/material.dart';
import 'config/learning_levels.dart';
import 'data/category_data.dart';
import 'games/game_zone_screen.dart';
import 'localization/app_localizations.dart';
import 'phonics/phonics_hub_screen.dart';
import 'tracing/trace_hub_screen.dart';
import 'models/learning_card.dart';
import 'models/learning_category.dart';
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
        title: AppLocalizations.tr('app.title'),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const WelcomeScreen(),
      );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final level1 = defaultLearningLevels[0];
    final level2 = defaultLearningLevels[1];
    final level3 = defaultLearningLevels[2];

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
                SpeechBubble(
                  title: AppLocalizations.tr('app.welcomeTitle'),
                  subtitle: AppLocalizations.tr('app.welcomeSubtitle'),
                ),
                const SizedBox(height: 24),
                ClassCard(
                  title: AppLocalizations.tr(level1.titleKey),
                  subtitle: AppLocalizations.tr(level1.descriptionKey),
                  illustrationId: 'ABC',
                  color: AppTheme.yellow,
                  action: AppLocalizations.tr('common.startLearning'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const KindergartenScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ClassCard(
                  title: AppLocalizations.tr(level2.titleKey),
                  subtitle: AppLocalizations.tr(level2.descriptionKey),
                  illustrationId: 'Numbers',
                  color: AppTheme.skyBlue,
                  locked: true,
                ),
                const SizedBox(height: 16),
                ClassCard(
                  title: AppLocalizations.tr(level3.titleKey),
                  subtitle: AppLocalizations.tr(level3.descriptionKey),
                  illustrationId: 'Shapes',
                  color: AppTheme.lavender,
                  locked: true,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: BouncyButton(
                        color: AppTheme.mintGreen,
                        borderRadius: 26,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GameZoneScreen(),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.videogame_asset_rounded, color: AppTheme.navy, size: 22),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                AppLocalizations.tr('common.playAndLearn'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.navy,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BouncyButton(
                        color: AppTheme.skyBlue,
                        borderRadius: 26,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TraceHubScreen(),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.edit_rounded, color: AppTheme.navy, size: 22),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                AppLocalizations.tr('common.traceAndWrite'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.navy,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                BouncyButton(
                  color: AppTheme.coral,
                  borderRadius: 26,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PhonicsHubScreen(),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.volume_up_rounded, color: AppTheme.navy, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.tr('common.soundsAndWords'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.navy,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.tr('app.title'),
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.navy,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                AppLocalizations.tr('app.tagline'),
                style: const TextStyle(
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
                      locked ? AppLocalizations.tr('common.comingSoon') : action!,
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

class KindergartenScreen extends StatefulWidget {
  const KindergartenScreen({super.key});

  @override
  State<KindergartenScreen> createState() => _KindergartenScreenState();
}

class _KindergartenScreenState extends State<KindergartenScreen> {
  final Map<String, LearningProgress> _progressMap = {};

  @override
  void initState() {
    super.initState();
    _loadProgresses();
  }

  Future<void> _loadProgresses() async {
    for (final cat in kindergartenCategories) {
      final p = await ProgressService.loadCategoryProgress(cat.id);
      _progressMap[cat.id] = p;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final level1 = defaultLearningLevels[0];

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.tr(level1.titleKey),
                        style: const TextStyle(
                          fontSize: 24,
                          color: AppTheme.navy,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        AppLocalizations.tr('levels.level_1.description'),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.navy,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                BouncyButton(
                  color: AppTheme.softWhite,
                  borderRadius: 20,
                  padding: const EdgeInsets.all(10),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PhonicsHubScreen(),
                    ),
                  ),
                  child: const Icon(Icons.volume_up_rounded, color: AppTheme.navy),
                ),
                const SizedBox(width: 8),
                BouncyButton(
                  color: AppTheme.softWhite,
                  borderRadius: 20,
                  padding: const EdgeInsets.all(10),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GameZoneScreen(),
                    ),
                  ),
                  child: const Icon(Icons.videogame_asset_rounded, color: AppTheme.navy),
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
                  childAspectRatio: 1.02,
                ),
                itemCount: kindergartenCategories.length,
                itemBuilder: (context, index) {
                  final cat = kindergartenCategories[index];
                  final prog = _progressMap[cat.id] ??
                      const LearningProgress(explored: {}, lastIndex: 0);
                  return CategoryTile(
                    category: cat,
                    progress: prog,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryLearningScreen(category: cat),
                        ),
                      );
                      _loadProgresses();
                    },
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
    required this.category,
    required this.progress,
    required this.onTap,
  });

  final LearningCategory category;
  final LearningProgress progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final total = category.cards.length;
    final exploredCount = progress.explored.length;
    final isDone = exploredCount == total;

    return Material(
      color: isDone ? AppTheme.yellow : AppTheme.mintGreen,
      elevation: 3,
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
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isDone ? Icons.check_circle_rounded : Icons.play_arrow_rounded,
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
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CategoryIllustration(
                        categoryId: category.illustrationId,
                        size: 34,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: AppTheme.navy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isDone
                        ? AppLocalizations.tr('learning.completedBadge')
                        : AppLocalizations.tr('learning.exploredStatus', args: {
                            'explored': '$exploredCount',
                            'total': '$total',
                          }),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.navy.withValues(alpha: 0.85),
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

class CategoryLearningScreen extends StatefulWidget {
  const CategoryLearningScreen({super.key, required this.category});

  final LearningCategory category;

  @override
  State<CategoryLearningScreen> createState() => _CategoryLearningScreenState();
}

class AbcScreen extends StatelessWidget {
  const AbcScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      CategoryLearningScreen(category: kindergartenCategories.first);
}

class _CategoryLearningScreenState extends State<CategoryLearningScreen> {
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
    _progress = await ProgressService.loadCategoryProgress(widget.category.id);
    _index = _progress.lastIndex.clamp(0, widget.category.cards.length - 1);
    _controller = PageController(initialPage: _index);
    if (!mounted) return;
    setState(() => _ready = true);
    _visit(_index, reward: false);
  }

  Future<void> _visit(int index, {bool reward = true}) async {
    final card = widget.category.cards[index];
    final fresh = !_progress.explored.contains(card.id);
    final explored = {..._progress.explored, card.id};
    _progress = LearningProgress(explored: explored, lastIndex: index);
    await ProgressService.saveCategoryProgress(widget.category.id, _progress);
    if (!mounted) return;
    setState(() {});
    if (fresh && reward) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.navy,
          duration: const Duration(seconds: 2),
          content: Row(
            children: [
              const Text('⭐', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.tr('learning.earnedStar'),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      );
    }
    if (fresh && explored.length == widget.category.cards.length && !_celebrated) {
      _celebrated = true;
      await Future<void>.delayed(const Duration(milliseconds: 550));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CompletionScreen(
              category: widget.category,
              stars: explored.length,
            ),
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
    if (target >= 0 && target < widget.category.cards.length) {
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

    final categoryShort = widget.category.name.split(' / ').first;

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
                Text(
                  AppLocalizations.tr('learning.timeTitle', args: {'category': categoryShort}),
                  style: const TextStyle(
                    fontSize: 20,
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
                        builder: (_) => CategoryGrid(
                          category: widget.category,
                          progress: _progress,
                        ),
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
              categoryName: categoryShort,
              explored: _progress.explored.length,
              index: _index,
              total: widget.category.cards.length,
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.category.cards.length,
              onPageChanged: (index) {
                setState(() => _index = index);
                _visit(index);
              },
              itemBuilder: (context, index) => Flashcard(
                card: widget.category.cards[index],
                speaking: _speaking && index == _index,
                onSpeak: () => _speak(widget.category.cards[index]),
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
                    onTap: _index == widget.category.cards.length - 1
                        ? null
                        : () => _go(_index + 1),
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

class ProgressHeader extends StatelessWidget {
  const ProgressHeader({
    super.key,
    required this.categoryName,
    required this.explored,
    required this.index,
    required this.total,
  });

  final String categoryName;
  final int explored, index, total;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.tr('learning.progress', args: {
                  'category': categoryName,
                  'index': '${index + 1}',
                  'total': '$total',
                }),
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
              value: (index + 1) / total,
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
                                  fontSize: 70,
                                  height: 1,
                                  color: AppTheme.navy,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              if (card.lowercase != card.uppercase && card.lowercase.length <= 4) ...[
                                const SizedBox(width: 10),
                                Text(
                                  card.lowercase,
                                  style: const TextStyle(
                                    fontSize: 44,
                                    height: 1,
                                    color: AppTheme.navy,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 165,
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
                            child: AnimatedScale(
                              scale: speaking ? 1.08 : 1.0,
                              duration: const Duration(milliseconds: 230),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.asset(
                                  card.imagePath,
                                  fit: BoxFit.contain,
                                  height: 145,
                                  errorBuilder: (context, error, stackTrace) =>
                                      FlashcardIllustration(
                                    letterId: card.id.toUpperCase(),
                                    size: 120,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            card.word,
                            style: const TextStyle(
                              fontSize: 27,
                              color: AppTheme.navy,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          if (card.secondaryText != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              card.secondaryText!,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.navy.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
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
                                  speaking
                                      ? AppLocalizations.tr('common.listening')
                                      : AppLocalizations.tr('common.tapToHear'),
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

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    super.key,
    required this.category,
    required this.progress,
  });

  final LearningCategory category;
  final LearningProgress progress;

  @override
  Widget build(BuildContext context) {
    final catShort = category.name.split(' / ').first;

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
                  AppLocalizations.tr('common.pickCategory', args: {'category': catShort}),
                  style: const TextStyle(
                    fontSize: 20,
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
                itemCount: category.cards.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 95,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final card = category.cards[index];
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
                              card.uppercase.length <= 3
                                  ? card.uppercase
                                  : card.word.substring(0, 1),
                              style: const TextStyle(
                                fontSize: 32,
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

class AlphabetGrid extends StatelessWidget {
  const AlphabetGrid({super.key, required this.progress});

  final LearningProgress progress;

  @override
  Widget build(BuildContext context) => CategoryGrid(
        category: kindergartenCategories.first,
        progress: progress,
      );
}

class CompletionScreen extends StatelessWidget {
  const CompletionScreen({
    super.key,
    required this.stars,
    this.category,
  });

  final int stars;
  final LearningCategory? category;

  @override
  Widget build(BuildContext context) {
    final cat = category ?? kindergartenCategories.first;
    final total = cat.cards.length;
    final catShort = cat.name.split(' / ').first;

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
              Text(
                AppLocalizations.tr('common.amazing'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  color: AppTheme.navy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cat.completionMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
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
                  '$total / $total explored  •  ⭐ $stars stars',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.navy,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 220, maxWidth: 320),
                child: BouncyButton(
                  color: AppTheme.skyBlue,
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryLearningScreen(category: cat),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.replay_rounded, size: 22),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          AppLocalizations.tr('common.replay', args: {'category': catShort}),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                icon: const Icon(Icons.home_rounded, color: AppTheme.navy),
                label: Text(
                  AppLocalizations.tr('common.backToKindergarten'),
                  style: const TextStyle(
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
