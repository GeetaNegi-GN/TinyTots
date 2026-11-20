class LearningCard {
  const LearningCard({
    required this.id,
    required this.uppercase,
    required this.lowercase,
    required this.word,
    required this.emoji,
    required this.colorValue,
    required this.imagePath,
    this.secondaryText,
    this.count,
    this.wordKey,
    this.audioLanguage = 'en',
  });

  final String id;
  final String uppercase;
  final String lowercase;
  final String word;
  final String emoji;
  final int colorValue;
  final String imagePath;
  final String? secondaryText;
  final int? count;
  final String? wordKey;
  final String audioLanguage;

  String get pronunciationText => secondaryText != null
      ? '$word. $secondaryText.'
      : '$uppercase. $word.';
}
