import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_tots/data/alphabet_data.dart';

void main() {
  test('Kindergarten alphabet has all 26 letters in sequence', () {
    expect(alphabetCards, hasLength(26));
    expect(alphabetCards.first.id, 'A');
    expect(alphabetCards.last.id, 'Z');
    expect(alphabetCards.map((card) => card.id).toSet(), hasLength(26));
  });
}
