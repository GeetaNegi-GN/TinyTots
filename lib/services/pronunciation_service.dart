import 'package:flutter/services.dart';
import '../models/learning_card.dart';

class PronunciationService {
  static const _channel = MethodChannel('tiny_tots/learning');
  static Future<void> speak(LearningCard card) async {
    try {
      await _channel.invokeMethod<void>('speak', {
        'text': card.pronunciationText,
      });
    } on PlatformException {
      // Speech is unavailable in this preview environment.
    } on MissingPluginException {
      // Speech is unavailable in this preview environment.
    }
  }

  static Future<void> stop() async {
    try {
      await _channel.invokeMethod<void>('stop');
    } on PlatformException {
      // No native speaker to stop in this preview environment.
    } on MissingPluginException {
      // No native speaker to stop in this preview environment.
    }
  }
}
