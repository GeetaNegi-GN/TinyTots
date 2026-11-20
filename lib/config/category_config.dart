class CategoryConfig {
  const CategoryConfig({
    required this.id,
    required this.titleKey,
    required this.completionMessageKey,
    required this.illustrationId,
    required this.sortOrder,
    required this.levelIds,
    this.enabled = true,
    this.locked = false,
  });

  final String id;
  final String titleKey;
  final String completionMessageKey;
  final String illustrationId;
  final int sortOrder;
  final List<String> levelIds;
  final bool enabled;
  final bool locked;
}

const List<CategoryConfig> defaultCategoryConfigs = [
  CategoryConfig(id: 'abc', titleKey: 'categories.abc.title', completionMessageKey: 'categories.abc.completion', illustrationId: 'ABC', sortOrder: 1, levelIds: ['level_1']),
  CategoryConfig(id: 'fruits', titleKey: 'categories.fruits.title', completionMessageKey: 'categories.fruits.completion', illustrationId: 'Fruits', sortOrder: 2, levelIds: ['level_1']),
  CategoryConfig(id: 'vegetables', titleKey: 'categories.vegetables.title', completionMessageKey: 'categories.vegetables.completion', illustrationId: 'Vegetables', sortOrder: 3, levelIds: ['level_1']),
  CategoryConfig(id: 'animals', titleKey: 'categories.animals.title', completionMessageKey: 'categories.animals.completion', illustrationId: 'Animals', sortOrder: 4, levelIds: ['level_1']),
  CategoryConfig(id: 'birds', titleKey: 'categories.birds.title', completionMessageKey: 'categories.birds.completion', illustrationId: 'Birds', sortOrder: 5, levelIds: ['level_1']),
  CategoryConfig(id: 'numbers', titleKey: 'categories.numbers.title', completionMessageKey: 'categories.numbers.completion', illustrationId: 'Numbers', sortOrder: 6, levelIds: ['level_1']),
  CategoryConfig(id: 'colors', titleKey: 'categories.colors.title', completionMessageKey: 'categories.colors.completion', illustrationId: 'Colors', sortOrder: 7, levelIds: ['level_1']),
  CategoryConfig(id: 'shapes', titleKey: 'categories.shapes.title', completionMessageKey: 'categories.shapes.completion', illustrationId: 'Shapes', sortOrder: 8, levelIds: ['level_1']),
  CategoryConfig(id: 'body_parts', titleKey: 'categories.body_parts.title', completionMessageKey: 'categories.body_parts.completion', illustrationId: 'Body Parts', sortOrder: 9, levelIds: ['level_1']),
  CategoryConfig(id: 'days', titleKey: 'categories.days.title', completionMessageKey: 'categories.days.completion', illustrationId: 'Days', sortOrder: 10, levelIds: ['level_1']),
  CategoryConfig(id: 'vehicles', titleKey: 'categories.vehicles.title', completionMessageKey: 'categories.vehicles.completion', illustrationId: 'Vehicles', sortOrder: 11, levelIds: ['level_1']),
];
