import '../models/learning_level.dart';

const List<LearningLevel> defaultLearningLevels = [
  LearningLevel(
    id: 'level_1',
    titleKey: 'levels.level_1.title',
    descriptionKey: 'levels.level_1.subtitle',
    minAge: 3,
    maxAge: 4,
    sortOrder: 1,
    enabled: true,
    categoryIds: [
      'abc',
      'fruits',
      'vegetables',
      'animals',
      'birds',
      'numbers',
      'colors',
      'shapes',
      'body_parts',
      'days',
      'vehicles',
    ],
    regionalLabels: {
      'US': 'Preschool',
      'IN': 'Kindergarten',
      'UK': 'Reception',
    },
  ),
  LearningLevel(
    id: 'level_2',
    titleKey: 'levels.level_2.title',
    descriptionKey: 'levels.level_2.subtitle',
    minAge: 4,
    maxAge: 5,
    sortOrder: 2,
    enabled: false,
    categoryIds: [],
    regionalLabels: {
      'IN': 'LKG',
      'US': 'Pre-K',
    },
  ),
  LearningLevel(
    id: 'level_3',
    titleKey: 'levels.level_3.title',
    descriptionKey: 'levels.level_3.subtitle',
    minAge: 5,
    maxAge: 6,
    sortOrder: 3,
    enabled: false,
    categoryIds: [],
    regionalLabels: {
      'IN': 'UKG',
      'US': 'Kindergarten',
    },
  ),
];
