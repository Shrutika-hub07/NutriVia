import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';

class GarlandStreakWidget extends StatelessWidget {
  final int streakDays;
  final VoidCallback onTap;

  const GarlandStreakWidget({
    super.key,
    required this.streakDays,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: NutriviaColors.snow,
          borderRadius: NutriviaShapes.pill,
          border: Border.all(color: NutriviaColors.lavenderMist, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: NutriviaColors.plum.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Custom Garland Blossom
            CustomPaint(
              size: const Size(20, 20),
              painter: _SmallGarlandBlossomPainter(),
            ),
            const SizedBox(width: 6),
            Text(
              '$streakDays d',
              style: const TextStyle(
                color: NutriviaColors.plum,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.arrow_forward_ios_rounded, color: NutriviaColors.stone, size: 10),
          ],
        ),
      ),
    );
  }
}

class _SmallGarlandBlossomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = NutriviaColors.marigold
      ..style = PaintingStyle.fill;

    const petals = 6;
    for (int i = 0; i < petals; i++) {
      final rad = (i * 2 * 3.14159) / petals;
      final px = center.dx + (size.width * 0.28 * mathCos(rad));
      final py = center.dy + (size.height * 0.28 * mathSin(rad));
      canvas.drawCircle(Offset(px, py), size.width * 0.18, paint);
    }
    // Center dot
    canvas.drawCircle(center, size.width * 0.14, Paint()..color = NutriviaColors.plum);
  }

  double mathCos(double v) => v == 0 ? 1 : (v == 3.14159 ? -1 : 0.5);
  double mathSin(double v) => 0.866;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
