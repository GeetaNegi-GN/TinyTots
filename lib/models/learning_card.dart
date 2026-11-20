class LearningCard {
  const LearningCard({
    required this.id,
    required this.uppercase,
    required this.lowercase,
    required this.word,
    required this.emoji,
    required this.colorValue,
  });
  final String id;
  final String uppercase;
  final String lowercase;
  final String word;
  final String emoji;
  final int colorValue;
  String get pronunciationText => '$uppercase. $word.';
}
