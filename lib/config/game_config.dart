import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GameConfig {
  const GameConfig({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.illustrationId,
    required this.color,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final String illustrationId;
  final Color color;
}

const List<GameConfig> defaultGameConfigs = [
  GameConfig(
    id: 'listen_choose',
    titleKey: 'games.listenChoose.title',
    descriptionKey: 'games.listenChoose.description',
    illustrationId: 'ABC',
    color: AppTheme.skyBlue,
  ),
  GameConfig(
    id: 'match_pictures',
    titleKey: 'games.matchPictures.title',
    descriptionKey: 'games.matchPictures.description',
    illustrationId: 'Fruits',
    color: AppTheme.mintGreen,
  ),
  GameConfig(
    id: 'match_letters',
    titleKey: 'games.matchLetters.title',
    descriptionKey: 'games.matchLetters.description',
    illustrationId: 'ABC',
    color: AppTheme.lavender,
  ),
  GameConfig(
    id: 'memory_match',
    titleKey: 'games.memoryMatch.title',
    descriptionKey: 'games.memoryMatch.description',
    illustrationId: 'Animals',
    color: AppTheme.coral,
  ),
  GameConfig(
    id: 'count_objects',
    titleKey: 'games.countObjects.title',
    descriptionKey: 'games.countObjects.description',
    illustrationId: 'Numbers',
    color: AppTheme.yellow,
  ),
];
