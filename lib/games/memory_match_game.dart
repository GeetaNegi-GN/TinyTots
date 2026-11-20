import 'dart:math';
import 'package:flutter/material.dart';
import '../config/game_config.dart';
import '../data/category_data.dart';
import '../localization/app_localizations.dart';
import '../models/learning_card.dart';
import '../services/progress_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bouncy_button.dart';
import '../widgets/card_illustrations.dart';
import '../widgets/playground_background.dart';
import 'game_completion_screen.dart';

class MemoryTile {
  MemoryTile({
    required this.id,
    required this.card,
    this.revealed = false,
    this.matched = false,
  });

  final int id;
  final LearningCard card;
  bool revealed;
  bool matched;
}

class MemoryMatchGameScreen extends StatefulWidget {
  const MemoryMatchGameScreen({super.key, required this.config});

  final GameConfig config;

  @override
  State<MemoryMatchGameScreen> createState() => _MemoryMatchGameScreenState();
}

class _MemoryMatchGameScreenState extends State<MemoryMatchGameScreen> {
  late List<MemoryTile> _tiles;
  final List<int> _selectedIndices = [];
  bool _busy = false;
  int _starsEarned = 0;

  @override
  void initState() {
    super.initState();
    _startRound();
  }

  void _startRound() {
    final pool = kindergartenCategories.firstWhere((c) => c.id == 'animals').cards;
    final rng = Random();
    final chosen = (List<LearningCard>.from(pool)..shuffle(rng)).take(3).toList();

    final tiles = <MemoryTile>[];
    int counter = 0;
    for (final c in chosen) {
      tiles.add(MemoryTile(id: counter++, card: c));
      tiles.add(MemoryTile(id: counter++, card: c));
    }
    tiles.shuffle(rng);
    _tiles = tiles;
    _selectedIndices.clear();
  }

  Future<void> _onTileTap(int index) async {
    if (_busy || _tiles[index].revealed || _tiles[index].matched) return;

    setState(() {
      _tiles[index].revealed = true;
      _selectedIndices.add(index);
    });

    if (_selectedIndices.length == 2) {
      _busy = true;
      final idx1 = _selectedIndices[0];
      final idx2 = _selectedIndices[1];

      if (_tiles[idx1].card.id == _tiles[idx2].card.id) {
        // Matched!
        _tiles[idx1].matched = true;
        _tiles[idx2].matched = true;
        _starsEarned++;
        _selectedIndices.clear();
        _busy = false;

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
                      builder: (_) => MemoryMatchGameScreen(config: widget.config),
                    ),
                  );
                },
              ),
            ),
          );
        }
      } else {
        // Flip back after delay
        await Future<void>.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          setState(() {
            _tiles[idx1].revealed = false;
            _tiles[idx2].revealed = false;
            _selectedIndices.clear();
            _busy = false;
          });
        }
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
                  final showFront = tile.revealed || tile.matched;

                  return Material(
                    color: showFront ? Color(tile.card.colorValue) : AppTheme.coral,
                    borderRadius: BorderRadius.circular(24),
                    elevation: 3,
                    child: InkWell(
                      onTap: () => _onTileTap(index),
                      borderRadius: BorderRadius.circular(24),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: showFront
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    tile.card.imagePath,
                                    fit: BoxFit.contain,
                                    height: 90,
                                    errorBuilder: (_, _, _) => FlashcardIllustration(
                                      letterId: tile.card.id.toUpperCase(),
                                      size: 70,
                                    ),
                                  ),
                                ),
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.star_rounded, color: Colors.white, size: 36),
                                  Text(
                                    'TinyTots',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
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
