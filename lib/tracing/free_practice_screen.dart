import 'package:flutter/material.dart';
import '../data/tracing_data.dart';
import '../localization/app_localizations.dart';
import '../models/learning_card.dart';
import '../models/tracing_model.dart';
import '../services/pronunciation_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bouncy_button.dart';
import '../widgets/playground_background.dart';

class FreePracticeScreen extends StatefulWidget {
  const FreePracticeScreen({super.key});

  @override
  State<FreePracticeScreen> createState() => _FreePracticeScreenState();
}

class _FreePracticeScreenState extends State<FreePracticeScreen> {
  late List<TracingCharacter> _allChars;
  int _idx = 0;
  final List<List<Offset>> _userStrokes = [];
  List<Offset>? _currentStroke;

  @override
  void initState() {
    super.initState();
    _allChars = [
      ...getUppercaseLetterTracingData(),
      ...getNumberTracingData(),
    ];
  }

  TracingCharacter get currentChar => _allChars[_idx];

  void _clearCanvas() {
    setState(() {
      _userStrokes.clear();
      _currentStroke = null;
    });
  }

  Future<void> _speakCurrent() async {
    final c = currentChar;
    await PronunciationService.speak(LearningCard(
      id: c.id,
      uppercase: c.displayChar,
      lowercase: c.displayChar,
      word: c.associatedWord ?? c.displayChar,
      emoji: '✏️',
      colorValue: 0xFFDAEAFE,
      imagePath: c.imagePath ?? '',
    ));
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _currentStroke = [details.localPosition];
      _userStrokes.add(_currentStroke!);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentStroke?.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _currentStroke = null;
  }

  @override
  Widget build(BuildContext context) {
    final c = currentChar;

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
                  AppLocalizations.tr('tracing.freePractice.title'),
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppTheme.navy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                BouncyButton(
                  color: AppTheme.softWhite,
                  borderRadius: 20,
                  padding: const EdgeInsets.all(10),
                  onTap: _speakCurrent,
                  child: const Icon(Icons.volume_up_rounded, color: AppTheme.navy),
                ),
                const SizedBox(width: 8),
                BouncyButton(
                  color: AppTheme.softWhite,
                  borderRadius: 20,
                  padding: const EdgeInsets.all(10),
                  onTap: _clearCanvas,
                  child: const Icon(Icons.refresh_rounded, color: AppTheme.navy),
                ),
              ],
            ),
          ),
          // Character Selector Ribbon
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _allChars.length,
              itemBuilder: (context, index) {
                final item = _allChars[index];
                final selected = index == _idx;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: BouncyButton(
                    color: selected ? AppTheme.yellow : AppTheme.softWhite,
                    borderRadius: 18,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    onTap: () {
                      setState(() {
                        _idx = index;
                        _clearCanvas();
                      });
                      _speakCurrent();
                    },
                    child: Text(
                      item.displayChar,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Canvas
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: AppTheme.cardShadow(),
                  border: Border.all(color: AppTheme.mintGreen, width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = Size(constraints.maxWidth, constraints.maxHeight);
                      return GestureDetector(
                        onPanStart: _onPanStart,
                        onPanUpdate: _onPanUpdate,
                        onPanEnd: _onPanEnd,
                        child: CustomPaint(
                          size: size,
                          painter: _FreePracticePainter(
                            character: c,
                            userStrokes: _userStrokes,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FreePracticePainter extends CustomPainter {
  _FreePracticePainter({
    required this.character,
    required this.userStrokes,
  });

  final TracingCharacter character;
  final List<List<Offset>> userStrokes;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw light guide character in background
    final textPainter = TextPainter(
      text: TextSpan(
        text: character.displayChar,
        style: TextStyle(
          fontSize: size.height * 0.55,
          fontWeight: FontWeight.w900,
          color: AppTheme.disabledBg.withValues(alpha: 0.5),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );

    // 2. Draw user freehand strokes
    final userPaint = Paint()
      ..color = AppTheme.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final stroke in userStrokes) {
      if (stroke.length < 2) continue;
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, userPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FreePracticePainter oldDelegate) => true;
}
