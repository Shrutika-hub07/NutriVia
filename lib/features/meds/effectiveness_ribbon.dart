import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';

class MedicineEffectivenessRibbon extends StatelessWidget {
  final String medicineName;
  final String targetProblem;
  final int severityBefore; // e.g. 7 or 8 (out of 10)
  final int severityAfter; // e.g. 4 (out of 10)
  final double adherencePercent; // e.g. 92.0%
  final String notes;

  const MedicineEffectivenessRibbon({
    super.key,
    required this.medicineName,
    required this.targetProblem,
    required this.severityBefore,
    required this.severityAfter,
    required this.adherencePercent,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NutriviaColors.snow,
        borderRadius: NutriviaShapes.organicCard,
        border: Border.all(color: NutriviaColors.lavenderMist),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  medicineName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: NutriviaColors.statusOk.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: NutriviaColors.statusOk),
                ),
                child: const Text(
                  'Improving (Noted Relief)',
                  style: TextStyle(color: NutriviaColors.statusOk, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Target problem: $targetProblem',
            style: const TextStyle(fontSize: 13, color: NutriviaColors.stone, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),

          // Flowing Before/After Severity Ribbon
          SizedBox(
            height: 90,
            child: CustomPaint(
              size: const Size(double.infinity, 90),
              painter: _RibbonPainter(
                severityBefore: severityBefore,
                severityAfter: severityAfter,
                adherence: adherencePercent,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Adherence Petals indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_florist, color: NutriviaColors.marigold, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Adherence: ${adherencePercent.toInt()}% taken as prescribed',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: NutriviaColors.nightPlum),
                  ),
                ],
              ),
              const Text(
                'Retest suggested: ~8-12 wks',
                style: TextStyle(fontSize: 12, color: NutriviaColors.stone),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Observational Note
          Text(
            notes,
            style: const TextStyle(fontSize: 13, color: NutriviaColors.nightPlum, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class _RibbonPainter extends CustomPainter {
  final int severityBefore;
  final int severityAfter;
  final double adherence;

  _RibbonPainter({
    required this.severityBefore,
    required this.severityAfter,
    required this.adherence,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Severity Curve (Severity Before -> Severity After)
    // Map 10 (top) to 0 (bottom)
    final yBefore = (10 - severityBefore) / 10.0 * (h * 0.5) + (h * 0.1);
    final yAfter = (10 - severityAfter) / 10.0 * (h * 0.5) + (h * 0.1);

    final curvePath = Path();
    curvePath.moveTo(20, yBefore);
    curvePath.cubicTo(w * 0.4, yBefore, w * 0.6, yAfter, w - 20, yAfter);

    final linePaint = Paint()
      ..color = NutriviaColors.plum
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(curvePath, linePaint);

    // Start-date marker dot
    final startDot = Paint()..color = NutriviaColors.statusAlert;
    canvas.drawCircle(Offset(20, yBefore), 6, startDot);

    // Current improved dot
    final endDot = Paint()..color = NutriviaColors.statusOk;
    canvas.drawCircle(Offset(w - 20, yAfter), 6, endDot);

    // Text labels for severity
    _drawText(canvas, 'Before: $severityBefore/10', Offset(10, yBefore - 20), NutriviaColors.statusAlert);
    _drawText(canvas, 'Now: $severityAfter/10', Offset(w - 75, yAfter - 20), NutriviaColors.statusOk);

    // Adherence Petals row beneath
    final petalCount = 8;
    final step = (w - 40) / (petalCount - 1);
    final petalPaint = Paint()..color = NutriviaColors.marigold..style = PaintingStyle.fill;
    final missedPaint = Paint()..color = NutriviaColors.lavenderMist..style = PaintingStyle.fill;

    for (int i = 0; i < petalCount; i++) {
      final px = 20 + (i * step);
      final py = h - 14;
      final isTaken = (i / petalCount) < (adherence / 100.0);
      canvas.drawCircle(Offset(px, py), 4.5, isTaken ? petalPaint : missedPaint);
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _RibbonPainter oldDelegate) => true;
}
