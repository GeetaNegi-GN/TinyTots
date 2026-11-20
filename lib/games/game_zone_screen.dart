import 'package:flutter/material.dart';
import '../config/game_config.dart';
import '../localization/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/bouncy_button.dart';
import '../widgets/card_illustrations.dart';
import '../widgets/mascot_widget.dart';
import '../widgets/playground_background.dart';
import 'count_objects_game.dart';
import 'listen_choose_game.dart';
import 'match_letters_game.dart';
import 'match_pictures_game.dart';
import 'memory_match_game.dart';

class GameZoneScreen extends StatelessWidget {
  const GameZoneScreen({super.key});

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
                        AppLocalizations.tr('games.zone.title'),
                        style: const TextStyle(
                          fontSize: 22,
                          color: AppTheme.navy,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        AppLocalizations.tr('games.zone.subtitle'),
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
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              itemCount: defaultGameConfigs.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final cfg = defaultGameConfigs[index];
                return GameCardTile(
                  config: cfg,
                  onTap: () {
                    Widget screen;
                    switch (cfg.id) {
                      case 'listen_choose':
                        screen = ListenChooseGameScreen(config: cfg);
                        break;
                      case 'match_pictures':
                        screen = MatchPicturesGameScreen(config: cfg);
                        break;
                      case 'match_letters':
                        screen = MatchLettersGameScreen(config: cfg);
                        break;
                      case 'memory_match':
                        screen = MemoryMatchGameScreen(config: cfg);
                        break;
                      case 'count_objects':
                        screen = CountObjectsGameScreen(config: cfg);
                        break;
                      default:
                        screen = ListenChooseGameScreen(config: cfg);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => screen),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GameCardTile extends StatelessWidget {
  const GameCardTile({
    super.key,
    required this.config,
    required this.onTap,
  });

  final GameConfig config;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: config.color,
      borderRadius: BorderRadius.circular(28),
      elevation: 3,
      shadowColor: config.color.withValues(alpha: 0.4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
                    categoryId: config.illustrationId,
                    size: 38,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.tr(config.titleKey),
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.navy,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      AppLocalizations.tr(config.descriptionKey),
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
                  Icons.play_arrow_rounded,
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
