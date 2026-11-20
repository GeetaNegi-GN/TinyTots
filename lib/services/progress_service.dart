import 'package:flutter/services.dart';

class LearningProgress {
  const LearningProgress({required this.explored, required this.lastIndex});
  final Set<String> explored;
  final int lastIndex;
  int get stars => explored.length;
}

class GameProgress {
  const GameProgress({required this.starsEarned, required this.completedRounds});
  final int starsEarned;
  final int completedRounds;
}

/// Uses Android SharedPreferences / iOS UserDefaults through native channel.
class ProgressService {
  static const _channel = MethodChannel('tiny_tots/learning');
  static final Map<String, LearningProgress> _memoryMap = {};
  static final Map<String, GameProgress> _gameMemoryMap = {};
  static final Map<String, Set<String>> _tracingMemoryMap = {};
  static final Map<String, Set<String>> _phonicsMemoryMap = {};

  static Future<LearningProgress> loadCategoryProgress(String categoryId) async {
    try {
      final data = await _channel.invokeMapMethod<String, dynamic>(
        'loadCategoryProgress',
        {'category': categoryId},
      );
      if (data != null && (data['explored'] as String? ?? '').isNotEmpty) {
        final saved = (data['explored'] as String? ?? '')
            .split(',')
            .where((item) => item.isNotEmpty)
            .toSet();
        _memoryMap[categoryId] = LearningProgress(
          explored: saved,
          lastIndex: (data['lastIndex'] as num? ?? 0).toInt(),
        );
      }
    } on PlatformException {
      // Fallback in-memory
    } on MissingPluginException {
      // Fallback in-memory
    }
    return _memoryMap[categoryId] ?? const LearningProgress(explored: {}, lastIndex: 0);
  }

  static Future<void> saveCategoryProgress(
    String categoryId,
    LearningProgress progress,
  ) async {
    _memoryMap[categoryId] = progress;
    try {
      await _channel.invokeMethod<void>('saveCategoryProgress', {
        'category': categoryId,
        'explored': progress.explored.join(','),
        'lastIndex': progress.lastIndex,
      });
    } on PlatformException {
      // Fallback in-memory
    } on MissingPluginException {
      // Fallback in-memory
    }
  }

  static Future<GameProgress> loadGameProgress(String gameId) async {
    try {
      final data = await _channel.invokeMapMethod<String, dynamic>(
        'loadCategoryProgress',
        {'category': 'game_$gameId'},
      );
      if (data != null && (data['explored'] as String? ?? '').isNotEmpty) {
        _gameMemoryMap[gameId] = GameProgress(
          starsEarned: (data['lastIndex'] as num? ?? 0).toInt(),
          completedRounds: (data['explored'] as String? ?? '').split(',').where((x) => x.isNotEmpty).length,
        );
      }
    } on PlatformException {
      // Fallback in-memory
    } on MissingPluginException {
      // Fallback in-memory
    }
    return _gameMemoryMap[gameId] ?? const GameProgress(starsEarned: 0, completedRounds: 0);
  }

  static Future<void> saveGameProgress(
    String gameId, {
    required int starsEarned,
    required int completedRounds,
  }) async {
    _gameMemoryMap[gameId] = GameProgress(
      starsEarned: starsEarned,
      completedRounds: completedRounds,
    );
    try {
      await _channel.invokeMethod<void>('saveCategoryProgress', {
        'category': 'game_$gameId',
        'explored': List.generate(completedRounds, (i) => 'round_$i').join(','),
        'lastIndex': starsEarned,
      });
    } on PlatformException {
      // Fallback in-memory
    } on MissingPluginException {
      // Fallback in-memory
    }
  }

  static Future<Set<String>> loadTracingProgress(String type) async {
    try {
      final data = await _channel.invokeMapMethod<String, dynamic>(
        'loadCategoryProgress',
        {'category': 'tracing_$type'},
      );
      if (data != null && (data['explored'] as String? ?? '').isNotEmpty) {
        final saved = (data['explored'] as String? ?? '')
            .split(',')
            .where((item) => item.isNotEmpty)
            .toSet();
        _tracingMemoryMap[type] = saved;
      }
    } on PlatformException {
      // Fallback in-memory
    } on MissingPluginException {
      // Fallback in-memory
    }
    return _tracingMemoryMap[type] ?? {};
  }

  static Future<void> saveTracingProgress(String type, Set<String> practiced) async {
    _tracingMemoryMap[type] = practiced;
    try {
      await _channel.invokeMethod<void>('saveCategoryProgress', {
        'category': 'tracing_$type',
        'explored': practiced.join(','),
        'lastIndex': practiced.length,
      });
    } on PlatformException {
      // Fallback in-memory
    } on MissingPluginException {
      // Fallback in-memory
    }
  }

  static Future<Set<String>> loadPhonicsProgress(String activityType) async {
    try {
      final data = await _channel.invokeMapMethod<String, dynamic>(
        'loadCategoryProgress',
        {'category': 'phonics_$activityType'},
      );
      if (data != null && (data['explored'] as String? ?? '').isNotEmpty) {
        final saved = (data['explored'] as String? ?? '')
            .split(',')
            .where((item) => item.isNotEmpty)
            .toSet();
        _phonicsMemoryMap[activityType] = saved;
      }
    } on PlatformException {
      // Fallback in-memory
    } on MissingPluginException {
      // Fallback in-memory
    }
    return _phonicsMemoryMap[activityType] ?? {};
  }

  static Future<void> savePhonicsProgress(String activityType, Set<String> explored) async {
    _phonicsMemoryMap[activityType] = explored;
    try {
      await _channel.invokeMethod<void>('saveCategoryProgress', {
        'category': 'phonics_$activityType',
        'explored': explored.join(','),
        'lastIndex': explored.length,
      });
    } on PlatformException {
      // Fallback in-memory
    } on MissingPluginException {
      // Fallback in-memory
    }
  }

  // Backward compatibility methods for ABC category
  static Future<LearningProgress> load() => loadCategoryProgress('abc');
  static Future<void> save(LearningProgress progress) =>
      saveCategoryProgress('abc', progress);
}
