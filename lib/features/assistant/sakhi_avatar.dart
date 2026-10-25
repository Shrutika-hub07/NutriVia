import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';

class SakhiAvatarWidget extends StatefulWidget {
  final int styleIndex; // 0: Traditional Paithani, 1: Cotton Saree, 2: Modern Kurta
  final bool isSpeaking;
  final bool isReducedMotion;
  final double size;

  const SakhiAvatarWidget({
    super.key,
    this.styleIndex = 0,
    this.isSpeaking = false,
    this.isReducedMotion = false,
    this.size = 140,
  });

  @override
  State<SakhiAvatarWidget> createState() => _SakhiAvatarWidgetState();
}

class _SakhiAvatarWidgetState extends State<SakhiAvatarWidget>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late AnimationController _swayController;
  late AnimationController _mouthController;

  @override
  void initState() {
    super.initState();
    // Blinking animation: fires periodically
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _swayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _mouthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );

    if (!widget.isReducedMotion) {
      _startPeriodicBlink();
    }
  }

  void _startPeriodicBlink() async {
    while (mounted) {
      await Future.delayed(Duration(milliseconds: 2500 + math.Random().nextInt(2000)));
      if (mounted && !widget.isReducedMotion) {
        await _blinkController.forward();
        await _blinkController.reverse();
      }
    }
  }

  @override
  void didUpdateWidget(covariant SakhiAvatarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpeaking && !oldWidget.isSpeaking) {
      _mouthController.repeat(reverse: true);
    } else if (!widget.isSpeaking && oldWidget.isSpeaking) {
      _mouthController.stop();
      _mouthController.reset();
    }
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _swayController.dispose();
    _mouthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isReducedMotion) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: _SakhiVectorPainter(
            styleIndex: widget.styleIndex,
            blinkValue: 0.0,
            mouthOpenValue: 0.0,
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_blinkController, _swayController, _mouthController]),
      builder: (context, child) {
        // Idle gentle breathing & head sway
        final swayAngle = math.sin(_swayController.value * 2 * math.pi) * 0.025;
        final floatY = math.cos(_swayController.value * 2 * math.pi) * 1.5;

        return Transform.translate(
          offset: Offset(0, floatY),
          child: Transform.rotate(
            angle: swayAngle,
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: CustomPaint(
                painter: _SakhiVectorPainter(
                  styleIndex: widget.styleIndex,
                  blinkValue: _blinkController.value,
                  mouthOpenValue: widget.isSpeaking ? _mouthController.value : 0.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SakhiVectorPainter extends CustomPainter {
  final int styleIndex;
  final double blinkValue;
  final double mouthOpenValue;

  _SakhiVectorPainter({
    required this.styleIndex,
    required this.blinkValue,
    required this.mouthOpenValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // Warm background circle frame
    final haloPaint = Paint()
      ..color = NutriviaColors.peach.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, w * 0.48, haloPaint);

    // Drapes / Clothing Colors according to style
    Color drapePrimary;
    Color drapeBorder;
    switch (styleIndex) {
      case 1: // Cotton Saree
        drapePrimary = NutriviaColors.plum;
        drapeBorder = NutriviaColors.marigold;
        break;
      case 2: // Modern Kurta
        drapePrimary = NutriviaColors.terracotta;
        drapeBorder = NutriviaColors.peach;
        break;
      case 0: // Traditional Paithani drape
      default:
        drapePrimary = NutriviaColors.deepPlum;
        drapeBorder = NutriviaColors.marigold;
        break;
    }

    // Shoulders & Drape
    final bodyPaint = Paint()..color = drapePrimary..style = PaintingStyle.fill;
    final bodyPath = Path();
    bodyPath.moveTo(w * 0.15, h);
    bodyPath.quadraticBezierTo(w * 0.22, h * 0.72, w * 0.38, h * 0.68);
    bodyPath.lineTo(w * 0.62, h * 0.68);
    bodyPath.quadraticBezierTo(w * 0.78, h * 0.72, w * 0.85, h);
    bodyPath.close();
    canvas.drawPath(bodyPath, bodyPaint);

    // Diagonal Pallu / Saree fold
    final borderPaint = Paint()
      ..color = drapeBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    final pallu = Path();
    pallu.moveTo(w * 0.30, h);
    pallu.quadraticBezierTo(w * 0.45, h * 0.80, w * 0.62, h * 0.68);
    canvas.drawPath(pallu, borderPaint);

    // Neck
    final skinTone = const Color(0xFFD49C76);
    final neckPaint = Paint()..color = skinTone..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(w * 0.44, h * 0.52, w * 0.12, h * 0.20), neckPaint);

    // Traditional Mangalsutra / Chain
    final jewelryPaint = Paint()..color = const Color(0xFFE5A823)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(w * 0.5, h * 0.64), radius: w * 0.12),
      0.2,
      2.74,
      false,
      jewelryPaint,
    );

    // Face Oval
    final faceCenter = Offset(w * 0.5, h * 0.44);
    canvas.drawOval(
      Rect.fromCenter(center: faceCenter, width: w * 0.36, height: h * 0.42),
      neckPaint,
    );

    // Hair silhouette & Bun
    final hairPaint = Paint()..color = const Color(0xFF23161C)..style = PaintingStyle.fill;
    // Hair Bun on top/back
    canvas.drawCircle(Offset(w * 0.5, h * 0.20), w * 0.16, hairPaint);
    // Hair Front parted
    final hairFront = Path();
    hairFront.moveTo(w * 0.30, h * 0.40);
    hairFront.quadraticBezierTo(w * 0.36, h * 0.20, w * 0.5, h * 0.28);
    hairFront.quadraticBezierTo(w * 0.64, h * 0.20, w * 0.70, h * 0.40);
    hairFront.quadraticBezierTo(w * 0.50, h * 0.32, w * 0.30, h * 0.40);
    canvas.drawPath(hairFront, hairPaint);

    // Small Bindi (Traditional Chandrakor or round maroon)
    final bindiPaint = Paint()..color = const Color(0xFF8B1E2F)..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.5, h * 0.36), 3.0, bindiPaint);

    // Eyes (with animated blink)
    final eyePaint = Paint()..color = const Color(0xFF2A1E24)..style = PaintingStyle.stroke..strokeWidth = 2.0..strokeCap = StrokeCap.round;
    if (blinkValue > 0.5) {
      // Closed smiling eye arcs
      canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.42, h * 0.43), width: 14, height: 8), 0, 3.14, false, eyePaint);
      canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.58, h * 0.43), width: 14, height: 8), 0, 3.14, false, eyePaint);
    } else {
      // Open warm almond eyes
      final pupilPaint = Paint()..color = const Color(0xFF2A1E24)..style = PaintingStyle.fill;
      canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.42, h * 0.43), width: 10, height: 6), pupilPaint);
      canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.58, h * 0.43), width: 10, height: 6), pupilPaint);
      // Gentle kajal arc
      canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.42, h * 0.41), width: 14, height: 6), 3.14, 3.14, false, eyePaint);
      canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.58, h * 0.41), width: 14, height: 6), 3.14, 3.14, false, eyePaint);
    }

    // Warm Smile & Speaking Mouth
    final lipPaint = Paint()
      ..color = const Color(0xFFB54958)
      ..style = mouthOpenValue > 0.2 ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final mouthY = h * 0.54;
    if (mouthOpenValue > 0.2) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(w * 0.5, mouthY), width: 12, height: 4 + (mouthOpenValue * 6)),
        lipPaint,
      );
    } else {
      final smile = Path();
      smile.moveTo(w * 0.45, mouthY);
      smile.quadraticBezierTo(w * 0.50, mouthY + 5, w * 0.55, mouthY);
      canvas.drawPath(smile, lipPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SakhiVectorPainter oldDelegate) =>
      oldDelegate.styleIndex != styleIndex ||
      oldDelegate.blinkValue != blinkValue ||
      oldDelegate.mouthOpenValue != mouthOpenValue;
}
