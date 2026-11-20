import 'dart:math';
import 'package:flutter/material.dart';
import '../config/game_config.dart';
import '../data/alphabet_data.dart';
import '../localization/app_localizations.dart';
import '../models/learning_card.dart';
import '../services/progress_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bouncy_button.dart';
import '../widgets/playground_background.dart';
import 'game_completion_screen.dart';

class LetterTile {
  LetterTile({
    required this.id,
    required this.card,
    required this.letter,
    required this.isUppercase,
    this.matched = false,
  });

  final int id;
  final LearningCard card;
  final String letter;
  final bool isUppercase;
  bool matched;
}

class MatchLettersGameScreen extends StatefulWidget {
  const MatchLettersGameScreen({super.key, required this.config});

  final GameConfig config;

  @override
  State<MatchLettersGameScreen> createState() => _MatchLettersGameScreenState();
}

class _MatchLettersGameScreenState extends State<MatchLettersGameScreen> {
  late List<LetterTile> _tiles;
  int? _selectedIdx;
  int _starsEarned = 0;

  @override
  void initState() {
    super.initState();
    _startRound();
  }

  void _startRound() {
    final rng = Random();
    final chosen = (List<LearningCard>.from(alphabetCards)..shuffle(rng)).take(3).toList();

    final tiles = <LetterTile>[];
    int counter = 0;
    for (final card in chosen) {
      tiles.add(LetterTile(id: counter++, card: card, letter: card.uppercase, isUppercase: true));
      tiles.add(LetterTile(id: counter++, card: card, letter: card.lowercase, isUppercase: false));
    }
    tiles.shuffle(rng);
    _tiles = tiles;
    _selectedIdx = null;
  }

  Future<void> _onTileTap(int index) async {
    if (_tiles[index].matched) return;

    if (_selectedIdx == null) {
      setState(() => _selectedIdx = index);
    } else {
      final firstIdx = _selectedIdx!;
      if (firstIdx == index) {
        // Unselect
        setState(() => _selectedIdx = null);
        return;
      }

      final t1 = _tiles[firstIdx];
      final t2 = _tiles[index];

      if (t1.card.id == t2.card.id && t1.isUppercase != t2.isUppercase) {
        // Match!
        setState(() {
          t1.matched = true;
          t2.matched = true;
          _selectedIdx = null;
          _starsEarned++;
        });

        if (_tiles.every((t) => t.matched)) {
          await ProgressService.saveGameProgress(
            widget.config.id,
            starsEarned: _starsEarned,
            completedRounds: 1,
          );
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => GameCompletionScreen(
                config: widget.config,
                starsEarned: _starsEarned,
                onPlayAgain: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MatchLettersGameScreen(config: widget.config),
                    ),
                  );
                },
              ),
            ),
          );
        }
      } else {
        // No match
        setState(() => _selectedIdx = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBackground(
      showHills: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                BouncyButton(
                  color: AppTheme.softWhite,
                  borderRadius: 20,
                  padding: const EdgeInsets.all(10),
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_rounded, color: AppTheme.navy),
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.tr(widget.config.titleKey),
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppTheme.navy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.yellow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '⭐ $_starsEarned',
                    style: const TextStyle(
                      color: AppTheme.navy,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: GridView.builder(
                itemCount: _tiles.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (context, index) {
                  final tile = _tiles[index];
                  final isSelected = _selectedIdx == index;

                  return Material(
                    color: tile.matched
                        ? AppTheme.yellow
                        : isSelected
                            ? AppTheme.skyBlue
                            : Color(tile.card.colorValue),
                    borderRadius: BorderRadius.circular(24),
                    elevation: 3,
                    child: InkWell(
                      onTap: () => _onTileTap(index),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        alignment: Alignment.center,
                        child: tile.matched
                            ? const Icon(
                                Icons.check_circle_rounded,
                                color: AppTheme.navy,
                                size: 48,
                              )
                            : Text(
                                tile.letter,
                                style: TextStyle(
                                  fontSize: tile.isUppercase ? 54 : 44,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.navy,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
