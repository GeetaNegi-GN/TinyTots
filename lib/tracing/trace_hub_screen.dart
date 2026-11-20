import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/bouncy_button.dart';
import '../widgets/card_illustrations.dart';
import '../widgets/mascot_widget.dart';
import '../widgets/playground_background.dart';
import 'free_practice_screen.dart';
import 'letter_selection_screen.dart';
import 'number_selection_screen.dart';

class TraceHubScreen extends StatelessWidget {
  const TraceHubScreen({super.key});

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.tr('tracing.hub.title'),
                        style: const TextStyle(
                          fontSize: 22,
                          color: AppTheme.navy,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        AppLocalizations.tr('tracing.hub.subtitle'),
                        style: const TextStyle(
                          fontSize: 13,
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
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              children: [
                TraceActivityCard(
                  title: AppLocalizations.tr('tracing.letters.title'),
                  subtitle: AppLocalizations.tr('tracing.letters.description'),
                  illustrationId: 'ABC',
                  color: AppTheme.skyBlue,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LetterSelectionScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TraceActivityCard(
                  title: AppLocalizations.tr('tracing.numbers.title'),
                  subtitle: AppLocalizations.tr('tracing.numbers.description'),
                  illustrationId: 'Numbers',
                  color: AppTheme.yellow,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NumberSelectionScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TraceActivityCard(
                  title: AppLocalizations.tr('tracing.freePractice.title'),
                  subtitle: AppLocalizations.tr('tracing.freePractice.description'),
                  illustrationId: 'Colors',
                  color: AppTheme.lavender,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FreePracticeScreen(),
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

class TraceActivityCard extends StatelessWidget {
  const TraceActivityCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.illustrationId,
    required this.color,
    required this.onTap,
  });

  final String title, subtitle, illustrationId;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(28),
      elevation: 3,
      shadowColor: color.withValues(alpha: 0.4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.75),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CategoryIllustration(
                    categoryId: illustrationId,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.navy,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.navy.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: AppTheme.navy,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
