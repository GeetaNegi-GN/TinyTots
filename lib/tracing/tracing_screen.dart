import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/learning_card.dart';
import '../models/tracing_model.dart';
import '../services/progress_service.dart';
import '../services/pronunciation_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bouncy_button.dart';
import '../widgets/card_illustrations.dart';
import '../widgets/playground_background.dart';

class TracingScreen extends StatefulWidget {
  const TracingScreen({
    super.key,
    required this.character,
    required this.dataset,
    required this.currentIndex,
  });

  final TracingCharacter character;
  final List<TracingCharacter> dataset;
  final int currentIndex;

  @override
  State<TracingScreen> createState() => _TracingScreenState();
}

class _TracingScreenState extends State<TracingScreen> {
  late int _idx;
  final List<List<Offset>> _userStrokes = [];
  List<Offset>? _currentStroke;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _idx = widget.currentIndex;
    _speakCurrent();
  }

  TracingCharacter get currentChar => widget.dataset[_idx];

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

  void _clearCanvas() {
    setState(() {
      _userStrokes.clear();
      _currentStroke = null;
      _completed = false;
    });
  }

  void _onPanStart(DragStartDetails details, Size canvasSize) {
    final localPos = details.localPosition;
    setState(() {
      _currentStroke = [localPos];
      _userStrokes.add(_currentStroke!);
    });
  }

  void _onPanUpdate(DragUpdateDetails details, Size canvasSize) {
    final localPos = details.localPosition;
    setState(() {
      _currentStroke?.add(localPos);
    });
    _checkAccuracy(canvasSize);
  }

  void _onPanEnd(DragEndDetails details) {
    _currentStroke = null;
  }

  void _checkAccuracy(Size canvasSize) {
    if (_completed || _userStrokes.isEmpty) return;
    final c = currentChar;
    if (c.strokes.isEmpty) return;

    // Check if user has drawn over start and end points of stroke guides
    int matchedGuides = 0;
    for (final s in c.strokes) {
      final startTarget = Offset(s.startPoint.dx * canvasSize.width, s.startPoint.dy * canvasSize.height);
      final endTarget = Offset(s.endPoint.dx * canvasSize.width, s.endPoint.dy * canvasSize.height);

      bool hitStart = false;
      bool hitEnd = false;

      for (final stroke in _userStrokes) {
        for (final pt in stroke) {
          if ((pt - startTarget).distance < 45) hitStart = true;
          if ((pt - endTarget).distance < 45) hitEnd = true;
        }
      }
      if (hitStart && hitEnd) matchedGuides++;
    }

    if (matchedGuides >= c.strokes.length || _userStrokes.fold(0, (sum, list) => sum + list.length) > 30) {
      _markCompleted();
    }
  }

  Future<void> _markCompleted() async {
    if (_completed) return;
    setState(() => _completed = true);

    final type = currentChar.count != null
        ? 'numbers'
        : (currentChar.isUppercase ? 'upper' : 'lower');

    final existing = await ProgressService.loadTracingProgress(type);
    final updated = {...existing, currentChar.id};
    await ProgressService.saveTracingProgress(type, updated);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.navy,
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            const Text('⭐', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.tr('tracing.feedback.great'),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }

  void _goNext() {
    if (_idx < widget.dataset.length - 1) {
      setState(() {
        _idx++;
        _clearCanvas();
      });
      _speakCurrent();
    }
  }

  void _goPrev() {
    if (_idx > 0) {
      setState(() {
        _idx--;
        _clearCanvas();
      });
      _speakCurrent();
    }
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
                  'Trace ${c.displayChar}',
                  style: const TextStyle(
                    fontSize: 22,
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
          // Example real photo & word container if available
          if (c.associatedWord != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.softWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.cardShadow(),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (c.imagePath != null && c.imagePath!.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          c.imagePath!,
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => FlashcardIllustration(
                            letterId: c.displayChar.toUpperCase(),
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      '${c.displayChar} - ${c.associatedWord}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.navy,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 6),
          // Tracing Canvas Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: AppTheme.cardShadow(),
                  border: Border.all(color: AppTheme.lavender, width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = Size(constraints.maxWidth, constraints.maxHeight);
                      return GestureDetector(
                        onPanStart: (d) => _onPanStart(d, size),
                        onPanUpdate: (d) => _onPanUpdate(d, size),
                        onPanEnd: _onPanEnd,
                        child: CustomPaint(
                          size: size,
                          painter: _TracingPainter(
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
          // Bottom Controls (Previous & Next)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
            child: Row(
              children: [
                Expanded(
                  child: BouncyButton(
                    color: AppTheme.lavender,
                    onTap: _idx == 0 ? null : _goPrev,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_back_rounded, size: 20),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.tr('common.previous')),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: BouncyButton(
                    color: AppTheme.skyBlue,
                    onTap: _idx == widget.dataset.length - 1 ? null : _goNext,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.tr('common.next')),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TracingPainter extends CustomPainter {
  _TracingPainter({
    required this.character,
    required this.userStrokes,
  });

  final TracingCharacter character;
  final List<List<Offset>> userStrokes;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw central character background guide text
    final textPainter = TextPainter(
      text: TextSpan(
        text: character.displayChar,
        style: TextStyle(
          fontSize: size.height * 0.55,
          fontWeight: FontWeight.w900,
          color: AppTheme.disabledBg.withValues(alpha: 0.8),
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

    // 2. Draw Dotted Guide Stroke Paths
    final guidePaint = Paint()
      ..color = AppTheme.skyBlue.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = AppTheme.coral
      ..style = PaintingStyle.fill;

    for (int i = 0; i < character.strokes.length; i++) {
      final s = character.strokes[i];
      final start = Offset(s.startPoint.dx * size.width, s.startPoint.dy * size.height);
      final end = Offset(s.endPoint.dx * size.width, s.endPoint.dy * size.height);

      final path = Path()..moveTo(start.dx, start.dy);
      if (s.controlPoints.isNotEmpty) {
        for (final cp in s.controlPoints) {
          path.lineTo(cp.dx * size.width, cp.dy * size.height);
        }
      }
      path.lineTo(end.dx, end.dy);
      canvas.drawPath(path, guidePaint);

      // Start dot indicator (Orange circle with stroke number)
      canvas.drawCircle(start, 16, dotPaint);
      final numPainter = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      numPainter.layout();
      numPainter.paint(canvas, start - Offset(numPainter.width / 2, numPainter.height / 2));
    }

    // 3. Draw User Tracing Strokes
    final userPaint = Paint()
      ..color = AppTheme.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
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
  bool shouldRepaint(covariant _TracingPainter oldDelegate) => true;
}
