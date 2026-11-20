class GameSession {
  GameSession({
    required this.gameId,
    required this.categoryId,
    this.totalQuestions = 5,
    this.currentIndex = 0,
    this.correctCount = 0,
    this.attempts = 0,
    this.completed = false,
    this.starsEarned = 0,
  });

  final String gameId;
  final String categoryId;
  final int totalQuestions;
  int currentIndex;
  int correctCount;
  int attempts;
  bool completed;
  int starsEarned;

  bool get isFinished => currentIndex >= totalQuestions || completed;
}
