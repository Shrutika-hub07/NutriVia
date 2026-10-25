import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';
import '../../core/services/rules_service.dart';
import '../../core/localization/app_strings.dart';

class NutriBloomFlowerWidget extends StatefulWidget {
  final List<NutriBloomPetalData> petals;
  final String language;
  final Function(NutriBloomPetalData) onPetalTap;

  const NutriBloomFlowerWidget({
    super.key,
    required this.petals,
    required this.language,
    required this.onPetalTap,
  });

  @override
  State<NutriBloomFlowerWidget> createState() => _NutriBloomFlowerWidgetState();
}

class _NutriBloomFlowerWidgetState extends State<NutriBloomFlowerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _bloomAnim;

  @override
  void initState() {
    super.initState();
    _bloomAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void didUpdateWidget(covariant NutriBloomFlowerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.petals != widget.petals) {
      _bloomAnim.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _bloomAnim.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ok':
        return NutriviaColors.statusOk;
      case 'watch':
        return NutriviaColors.statusWatch;
      case 'alert':
      default:
        return NutriviaColors.statusAlert;
    }
  }

  @override
  Widget build(BuildContext context) {
    const size = 300.0;
    const center = Offset(size / 2, size / 2);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft botanical aura
          Container(
            width: size * 0.9,
            height: size * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: NutriviaColors.peach.withValues(alpha: 0.22),
            ),
          ),

          // Custom Painter for Animated Petals
          AnimatedBuilder(
            animation: _bloomAnim,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(size, size),
                painter: _BloomPainter(
                  petals: widget.petals,
                  progress: _bloomAnim.value,
                  getStatusColor: _getStatusColor,
                ),
              );
            },
          ),

          // Clickable Petal Overlay Touch Targets
          ...widget.petals.asMap().entries.map((entry) {
            final petal = entry.value;
            final rad = petal.angle;
            final dist = size * 0.34;
            final px = center.dx + (dist * math.cos(rad));
            final py = center.dy + (dist * math.sin(rad));

            final nutrientLabel = AppStrings.get(petal.nameKey, widget.language);

            return Positioned(
              left: px - 36,
              top: py - 20,
              child: GestureDetector(
                onTap: () => widget.onPetalTap(petal),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(petal.status),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    nutrientLabel,
                    style: TextStyle(
                      color: NutriviaColors.nightPlum,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            );
          }),

          // Center Pistil Motif
          GestureDetector(
            onTap: () {
              if (widget.petals.isNotEmpty) {
                widget.onPetalTap(widget.petals.first);
              }
            },
            child: Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: NutriviaColors.marigold,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: NutriviaColors.marigold.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.spa_rounded, color: Colors.white, size: 24),
                    Text(
                      'Nutri',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BloomPainter extends CustomPainter {
  final List<NutriBloomPetalData> petals;
  final double progress;
  final Color Function(String) getStatusColor;

  _BloomPainter({
    required this.petals,
    required this.progress,
    required this.getStatusColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxPetalLen = size.width * 0.38;

    for (var petal in petals) {
      final color = getStatusColor(petal.status);
      final currentScore = petal.score * progress;
      final petalLen = maxPetalLen * (0.4 + (0.6 * currentScore));

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(petal.angle);

      // Draw Petal Base
      final path = Path();
      path.moveTo(0, 0);
      path.cubicTo(
        petalLen * 0.4, -28 * currentScore,
        petalLen * 0.8, -14 * currentScore,
        petalLen, 0,
      );
      path.cubicTo(
        petalLen * 0.8, 14 * currentScore,
        petalLen * 0.4, 28 * currentScore,
        0, 0,
      );
      path.close();

      // Translucent Petal Fill
      final fillPaint = Paint()
        ..color = color.withValues(alpha: 0.35 + (0.35 * currentScore))
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);

      // Distinct Petal Border
      final borderPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, borderPaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _BloomPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.petals != petals;
}

/// Detailed Nutri-Bloom Modal Bottom Sheet
void showNutriBloomPetalSheet({
  required BuildContext context,
  required NutriBloomPetalData petal,
  required String language,
}) {
  final nutrientName = AppStrings.get(petal.nameKey, language);

  Color statusColor = NutriviaColors.statusOk;
  String statusLabel = 'Well Nourished';
  if (petal.status == 'alert') {
    statusColor = NutriviaColors.statusAlert;
    statusLabel = 'Attention Needed';
  } else if (petal.status == 'watch') {
    statusColor = NutriviaColors.statusWatch;
    statusLabel = 'Mindful Gap';
  }

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: NutriviaColors.snow,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: NutriviaColors.lavenderMist,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.local_florist, color: statusColor, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nutrientName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: NutriviaColors.plum,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            statusLabel,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Why it matters in midlife
            Text(
              AppStrings.get('why_this', language),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: NutriviaColors.terracotta,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              petal.whyMatters,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            // 3 Recommended Foods
            const Text(
              '3 Foods from your region to boost this:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: NutriviaColors.plum,
              ),
            ),
            const SizedBox(height: 10),
            ...petal.topFoods.take(3).map((food) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.eco_rounded, color: NutriviaColors.statusOk, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        food,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: NutriviaColors.nightPlum,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Close button
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppStrings.get('close', language)),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
