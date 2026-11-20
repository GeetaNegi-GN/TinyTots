import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PlaygroundBackground extends StatelessWidget {
  const PlaygroundBackground({
    super.key,
    required this.child,
    this.showHills = true,
  });

  final Widget child;
  final bool showHills;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _PlaygroundSceneryPainter(showHills: showHills),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _PlaygroundSceneryPainter extends CustomPainter {
  _PlaygroundSceneryPainter({required this.showHills});

  final bool showHills;

  @override
  void paint(Canvas canvas, Size size) {
    // Top-right pastel rainbow arc
    final rainbowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9.0
      ..strokeCap = StrokeCap.round;

    final rainbowCenter = Offset(size.width + 10, -10);
    final rainbowColors = [
      AppTheme.coral.withValues(alpha: 0.4),
      AppTheme.yellow.withValues(alpha: 0.4),
      AppTheme.mintGreen.withValues(alpha: 0.4),
      AppTheme.skyBlue.withValues(alpha: 0.4),
      AppTheme.lavender.withValues(alpha: 0.4),
    ];

    for (int i = 0; i < rainbowColors.length; i++) {
      rainbowPaint.color = rainbowColors[i];
      canvas.drawCircle(rainbowCenter, 80.0 + (i * 10), rainbowPaint);
    }

    // Floating Clouds
    _drawCloud(canvas, const Offset(45, 75), 32);
    _drawCloud(canvas, Offset(size.width - 60, 160), 28);
    _drawCloud(canvas, Offset(60, size.height - 180), 26);

    // Twinkling Stars & Sparkles
    _drawSparkle(canvas, Offset(size.width * 0.25, 120), AppTheme.yellow, 12);
    _drawSparkle(canvas, Offset(size.width * 0.85, 260), AppTheme.coral, 10);
    _drawSparkle(canvas, Offset(size.width * 0.15, size.height * 0.55), AppTheme.skyBlue, 9);
    _drawSparkle(canvas, Offset(size.width * 0.88, size.height * 0.7), AppTheme.lavender, 11);

    // Bottom Rolling Pastel Hills
    if (showHills && size.height > 300) {
      final hill1 = Paint()..color = AppTheme.mintGreen.withValues(alpha: 0.18);
      final path1 = Path()
        ..moveTo(0, size.height)
        ..quadraticBezierTo(size.width * 0.25, size.height - 70, size.width * 0.6, size.height - 35)
        ..quadraticBezierTo(size.width * 0.85, size.height - 10, size.width, size.height - 40)
        ..lineTo(size.width, size.height)
        ..close();
      canvas.drawPath(path1, hill1);

      final hill2 = Paint()..color = AppTheme.yellow.withValues(alpha: 0.15);
      final path2 = Path()
        ..moveTo(0, size.height)
        ..quadraticBezierTo(size.width * 0.4, size.height - 45, size.width, size.height - 20)
        ..lineTo(size.width, size.height)
        ..close();
      canvas.drawPath(path2, hill2);
    }
  }

  void _drawCloud(Canvas canvas, Offset center, double radius) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.75);
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center + Offset(-radius * 0.6, radius * 0.2), radius * 0.7, paint);
    canvas.drawCircle(center + Offset(radius * 0.6, radius * 0.2), radius * 0.7, paint);
    canvas.drawRect(
      Rect.fromLTRB(
        center.dx - radius * 1.2,
        center.dy,
        center.dx + radius * 1.2,
        center.dy + radius * 0.8,
      ),
      paint,
    );
  }

  void _drawSparkle(Canvas canvas, Offset center, Color color, double radius) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final angle = i * (pi / 2);
      final outer = Offset(center.dx + cos(angle) * radius, center.dy + sin(angle) * radius);
      final innerAngle = angle + (pi / 4);
      final inner = Offset(center.dx + cos(innerAngle) * (radius * 0.35), center.dy + sin(innerAngle) * (radius * 0.35));
      if (i == 0) {
        path.moveTo(outer.dx, outer.dy);
      } else {
        path.lineTo(outer.dx, outer.dy);
      }
      path.lineTo(inner.dx, inner.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
