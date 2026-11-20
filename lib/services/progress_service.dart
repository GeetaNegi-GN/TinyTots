import 'package:flutter/services.dart';

class LearningProgress {
  const LearningProgress({required this.explored, required this.lastIndex});
  final Set<String> explored;
  final int lastIndex;
  int get stars => explored.length;
}

/// Uses Android SharedPreferences / iOS UserDefaults through a native channel.
class ProgressService {
  static const _channel = MethodChannel('tiny_tots/learning');
  static LearningProgress _memory = const LearningProgress(
    explored: {},
    lastIndex: 0,
  );
  static Future<LearningProgress> load() async {
    try {
      final data = await _channel.invokeMapMethod<String, dynamic>(
        'loadProgress',
      );
      final saved = (data?['explored'] as String? ?? '')
          .split(',')
          .where((letter) => letter.isNotEmpty)
          .toSet();
      _memory = LearningProgress(
        explored: saved,
        lastIndex: (data?['lastIndex'] as num? ?? 0).toInt().clamp(0, 25),
      );
    } on PlatformException {
      // Preview platform: retain in-memory progress.
    } on MissingPluginException {
      // Preview platform: retain in-memory progress.
    }
    return _memory;
  }

  static Future<void> save(LearningProgress progress) async {
    _memory = progress;
    try {
      await _channel.invokeMethod<void>('saveProgress', {
        'explored': progress.explored.join(','),
        'lastIndex': progress.lastIndex,
      });
    } on PlatformException {
      // Preview platform: progress is already in memory.
    } on MissingPluginException {
      // Preview platform: progress is already in memory.
    }
  }
}
