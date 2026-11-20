import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_tots/models/learning_card.dart';

void main() {
  test('LearningCard properties, imagePath, and pronunciation text format', () {
    const card = LearningCard(
      id: 'A',
      uppercase: 'A',
      lowercase: 'a',
      word: 'Apple',
      emoji: '🍎',
      colorValue: 0xFFFFD5D5,
      imagePath: 'assets/images/alphabet/a_apple.jpg',
    );

    expect(card.id, 'A');
    expect(card.uppercase, 'A');
    expect(card.lowercase, 'a');
    expect(card.word, 'Apple');
    expect(card.emoji, '🍎');
    expect(card.colorValue, 0xFFFFD5D5);
    expect(card.imagePath, 'assets/images/alphabet/a_apple.jpg');
    expect(card.pronunciationText, 'A. Apple.');
  });
}
