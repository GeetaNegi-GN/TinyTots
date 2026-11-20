import 'dart:math';
import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/bouncy_button.dart';
import '../widgets/mascot_widget.dart';
import '../widgets/playground_background.dart';

class PhonicsCompletionScreen extends StatelessWidget {
  const PhonicsCompletionScreen({
    super.key,
    required this.title,
    required this.completionMessage,
    required this.starsEarned,
    required this.onReplay,
  });

  final String title;
  final String completionMessage;
  final int starsEarned;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    return PlaygroundBackground(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PhonicsConfetti(),
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
                  fontSize: 30,
                  color: AppTheme.navy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                completionMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
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
                  '⭐ $starsEarned stars earned!',
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
                  onTap: onReplay,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.replay_rounded, size: 22),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.tr('common.playAgain')),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.volume_up_rounded, color: AppTheme.navy),
                label: Text(
                  AppLocalizations.tr('common.backToPhonicsHub'),
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

class PhonicsConfetti extends StatelessWidget {
  const PhonicsConfetti({super.key});

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
