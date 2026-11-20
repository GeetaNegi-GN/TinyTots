import 'learning_card.dart';

class LearningCategory {
  const LearningCategory({
    required this.id,
    required this.name,
    required this.illustrationId,
    required this.cards,
    required this.completionMessage,
    this.active = true,
  });

  final String id;
  final String name;
  final String illustrationId;
  final List<LearningCard> cards;
  final String completionMessage;
  final bool active;
}
