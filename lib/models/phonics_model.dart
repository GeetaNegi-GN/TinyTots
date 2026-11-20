class PhonicsItem {
  const PhonicsItem({
    required this.letter,
    required this.phoneme,
    required this.exampleWord,
    required this.imagePath,
    this.colorValue = 0xFFDAEAFE,
  });

  final String letter;
  final String phoneme;
  final String exampleWord;
  final String imagePath;
  final int colorValue;

  String get phonemeText => '$letter says $phoneme as in $exampleWord.';
}

class BlendingWord {
  const BlendingWord({
    required this.word,
    required this.phonemes,
    required this.letters,
    required this.imagePath,
    this.colorValue = 0xFFDAEAFE,
  });

  final String word;
  final List<String> phonemes;
  final List<String> letters;
  final String imagePath;
  final int colorValue;
}
