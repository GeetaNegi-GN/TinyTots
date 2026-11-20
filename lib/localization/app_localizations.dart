class AppLocalizations {
  static String currentLocale = 'en';

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App Branding
      'app.title': 'TinyTots',
      'app.tagline': 'Little Steps, Big Learning!',
      'app.welcomeTitle': 'Hello Little Learner! 👋',
      'app.welcomeSubtitle': 'What would you like to explore today?',

      // Common Navigation & Buttons
      'common.back': 'Back',
      'common.next': 'Next',
      'common.previous': 'Previous',
      'common.startLearning': 'Start Learning',
      'common.playAndLearn': 'Play & Learn 🎮',
      'common.traceAndWrite': 'Trace & Write ✏️',
      'common.soundsAndWords': 'Sounds & Words 🔊',
      'common.comingSoon': 'Coming Soon',
      'common.tapToHear': 'Tap to hear',
      'common.listening': 'Listening...',
      'common.pickCategory': 'Pick a {category}',
      'common.backToKindergarten': 'Back to Kindergarten',
      'common.backToGames': 'Back to Games',
      'common.backToTraceHub': 'Back to Trace & Write',
      'common.backToPhonicsHub': 'Back to Sounds & Words',
      'common.playAgain': 'Play Again',
      'common.replay': 'Replay {category}',
      'common.amazing': 'Amazing! You Did It!',
      'common.clear': 'Clear',
      'common.erase': 'Erase',
      'common.retry': 'Retry',

      // Generic Learning Levels
      'levels.level_1.title': 'Kindergarten',
      'levels.level_1.subtitle': 'Let’s learn together!',
      'levels.level_1.description': 'Let’s Start Learning!',
      'levels.level_2.title': 'LKG',
      'levels.level_2.subtitle': 'A new adventure is on its way!',
      'levels.level_3.title': 'UKG',
      'levels.level_3.subtitle': 'A new adventure is on its way!',

      // Categories
      'categories.abc.title': 'ABC / English Alphabet',
      'categories.abc.completion': 'You explored all 26 letters of the alphabet!',
      'categories.fruits.title': 'Fruits',
      'categories.fruits.completion': 'You learned all the delicious fruits!',
      'categories.vegetables.title': 'Vegetables',
      'categories.vegetables.completion': 'You learned all the healthy vegetables!',
      'categories.animals.title': 'Animals',
      'categories.animals.completion': 'Wow! You met all 25 wonderful animals!',
      'categories.birds.title': 'Birds',
      'categories.birds.completion': 'Fantastic! You learned all 20 beautiful birds!',
      'categories.numbers.title': 'Numbers 1–20',
      'categories.numbers.completion': 'Great counting! You explored all 20 numbers!',
      'categories.colors.title': 'Colors',
      'categories.colors.completion': 'Awesome! You learned all 12 colorful colors!',
      'categories.shapes.title': 'Shapes',
      'categories.shapes.completion': 'Super job! You explored all 10 shapes!',
      'categories.body_parts.title': 'Body Parts',
      'categories.body_parts.completion': 'Wonderful! You learned 20 parts of the body!',
      'categories.days.title': 'Days of the Week',
      'categories.days.completion': 'Hooray! You explored all 7 days of the week!',
      'categories.vehicles.title': 'Vehicles',
      'categories.vehicles.completion': 'Vroom vroom! You learned all 20 vehicles!',

      // Learning & Feedback
      'learning.progress': '{category} {index} of {total}',
      'learning.exploredStatus': '{explored} / {total} explored',
      'learning.completedBadge': 'Completed ⭐',
      'learning.earnedStar': 'Great job! You earned a star!',
      'learning.timeTitle': '{category} Time!',

      // Game Zone & Interactive Games
      'games.zone.title': 'Let’s Play & Learn!',
      'games.zone.subtitle': 'Choose a fun game to practice!',
      'games.listenChoose.title': 'Listen & Choose',
      'games.listenChoose.description': 'Listen carefully and find the picture!',
      'games.matchPictures.title': 'Match the Pictures',
      'games.matchPictures.description': 'Find the matching pictures!',
      'games.matchLetters.title': 'Match the Letters',
      'games.matchLetters.description': 'Match big and small letters!',
      'games.memoryMatch.title': 'Memory Match',
      'games.memoryMatch.description': 'Can you remember where the pictures are?',
      'games.countObjects.title': 'Count the Objects',
      'games.countObjects.description': 'Count the objects and choose the number!',
      'games.feedback.correct': 'Yay! That’s right! ⭐',
      'games.feedback.tryAgain': 'Let’s try again! 😊',
      'games.feedback.countTogether': 'Great counting! 👏',
      'games.feedback.memoryFound': 'Wonderful! You found all matches!',
      'games.questionProgress': 'Question {current} of {total}',
      'games.countPrompt': 'How many {object}?',

      // Trace & Write
      'tracing.hub.title': 'Trace & Write! ✏️',
      'tracing.hub.subtitle': 'Practice writing letters and numbers!',
      'tracing.letters.title': 'Trace Letters',
      'tracing.letters.description': 'Practice writing letters A–Z and a–z!',
      'tracing.numbers.title': 'Trace Numbers',
      'tracing.numbers.description': 'Practice writing numbers 0–9!',
      'tracing.freePractice.title': 'Free Practice',
      'tracing.freePractice.description': 'Draw and write freely on the canvas!',
      'tracing.uppercase': 'Uppercase A-Z',
      'tracing.lowercase': 'Lowercase a-z',
      'tracing.feedback.great': 'Great tracing! ⭐',
      'tracing.instruction': 'Trace along the dots!',

      // Phonics & First Words
      'phonics.hub.title': 'Sounds & Words 🔊',
      'phonics.hub.subtitle': 'Learn letter sounds, blending, and first words!',
      'phonics.letterSounds.title': 'Letter Sounds',
      'phonics.letterSounds.description': 'Hear the phonics sound for every letter A–Z!',
      'phonics.beginningSounds.title': 'Beginning Sounds',
      'phonics.beginningSounds.description': 'Which picture begins with the sound?',
      'phonics.soundPictureMatch.title': 'Sound & Picture Match',
      'phonics.soundPictureMatch.description': 'Hear the sound and match the picture!',
      'phonics.soundBlending.title': 'Sound Blending',
      'phonics.soundBlending.description': 'Blend individual sounds into words!',
      'phonics.firstWords.title': 'First Words',
      'phonics.firstWords.description': 'Read and explore simple first words!',
      'phonics.beginningPrompt': 'Which picture begins with {sound}?',
      'phonics.blendPrompt': 'Tap individual sounds or press Blend!',
      'phonics.blendButton': 'Blend Sounds 🔉',
    },
  };

  /// Returns localized string for given key. Falls back to key if key is missing.
  static String tr(String key, {Map<String, String>? args}) {
    final dict = _localizedValues[currentLocale] ?? _localizedValues['en']!;
    var value = dict[key] ?? key;
    if (args != null) {
      args.forEach((k, v) {
        value = value.replaceAll('{$k}', v);
      });
    }
    return value;
  }
}
