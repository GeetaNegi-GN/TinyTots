import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FlashcardIllustration extends StatelessWidget {
  const FlashcardIllustration({
    super.key,
    required this.letterId,
    this.size = 130.0,
  });

  final String letterId;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _FlashcardItemPainter(letterId: letterId),
      ),
    );
  }
}

class CategoryIllustration extends StatelessWidget {
  const CategoryIllustration({
    super.key,
    required this.categoryId,
    this.size = 56.0,
  });

  final String categoryId;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CategoryPainter(categoryId: categoryId),
      ),
    );
  }
}

class _CategoryPainter extends CustomPainter {
  _CategoryPainter({required this.categoryId});
  final String categoryId;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    switch (categoryId) {
      case 'ABC':
        // ABC Toy Blocks
        final p1 = Paint()..color = AppTheme.coral;
        final p2 = Paint()..color = AppTheme.yellow;
        final p3 = Paint()..color = AppTheme.skyBlue;
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(r * 0.1, r * 0.5, r * 0.8, r * 0.8), const Radius.circular(8)), p1);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(r * 0.7, r * 0.7, r * 0.8, r * 0.8), const Radius.circular(8)), p2);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(r * 0.4, r * 0.1, r * 0.8, r * 0.8), const Radius.circular(8)), p3);
        break;
      case 'Fruits':
        // Strawberry
        final p = Paint()..color = AppTheme.coral;
        canvas.drawCircle(center + const Offset(0, 4), r * 0.65, p);
        final leaf = Paint()..color = AppTheme.mintGreen;
        canvas.drawCircle(center + Offset(-r * 0.2, -r * 0.4), r * 0.25, leaf);
        canvas.drawCircle(center + Offset(r * 0.2, -r * 0.4), r * 0.25, leaf);
        break;
      case 'Vegetables':
        // Carrot
        final p = Paint()..color = AppTheme.peach;
        final path = Path()
          ..moveTo(center.dx - r * 0.4, center.dy - r * 0.4)
          ..lineTo(center.dx + r * 0.4, center.dy - r * 0.4)
          ..lineTo(center.dx, center.dy + r * 0.7)
          ..close();
        canvas.drawPath(path, p);
        final leaf = Paint()..color = AppTheme.mintGreen;
        canvas.drawRect(Rect.fromLTWH(center.dx - 4, center.dy - r * 0.7, 8, r * 0.3), leaf);
        break;
      case 'Animals':
        // Lion Face
        final mane = Paint()..color = AppTheme.yellow;
        canvas.drawCircle(center, r * 0.8, mane);
        final face = Paint()..color = AppTheme.peach;
        canvas.drawCircle(center, r * 0.55, face);
        break;
      case 'Birds':
        // Blue Bird
        final p = Paint()..color = AppTheme.skyBlue;
        canvas.drawCircle(center, r * 0.65, p);
        final beak = Paint()..color = AppTheme.yellow;
        canvas.drawCircle(center + Offset(r * 0.5, 0), r * 0.2, beak);
        break;
      case 'Numbers':
        // 123 Badge
        final bg = Paint()..color = AppTheme.lavender;
        canvas.drawCircle(center, r * 0.75, bg);
        break;
      case 'Colors':
        // Palette
        final p = Paint()..color = AppTheme.yellow;
        canvas.drawCircle(center, r * 0.75, p);
        final c1 = Paint()..color = AppTheme.coral;
        final c2 = Paint()..color = AppTheme.skyBlue;
        canvas.drawCircle(center + Offset(-r * 0.25, -r * 0.2), r * 0.2, c1);
        canvas.drawCircle(center + Offset(r * 0.25, -r * 0.2), r * 0.2, c2);
        break;
      case 'Shapes':
        // Triangle & Circle
        final p1 = Paint()..color = AppTheme.mintGreen;
        canvas.drawCircle(center + Offset(-r * 0.2, 0), r * 0.4, p1);
        final p2 = Paint()..color = AppTheme.coral;
        final path = Path()
          ..moveTo(center.dx + r * 0.3, center.dy - r * 0.4)
          ..lineTo(center.dx + r * 0.7, center.dy + r * 0.4)
          ..lineTo(center.dx - r * 0.1, center.dy + r * 0.4)
          ..close();
        canvas.drawPath(path, p2);
        break;
      case 'Body Parts':
        // Hand Palm
        final p = Paint()..color = AppTheme.peach;
        canvas.drawCircle(center, r * 0.55, p);
        break;
      default:
        // Calendar / Star
        final p = Paint()..color = AppTheme.skyBlue;
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(r * 0.2, r * 0.2, r * 1.2, r * 1.2), const Radius.circular(8)), p);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _CategoryPainter oldDelegate) => oldDelegate.categoryId != categoryId;
}

class _FlashcardItemPainter extends CustomPainter {
  _FlashcardItemPainter({required this.letterId});
  final String letterId;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    switch (letterId) {
      case 'A': // Apple
        final body = Paint()..color = AppTheme.coral;
        canvas.drawCircle(center + Offset(-r * 0.15, r * 0.05), r * 0.55, body);
        canvas.drawCircle(center + Offset(r * 0.15, r * 0.05), r * 0.55, body);
        final stem = Paint()..color = AppTheme.navy..strokeWidth = 4..style = PaintingStyle.stroke;
        canvas.drawLine(center + Offset(0, -r * 0.4), center + Offset(0, -r * 0.7), stem);
        final leaf = Paint()..color = AppTheme.mintGreen;
        canvas.drawOval(Rect.fromCenter(center: center + Offset(r * 0.2, -r * 0.6), width: r * 0.4, height: r * 0.2), leaf);
        break;

      case 'B': // Ball
        final ball = Paint()..color = AppTheme.skyBlue;
        canvas.drawCircle(center, r * 0.75, ball);
        final stripe = Paint()..color = AppTheme.yellow..style = PaintingStyle.stroke..strokeWidth = 12;
        canvas.drawArc(Rect.fromCircle(center: center, radius: r * 0.75), -pi / 4, pi / 2, false, stripe);
        break;

      case 'C': // Cat
        final catBg = Paint()..color = AppTheme.peach;
        canvas.drawCircle(center + const Offset(0, 6), r * 0.6, catBg);
        final ear = Paint()..color = AppTheme.peach;
        final earL = Path()..moveTo(center.dx - r * 0.5, center.dy - r * 0.3)..lineTo(center.dx - r * 0.7, center.dy - r * 0.8)..lineTo(center.dx - r * 0.2, center.dy - r * 0.55)..close();
        final earR = Path()..moveTo(center.dx + r * 0.5, center.dy - r * 0.3)..lineTo(center.dx + r * 0.7, center.dy - r * 0.8)..lineTo(center.dx + r * 0.2, center.dy - r * 0.55)..close();
        canvas.drawPath(earL, ear);
        canvas.drawPath(earR, ear);
        final eye = Paint()..color = AppTheme.navy;
        canvas.drawCircle(center + Offset(-r * 0.22, -r * 0.05), 5, eye);
        canvas.drawCircle(center + Offset(r * 0.22, -r * 0.05), 5, eye);
        break;

      case 'D': // Dog
        final dogBg = Paint()..color = AppTheme.yellow;
        canvas.drawCircle(center, r * 0.65, dogBg);
        final ear = Paint()..color = AppTheme.navy;
        canvas.drawOval(Rect.fromCenter(center: center + Offset(-r * 0.55, 0), width: r * 0.35, height: r * 0.7), ear);
        canvas.drawOval(Rect.fromCenter(center: center + Offset(r * 0.55, 0), width: r * 0.35, height: r * 0.7), ear);
        break;

      case 'E': // Elephant
        final el = Paint()..color = AppTheme.lavender;
        canvas.drawCircle(center, r * 0.65, el);
        final ear = Paint()..color = AppTheme.peach;
        canvas.drawCircle(center + Offset(-r * 0.55, -r * 0.1), r * 0.35, ear);
        canvas.drawCircle(center + Offset(r * 0.55, -r * 0.1), r * 0.35, ear);
        break;

      case 'F': // Fish
        final f = Paint()..color = AppTheme.skyBlue;
        canvas.drawOval(Rect.fromCenter(center: center, width: r * 1.1, height: r * 0.75), f);
        final tail = Path()..moveTo(center.dx - r * 0.5, center.dy)..lineTo(center.dx - r * 0.9, center.dy - r * 0.4)..lineTo(center.dx - r * 0.9, center.dy + r * 0.4)..close();
        canvas.drawPath(tail, f);
        break;

      case 'G': // Grapes
        final g = Paint()..color = AppTheme.lavender;
        canvas.drawCircle(center + Offset(-r * 0.2, -r * 0.2), r * 0.3, g);
        canvas.drawCircle(center + Offset(r * 0.2, -r * 0.2), r * 0.3, g);
        canvas.drawCircle(center + Offset(0, r * 0.15), r * 0.3, g);
        canvas.drawCircle(center + Offset(0, r * 0.5), r * 0.25, g);
        break;

      case 'H': // Hen
        final hen = Paint()..color = AppTheme.peach;
        canvas.drawCircle(center, r * 0.6, hen);
        final comb = Paint()..color = AppTheme.coral;
        canvas.drawCircle(center + Offset(0, -r * 0.6), r * 0.2, comb);
        break;

      case 'I': // Ice Cream
        final cone = Paint()..color = AppTheme.yellow;
        final path = Path()..moveTo(center.dx - r * 0.3, center.dy)..lineTo(center.dx + r * 0.3, center.dy)..lineTo(center.dx, center.dy + r * 0.8)..close();
        canvas.drawPath(path, cone);
        final scoop = Paint()..color = AppTheme.coral;
        canvas.drawCircle(center + Offset(0, -r * 0.2), r * 0.45, scoop);
        break;

      case 'J': // Jug
        final jug = Paint()..color = AppTheme.skyBlue;
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: center, width: r * 0.9, height: r * 1.1), const Radius.circular(16)), jug);
        break;

      case 'K': // Kite
        final kite = Paint()..color = AppTheme.coral;
        final path = Path()
          ..moveTo(center.dx, center.dy - r * 0.8)
          ..lineTo(center.dx + r * 0.6, center.dy)
          ..lineTo(center.dx, center.dy + r * 0.8)
          ..lineTo(center.dx - r * 0.6, center.dy)
          ..close();
        canvas.drawPath(path, kite);
        break;

      case 'L': // Lion
        final mane = Paint()..color = AppTheme.yellow;
        canvas.drawCircle(center, r * 0.78, mane);
        final face = Paint()..color = AppTheme.peach;
        canvas.drawCircle(center, r * 0.5, face);
        break;

      case 'M': // Mango
        final m = Paint()..color = AppTheme.yellow;
        canvas.drawOval(Rect.fromCenter(center: center, width: r * 0.9, height: r * 1.2), m);
        break;

      case 'N': // Nest
        final nest = Paint()..color = AppTheme.peach;
        canvas.drawArc(Rect.fromCircle(center: center + Offset(0, r * 0.1), radius: r * 0.65), 0, pi, true, nest);
        final egg = Paint()..color = Colors.white;
        canvas.drawOval(Rect.fromCenter(center: center + Offset(-r * 0.2, -r * 0.1), width: r * 0.3, height: r * 0.4), egg);
        canvas.drawOval(Rect.fromCenter(center: center + Offset(r * 0.2, -r * 0.1), width: r * 0.3, height: r * 0.4), egg);
        break;

      case 'O': // Orange
        final o = Paint()..color = AppTheme.peach;
        canvas.drawCircle(center, r * 0.7, o);
        final leaf = Paint()..color = AppTheme.mintGreen;
        canvas.drawCircle(center + Offset(0, -r * 0.7), r * 0.18, leaf);
        break;

      case 'P': // Parrot
        final p = Paint()..color = AppTheme.mintGreen;
        canvas.drawCircle(center, r * 0.65, p);
        final beak = Paint()..color = AppTheme.coral;
        canvas.drawCircle(center + Offset(r * 0.45, 0), r * 0.2, beak);
        break;

      case 'Q': // Queen
        final crown = Paint()..color = AppTheme.yellow;
        final path = Path()
          ..moveTo(center.dx - r * 0.6, center.dy + r * 0.4)
          ..lineTo(center.dx - r * 0.6, center.dy - r * 0.4)
          ..lineTo(center.dx - r * 0.2, center.dy)
          ..lineTo(center.dx, center.dy - r * 0.5)
          ..lineTo(center.dx + r * 0.2, center.dy)
          ..lineTo(center.dx + r * 0.6, center.dy - r * 0.4)
          ..lineTo(center.dx + r * 0.6, center.dy + r * 0.4)
          ..close();
        canvas.drawPath(path, crown);
        break;

      case 'R': // Rabbit
        final body = Paint()..color = Colors.white;
        canvas.drawCircle(center + const Offset(0, 10), r * 0.55, body);
        final ear = Paint()..color = AppTheme.lavender;
        canvas.drawOval(Rect.fromCenter(center: center + Offset(-r * 0.22, -r * 0.55), width: r * 0.28, height: r * 0.7), ear);
        canvas.drawOval(Rect.fromCenter(center: center + Offset(r * 0.22, -r * 0.55), width: r * 0.28, height: r * 0.7), ear);
        break;

      case 'S': // Sun
        final sun = Paint()..color = AppTheme.yellow;
        canvas.drawCircle(center, r * 0.5, sun);
        final ray = Paint()..color = AppTheme.coral..strokeWidth = 5;
        for (int i = 0; i < 8; i++) {
          final a = i * (pi / 4);
          canvas.drawLine(center + Offset(cos(a) * (r * 0.55), sin(a) * (r * 0.55)), center + Offset(cos(a) * (r * 0.78), sin(a) * (r * 0.78)), ray);
        }
        break;

      case 'T': // Tiger
        final t = Paint()..color = AppTheme.peach;
        canvas.drawCircle(center, r * 0.65, t);
        final stripe = Paint()..color = AppTheme.navy..strokeWidth = 4;
        canvas.drawLine(center + Offset(-r * 0.3, -r * 0.2), center + Offset(-r * 0.1, -r * 0.2), stripe);
        canvas.drawLine(center + Offset(r * 0.1, -r * 0.2), center + Offset(r * 0.3, -r * 0.2), stripe);
        break;

      case 'U': // Umbrella
        final u = Paint()..color = AppTheme.skyBlue;
        canvas.drawArc(Rect.fromCircle(center: center, radius: r * 0.7), pi, pi, true, u);
        final handle = Paint()..color = AppTheme.navy..style = PaintingStyle.stroke..strokeWidth = 4;
        canvas.drawLine(center, center + Offset(0, r * 0.7), handle);
        break;

      case 'V': // Van
        final van = Paint()..color = AppTheme.mintGreen;
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: center, width: r * 1.3, height: r * 0.7), const Radius.circular(12)), van);
        final wheel = Paint()..color = AppTheme.navy;
        canvas.drawCircle(center + Offset(-r * 0.4, r * 0.35), r * 0.18, wheel);
        canvas.drawCircle(center + Offset(r * 0.4, r * 0.35), r * 0.18, wheel);
        break;

      case 'W': // Watch
        final strap = Paint()..color = AppTheme.coral;
        canvas.drawRect(Rect.fromCenter(center: center, width: r * 0.3, height: r * 1.4), strap);
        final face = Paint()..color = AppTheme.cream;
        canvas.drawCircle(center, r * 0.45, face);
        break;

      case 'X': // Xylophone
        final bars = [AppTheme.coral, AppTheme.yellow, AppTheme.mintGreen, AppTheme.skyBlue, AppTheme.lavender];
        for (int i = 0; i < bars.length; i++) {
          final p = Paint()..color = bars[i];
          canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(center.dx - r * 0.6 + (i * r * 0.26), center.dy - r * 0.5 + (i * 6), r * 0.2, r * 1.0 - (i * 8)), const Radius.circular(6)), p);
        }
        break;

      case 'Y': // Yak
        final y = Paint()..color = AppTheme.peach;
        canvas.drawCircle(center, r * 0.6, y);
        final horn = Paint()..color = AppTheme.navy..style = PaintingStyle.stroke..strokeWidth = 5;
        canvas.drawArc(Rect.fromCircle(center: center + Offset(-r * 0.3, -r * 0.3), radius: r * 0.3), pi, pi / 2, false, horn);
        canvas.drawArc(Rect.fromCircle(center: center + Offset(r * 0.3, -r * 0.3), radius: r * 0.3), -pi / 2, pi / 2, false, horn);
        break;

      case 'Z': // Zebra
        final z = Paint()..color = Colors.white;
        canvas.drawCircle(center, r * 0.65, z);
        final stripe = Paint()..color = AppTheme.navy..strokeWidth = 5;
        canvas.drawLine(center + Offset(-r * 0.4, -r * 0.1), center + Offset(-r * 0.1, -r * 0.1), stripe);
        canvas.drawLine(center + Offset(r * 0.1, -r * 0.1), center + Offset(r * 0.4, -r * 0.1), stripe);
        canvas.drawLine(center + Offset(-r * 0.3, r * 0.15), center + Offset(r * 0.3, r * 0.15), stripe);
        break;

      default:
        final defaultBg = Paint()..color = AppTheme.skyBlue;
        canvas.drawCircle(center, r * 0.65, defaultBg);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _FlashcardItemPainter oldDelegate) => oldDelegate.letterId != letterId;
}
