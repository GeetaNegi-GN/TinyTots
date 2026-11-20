class LearningLevel {
  const LearningLevel({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.minAge,
    required this.maxAge,
    required this.sortOrder,
    required this.enabled,
    required this.categoryIds,
    this.regionalLabels,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final int minAge;
  final int maxAge;
  final int sortOrder;
  final bool enabled;
  final List<String> categoryIds;
  final Map<String, String>? regionalLabels;
}
