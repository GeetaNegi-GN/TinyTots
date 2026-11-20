import '../models/phonics_model.dart';
import 'alphabet_data.dart';

List<PhonicsItem> getPhonicsLetterData() {
  final phonemes = {
    'A': '/a/', 'B': '/b/', 'C': '/k/', 'D': '/d/', 'E': '/e/',
    'F': '/f/', 'G': '/g/', 'H': '/h/', 'I': '/i/', 'J': '/j/',
    'K': '/k/', 'L': '/l/', 'M': '/m/', 'N': '/n/', 'O': '/o/',
    'P': '/p/', 'Q': '/kw/', 'R': '/r/', 'S': '/s/', 'T': '/t/',
    'U': '/u/', 'V': '/v/', 'W': '/w/', 'X': '/ks/', 'Y': '/y/',
    'Z': '/z/',
  };

  return alphabetCards.map((card) {
    final char = card.id.toUpperCase();
    return PhonicsItem(
      letter: char,
      phoneme: phonemes[char] ?? '/$char/',
      exampleWord: card.word,
      imagePath: card.imagePath,
      colorValue: card.colorValue,
    );
  }).toList();
}

List<BlendingWord> getCvcBlendingWords() {
  return const [
    BlendingWord(
      word: 'CAT',
      letters: ['C', 'A', 'T'],
      phonemes: ['/k/', '/a/', '/t/'],
      imagePath: 'assets/images/alphabet/c_cat.jpg',
      colorValue: 0xFFFFE7B7,
    ),
    BlendingWord(
      word: 'DOG',
      letters: ['D', 'O', 'G'],
      phonemes: ['/d/', '/o/', '/g/'],
      imagePath: 'assets/images/alphabet/d_dog.jpg',
      colorValue: 0xFFE2D4FF,
    ),
    BlendingWord(
      word: 'SUN',
      letters: ['S', 'U', 'N'],
      phonemes: ['/s/', '/u/', '/n/'],
      imagePath: 'assets/images/alphabet/s_sun.jpg',
      colorValue: 0xFFFFF0AD,
    ),
    BlendingWord(
      word: 'BUS',
      letters: ['B', 'U', 'S'],
      phonemes: ['/b/', '/u/', '/s/'],
      imagePath: 'assets/learning/vehicles/bus.jpg',
      colorValue: 0xFFFFF0AA,
    ),
    BlendingWord(
      word: 'BED',
      letters: ['B', 'E', 'D'],
      phonemes: ['/b/', '/e/', '/d/'],
      imagePath: 'assets/images/alphabet/b_ball.jpg',
      colorValue: 0xFFDAEAFE,
    ),
    BlendingWord(
      word: 'MAP',
      letters: ['M', 'A', 'P'],
      phonemes: ['/m/', '/a/', '/p/'],
      imagePath: 'assets/images/alphabet/m_mango.jpg',
      colorValue: 0xFFFFE2A7,
    ),
    BlendingWord(
      word: 'PEN',
      letters: ['P', 'E', 'N'],
      phonemes: ['/p/', '/e/', '/n/'],
      imagePath: 'assets/images/alphabet/p_parrot.jpg',
      colorValue: 0xFFD6F3D6,
    ),
    BlendingWord(
      word: 'PIN',
      letters: ['P', 'I', 'N'],
      phonemes: ['/p/', '/i/', '/n/'],
      imagePath: 'assets/images/alphabet/p_parrot.jpg',
      colorValue: 0xFFFFDCE9,
    ),
    BlendingWord(
      word: 'HAT',
      letters: ['H', 'A', 'T'],
      phonemes: ['/h/', '/a/', '/t/'],
      imagePath: 'assets/images/alphabet/h_hen.jpg',
      colorValue: 0xFFFFE7B7,
    ),
    BlendingWord(
      word: 'FAN',
      letters: ['F', 'A', 'N'],
      phonemes: ['/f/', '/a/', '/n/'],
      imagePath: 'assets/images/alphabet/f_fish.jpg',
      colorValue: 0xFFCFE9FF,
    ),
    BlendingWord(
      word: 'BAT',
      letters: ['B', 'A', 'T'],
      phonemes: ['/b/', '/a/', '/t/'],
      imagePath: 'assets/images/alphabet/b_ball.jpg',
      colorValue: 0xFFDAEAFE,
    ),
    BlendingWord(
      word: 'CUP',
      letters: ['C', 'U', 'P'],
      phonemes: ['/k/', '/u/', '/p/'],
      imagePath: 'assets/images/alphabet/c_cat.jpg',
      colorValue: 0xFFFFD5D5,
    ),
  ];
}
