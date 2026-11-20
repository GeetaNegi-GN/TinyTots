import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_tots/config/category_config.dart';
import 'package:tiny_tots/config/learning_levels.dart';
import 'package:tiny_tots/data/category_data.dart';
import 'package:tiny_tots/localization/app_localizations.dart';

void main() {
  group('AppLocalizations & Localization Architecture', () {
    test('Translates keys accurately with argument replacement', () {
      expect(AppLocalizations.tr('app.title'), 'TinyTots');
      expect(AppLocalizations.tr('app.tagline'), 'Little Steps, Big Learning!');
      expect(
        AppLocalizations.tr('common.pickCategory', args: {'category': 'ABC'}),
        'Pick a ABC',
      );
      expect(
        AppLocalizations.tr('learning.exploredStatus', args: {'explored': '5', 'total': '20'}),
        '5 / 20 explored',
      );
    });

    test('Falls back safely to raw key if translation key is missing', () {
      const missingKey = 'non_existent_key_xyz';
      expect(AppLocalizations.tr(missingKey), missingKey);
    });
  });

  group('Generic Learning Levels Architecture', () {
    test('Default levels contain level_1, level_2, and level_3 with stable IDs', () {
      expect(defaultLearningLevels.length, 3);
      expect(defaultLearningLevels[0].id, 'level_1');
      expect(defaultLearningLevels[1].id, 'level_2');
      expect(defaultLearningLevels[2].id, 'level_3');
    });

    test('Level 1 is enabled and associates with active categories', () {
      final level1 = defaultLearningLevels.firstWhere((l) => l.id == 'level_1');
      expect(level1.enabled, isTrue);
      expect(level1.minAge, 3);
      expect(level1.maxAge, 4);
      expect(level1.categoryIds, containsAll(['abc', 'fruits', 'animals']));
    });

    test('Levels support optional regional labels configuration structure', () {
      final level1 = defaultLearningLevels.firstWhere((l) => l.id == 'level_1');
      expect(level1.regionalLabels, isNotNull);
      expect(level1.regionalLabels!['US'], 'Preschool');
      expect(level1.regionalLabels!['IN'], 'Kindergarten');
      expect(level1.regionalLabels!['UK'], 'Reception');
    });
  });

  group('Configurable Category Architecture', () {
    test('Default category configurations have stable IDs and level associations', () {
      expect(defaultCategoryConfigs.length, 11);
      for (final cfg in defaultCategoryConfigs) {
        expect(cfg.id.isNotEmpty, isTrue);
        expect(cfg.titleKey.startsWith('categories.'), isTrue);
        expect(cfg.levelIds, contains('level_1'));
      }
    });

    test('Learning datasets bind to CategoryConfig IDs', () {
      final configIds = defaultCategoryConfigs.map((c) => c.id).toSet();
      for (final cat in kindergartenCategories) {
        expect(configIds.contains(cat.id), isTrue);
      }
    });
  });

  group('Content Models & Language Preparation', () {
    test('LearningCard supports audio language configuration and stable content IDs', () {
      final fruitCard = kindergartenCategories
          .firstWhere((c) => c.id == 'fruits')
          .cards
          .first;

      expect(fruitCard.id, 'apple');
      expect(fruitCard.audioLanguage, 'en');
      expect(fruitCard.imagePath.startsWith('assets/learning/fruits/'), isTrue);
    });
  });
}
