import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/bouncy_button.dart';
import '../widgets/card_illustrations.dart';
import '../widgets/mascot_widget.dart';
import '../widgets/playground_background.dart';
import 'beginning_sounds_screen.dart';
import 'first_words_screen.dart';
import 'letter_sounds_screen.dart';
import 'sound_blending_screen.dart';
import 'sound_picture_match_screen.dart';

class PhonicsHubScreen extends StatelessWidget {
  const PhonicsHubScreen({super.key});

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
                        AppLocalizations.tr('phonics.hub.title'),
                        style: const TextStyle(
                          fontSize: 22,
                          color: AppTheme.navy,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        AppLocalizations.tr('phonics.hub.subtitle'),
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
                PhonicsActivityCard(
                  title: AppLocalizations.tr('phonics.letterSounds.title'),
                  subtitle: AppLocalizations.tr('phonics.letterSounds.description'),
                  illustrationId: 'ABC',
                  color: AppTheme.skyBlue,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LetterSoundsScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                PhonicsActivityCard(
                  title: AppLocalizations.tr('phonics.beginningSounds.title'),
                  subtitle: AppLocalizations.tr('phonics.beginningSounds.description'),
                  illustrationId: 'Animals',
                  color: AppTheme.mintGreen,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BeginningSoundsScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                PhonicsActivityCard(
                  title: AppLocalizations.tr('phonics.soundPictureMatch.title'),
                  subtitle: AppLocalizations.tr('phonics.soundPictureMatch.description'),
                  illustrationId: 'Fruits',
                  color: AppTheme.yellow,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SoundPictureMatchScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                PhonicsActivityCard(
                  title: AppLocalizations.tr('phonics.soundBlending.title'),
                  subtitle: AppLocalizations.tr('phonics.soundBlending.description'),
                  illustrationId: 'Numbers',
                  color: AppTheme.lavender,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SoundBlendingScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                PhonicsActivityCard(
                  title: AppLocalizations.tr('phonics.firstWords.title'),
                  subtitle: AppLocalizations.tr('phonics.firstWords.description'),
                  illustrationId: 'Shapes',
                  color: AppTheme.coral,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FirstWordsScreen(),
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

class PhonicsActivityCard extends StatelessWidget {
  const PhonicsActivityCard({
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.75),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CategoryIllustration(
                    categoryId: illustrationId,
                    size: 38,
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
                        fontSize: 20,
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
                  Icons.volume_up_rounded,
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
