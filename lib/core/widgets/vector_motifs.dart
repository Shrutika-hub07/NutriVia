import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/tokens.dart';

/// Single Petal Vector Graphic
class PetalPainter extends CustomPainter {
  final Color color;
  final bool fill;

  PetalPainter({this.color = NutriviaColors.marigold, this.fill = true});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.5, size.height);
    path.cubicTo(
      0, size.height * 0.6,
      0, size.height * 0.2,
      size.width * 0.5, 0,
    );
    path.cubicTo(
      size.width, size.height * 0.2,
      size.width, size.height * 0.6,
      size.width * 0.5, size.height,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant PetalPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.fill != fill;
}

/// Poppy / Lotus Stylized Vector Motif
class LotusPoppyPainter extends CustomPainter {
  final Color color;
  final double opacity;

  LotusPoppyPainter({this.color = NutriviaColors.plum, this.opacity = 0.15});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color.withValues(alpha: opacity * 1.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final w = size.width;
    final h = size.height;

    // Center petal
    final centerPath = Path();
    centerPath.moveTo(w * 0.5, h * 0.9);
    centerPath.cubicTo(w * 0.35, h * 0.5, w * 0.4, h * 0.1, w * 0.5, 0);
    centerPath.cubicTo(w * 0.6, h * 0.1, w * 0.65, h * 0.5, w * 0.5, h * 0.9);
    canvas.drawPath(centerPath, paint);
    canvas.drawPath(centerPath, strokePaint);

    // Left petal
    final leftPath = Path();
    leftPath.moveTo(w * 0.5, h * 0.9);
    leftPath.cubicTo(w * 0.15, h * 0.7, w * 0.1, h * 0.3, w * 0.25, h * 0.15);
    leftPath.cubicTo(w * 0.4, h * 0.3, w * 0.45, h * 0.6, w * 0.5, h * 0.9);
    canvas.drawPath(leftPath, paint);
    canvas.drawPath(leftPath, strokePaint);

    // Right petal
    final rightPath = Path();
    rightPath.moveTo(w * 0.5, h * 0.9);
    rightPath.cubicTo(w * 0.85, h * 0.7, w * 0.9, h * 0.3, w * 0.75, h * 0.15);
    rightPath.cubicTo(w * 0.6, h * 0.3, w * 0.55, h * 0.6, w * 0.5, h * 0.9);
    canvas.drawPath(rightPath, paint);
    canvas.drawPath(rightPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant LotusPoppyPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.opacity != opacity;
}

/// Organic Leaf Sprig
class LeafSprigPainter extends CustomPainter {
  final Color color;

  LeafSprigPainter({this.color = NutriviaColors.statusOk});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final fill = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final stem = Path();
    stem.moveTo(size.width * 0.5, size.height);
    stem.quadraticBezierTo(size.width * 0.45, size.height * 0.5, size.width * 0.5, 0);
    canvas.drawPath(stem, stroke);

    // Side leaves
    void drawLeaf(double cx, double cy, double rx, double ry, double angle) {
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(angle);
      final leaf = Path()
        ..addOval(Rect.fromCenter(center: Offset.zero, width: rx, height: ry));
      canvas.drawPath(leaf, fill);
      canvas.restore();
    }

    drawLeaf(size.width * 0.35, size.height * 0.65, 16, 7, -math.pi / 4);
    drawLeaf(size.width * 0.65, size.height * 0.55, 16, 7, math.pi / 4);
    drawLeaf(size.width * 0.38, size.height * 0.35, 14, 6, -math.pi / 4);
    drawLeaf(size.width * 0.62, size.height * 0.25, 14, 6, math.pi / 4);
  }

  @override
  bool shouldRepaint(covariant LeafSprigPainter oldDelegate) => oldDelegate.color != color;
}

/// Kolam / Rangoli Inspired Line Pattern
class KolamRangoliPainter extends CustomPainter {
  final Color color;
  final double opacity;

  KolamRangoliPainter({this.color = NutriviaColors.lavenderMist, this.opacity = 0.5});

  @override
  void paint(Canvas canvas, Size size) {
    // Clip strictly within provided canvas bounds to avoid any overflow
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final step = 24.0;
    for (double x = 12; x < size.width; x += step) {
      for (double y = 12; y < size.height; y += step) {
        // Draw small rangoli petal loop within step boundary
        final path = Path();
        path.moveTo(x - 6, y);
        path.cubicTo(x, y - 6, x, y - 6, x + 6, y);
        path.cubicTo(x, y + 6, x, y + 6, x - 6, y);
        canvas.drawPath(path, paint);

        // Center dot
        canvas.drawCircle(Offset(x, y), 1.2, Paint()..color = color.withValues(alpha: opacity * 1.2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant KolamRangoliPainter oldDelegate) => false;
}

/// Scalloped Bottom Edge for Home Hero
class ScallopedBorderClipper extends CustomClipper<Path> {
  final double scallopDepth;
  final int scallopCount;

  ScallopedBorderClipper({this.scallopDepth = 12.0, this.scallopCount = 8});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - scallopDepth);

    final step = size.width / scallopCount;
    for (int i = 0; i < scallopCount; i++) {
      final startX = i * step;
      final endX = (i + 1) * step;
      final midX = startX + (step / 2);
      path.quadraticBezierTo(midX, size.height, endX, size.height - scallopDepth);
    }

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant ScallopedBorderClipper oldClipper) => false;
}
