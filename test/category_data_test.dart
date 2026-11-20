import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_tots/data/category_data.dart';

void main() {
  test('Kindergarten categories dataset contains all 11 active categories', () {
    expect(kindergartenCategories.length, 11);

    final catMap = {for (var c in kindergartenCategories) c.id: c};

    expect(catMap.containsKey('abc'), isTrue);
    expect(catMap['abc']!.cards.length, 26);

    expect(catMap.containsKey('fruits'), isTrue);
    expect(catMap['fruits']!.cards.length, 20);

    expect(catMap.containsKey('vegetables'), isTrue);
    expect(catMap['vegetables']!.cards.length, 20);

    expect(catMap.containsKey('animals'), isTrue);
    expect(catMap['animals']!.cards.length, 25);

    expect(catMap.containsKey('birds'), isTrue);
    expect(catMap['birds']!.cards.length, 20);

    expect(catMap.containsKey('numbers'), isTrue);
    expect(catMap['numbers']!.cards.length, 20);

    expect(catMap.containsKey('colors'), isTrue);
    expect(catMap['colors']!.cards.length, 12);

    expect(catMap.containsKey('shapes'), isTrue);
    expect(catMap['shapes']!.cards.length, 10);

    expect(catMap.containsKey('body_parts'), isTrue);
    expect(catMap['body_parts']!.cards.length, 20);

    expect(catMap.containsKey('days'), isTrue);
    expect(catMap['days']!.cards.length, 7);

    expect(catMap.containsKey('vehicles'), isTrue);
    expect(catMap['vehicles']!.cards.length, 20);
  });

  test('Every card across all 11 categories has valid non-empty fields & image path', () {
    for (final cat in kindergartenCategories) {
      expect(cat.name.isNotEmpty, isTrue);
      expect(cat.completionMessage.isNotEmpty, isTrue);
      for (final card in cat.cards) {
        expect(card.id.isNotEmpty, isTrue);
        expect(card.word.isNotEmpty, isTrue);
        expect(card.imagePath.isNotEmpty, isTrue);
        expect(card.pronunciationText.isNotEmpty, isTrue);
      }
    }
  });
}
