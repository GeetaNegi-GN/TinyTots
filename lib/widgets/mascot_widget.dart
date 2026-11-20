import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum OwlPose { welcome, waving, learning, celebrating }

class OwlMascotWidget extends StatelessWidget {
  const OwlMascotWidget({
    super.key,
    this.pose = OwlPose.welcome,
    this.size = 72.0,
  });

  final OwlPose pose;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _OwlMascotPainter(pose: pose),
      ),
    );
  }
}

class _OwlMascotPainter extends CustomPainter {
  _OwlMascotPainter({required this.pose});

  final OwlPose pose;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Body Paint (Soft Lavender / Coral / Gold body)
    final bodyPaint = Paint()
      ..color = AppTheme.lavender
      ..style = PaintingStyle.fill;

    // Outer Body Circle
    canvas.drawCircle(center + const Offset(0, 4), radius * 0.82, bodyPaint);

    // Ear Tufts
    final earPaint = Paint()..color = AppTheme.coral;
    final leftEar = Path()
      ..moveTo(center.dx - radius * 0.55, center.dy - radius * 0.5)
      ..lineTo(center.dx - radius * 0.75, center.dy - radius * 0.95)
      ..lineTo(center.dx - radius * 0.2, center.dy - radius * 0.65)
      ..close();
    final rightEar = Path()
      ..moveTo(center.dx + radius * 0.55, center.dy - radius * 0.5)
      ..lineTo(center.dx + radius * 0.75, center.dy - radius * 0.95)
      ..lineTo(center.dx + radius * 0.2, center.dy - radius * 0.65)
      ..close();
    canvas.drawPath(leftEar, earPaint);
    canvas.drawPath(rightEar, earPaint);

    // Tummy Oval (Warm Cream / White)
    final tummyPaint = Paint()..color = AppTheme.cream;
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(0, radius * 0.28),
        width: radius * 1.0,
        height: radius * 0.8,
      ),
      tummyPaint,
    );

    // Tummy Feather scallops
    final featherPaint = Paint()
      ..color = AppTheme.peach
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawArc(
      Rect.fromCenter(center: center + Offset(-radius * 0.18, radius * 0.2), width: 14, height: 10),
      0, pi, false, featherPaint,
    );
    canvas.drawArc(
      Rect.fromCenter(center: center + Offset(radius * 0.18, radius * 0.2), width: 14, height: 10),
      0, pi, false, featherPaint,
    );

    // Big Expressive Eyes
    final eyeBgPaint = Paint()..color = Colors.white;
    final eyeLeftCenter = center + Offset(-radius * 0.32, -radius * 0.18);
    final eyeRightCenter = center + Offset(radius * 0.32, -radius * 0.18);
    final eyeRadius = radius * 0.32;

    canvas.drawCircle(eyeLeftCenter, eyeRadius, eyeBgPaint);
    canvas.drawCircle(eyeRightCenter, eyeRadius, eyeBgPaint);

    // Pupils
    final pupilPaint = Paint()..color = AppTheme.navy;
    final pupilRadius = eyeRadius * 0.55;
    canvas.drawCircle(eyeLeftCenter + const Offset(1, 1), pupilRadius, pupilPaint);
    canvas.drawCircle(eyeRightCenter + const Offset(-1, 1), pupilRadius, pupilPaint);

    // Eye Catchlights (Sparkles)
    final sparklePaint = Paint()..color = Colors.white;
    canvas.drawCircle(eyeLeftCenter + Offset(-pupilRadius * 0.3, -pupilRadius * 0.3), pupilRadius * 0.35, sparklePaint);
    canvas.drawCircle(eyeRightCenter + Offset(-pupilRadius * 0.3, -pupilRadius * 0.3), pupilRadius * 0.35, sparklePaint);

    // Cute Orange Beak
    final beakPaint = Paint()..color = AppTheme.yellow;
    final beakPath = Path()
      ..moveTo(center.dx - 6, center.dy - radius * 0.05)
      ..lineTo(center.dx + 6, center.dy - radius * 0.05)
      ..lineTo(center.dx, center.dy + radius * 0.18)
      ..close();
    canvas.drawPath(beakPath, beakPaint);

    // Wings based on pose
    final wingPaint = Paint()..color = AppTheme.skyBlue;
    if (pose == OwlPose.waving) {
      // Left wing resting, right wing raised waving
      canvas.drawOval(
        Rect.fromCenter(center: center + Offset(-radius * 0.75, radius * 0.2), width: radius * 0.45, height: radius * 0.7),
        wingPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(center: center + Offset(radius * 0.85, -radius * 0.2), width: radius * 0.45, height: radius * 0.75),
        wingPaint,
      );
    } else if (pose == OwlPose.celebrating) {
      // Both wings raised up!
      canvas.drawOval(
        Rect.fromCenter(center: center + Offset(-radius * 0.8, -radius * 0.25), width: radius * 0.45, height: radius * 0.75),
        wingPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(center: center + Offset(radius * 0.8, -radius * 0.25), width: radius * 0.45, height: radius * 0.75),
        wingPaint,
      );
      // Graduation cap / Party hat
      final hatPaint = Paint()..color = AppTheme.coral;
      final hatPath = Path()
        ..moveTo(center.dx, center.dy - radius * 1.1)
        ..lineTo(center.dx - radius * 0.35, center.dy - radius * 0.6)
        ..lineTo(center.dx + radius * 0.35, center.dy - radius * 0.6)
        ..close();
      canvas.drawPath(hatPath, hatPaint);
    } else {
      // Standard resting wings
      canvas.drawOval(
        Rect.fromCenter(center: center + Offset(-radius * 0.75, radius * 0.2), width: radius * 0.4, height: radius * 0.7),
        wingPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(center: center + Offset(radius * 0.75, radius * 0.2), width: radius * 0.4, height: radius * 0.7),
        wingPaint,
      );
    }

    // Feet (Little orange claws)
    final footPaint = Paint()
      ..color = AppTheme.yellow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center + Offset(-radius * 0.25, radius * 0.85), 5, footPaint);
    canvas.drawCircle(center + Offset(-radius * 0.12, radius * 0.88), 5, footPaint);
    canvas.drawCircle(center + Offset(radius * 0.12, radius * 0.88), 5, footPaint);
    canvas.drawCircle(center + Offset(radius * 0.25, radius * 0.85), 5, footPaint);
  }

  @override
  bool shouldRepaint(covariant _OwlMascotPainter oldDelegate) => oldDelegate.pose != pose;
}
