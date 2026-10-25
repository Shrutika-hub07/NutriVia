import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';

class ConstellationNode {
  final String id;
  final String label;
  final double x; // 0.0 - 1.0
  final double y;
  final int severity; // 0 - 10
  final String correlatedWith;
  final String insightText;

  ConstellationNode({
    required this.id,
    required this.label,
    required this.x,
    required this.y,
    required this.severity,
    required this.correlatedWith,
    required this.insightText,
  });
}

class SymptomConstellationWidget extends StatefulWidget {
  final String language;

  const SymptomConstellationWidget({super.key, required this.language});

  @override
  State<SymptomConstellationWidget> createState() => _SymptomConstellationWidgetState();
}

class _SymptomConstellationWidgetState extends State<SymptomConstellationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  ConstellationNode? selectedNode;

  final List<ConstellationNode> nodes = [
    ConstellationNode(
      id: 'fatigue',
      label: 'Fatigue',
      x: 0.28,
      y: 0.32,
      severity: 8,
      correlatedWith: 'sleep',
      insightText: 'Fatigue spikes 2.4x on nights sleep falls below 6 hours.',
    ),
    ConstellationNode(
      id: 'knee_pain',
      label: 'Knee Pain',
      x: 0.72,
      y: 0.38,
      severity: 7,
      correlatedWith: 'fasting',
      insightText: 'Knee stiffness decreases on days with curd/chaas intake.',
    ),
    ConstellationNode(
      id: 'leg_cramps',
      label: 'Leg Cramps',
      x: 0.50,
      y: 0.62,
      severity: 8,
      correlatedWith: 'fasting',
      insightText: 'Leg cramps appear mostly 4-6 hours after Monday/Ekadashi fasts.',
    ),
    ConstellationNode(
      id: 'tingling',
      label: 'Tingling / Soles',
      x: 0.30,
      y: 0.78,
      severity: 6,
      correlatedWith: 'tea',
      insightText: 'Tingling clusters on days tea is taken with heavy meals.',
    ),
    ConstellationNode(
      id: 'headache',
      label: 'Headache',
      x: 0.68,
      y: 0.76,
      severity: 5,
      correlatedWith: 'sleep',
      insightText: 'Morning headaches occur on days after interrupted sleep.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    selectedNode = nodes.first;
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Constellation Canvas Box
        Container(
          width: double.infinity,
          height: 280,
          decoration: BoxDecoration(
            color: NutriviaColors.nightPlum,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: NutriviaColors.plum.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              return Stack(
                children: [
                  CustomPaint(
                    size: const Size(double.infinity, 280),
                    painter: _ConstellationPainter(
                      nodes: nodes,
                      glowValue: _glowController.value,
                      selectedId: selectedNode?.id,
                    ),
                  ),

                  // Clickable Invisible Touch Rings over each star
                  LayoutBuilder(
                    builder: (ctx, constraints) {
                      final w = constraints.maxWidth;
                      const h = 280.0;

                      return Stack(
                        children: nodes.map((n) {
                          return Positioned(
                            left: (n.x * w) - 30,
                            top: (n.y * h) - 30,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedNode = n;
                                });
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                color: Colors.transparent,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 14),

        // Correlation Callout Card
        if (selectedNode != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NutriviaColors.cream,
              borderRadius: NutriviaShapes.organicCard,
              border: Border.all(color: NutriviaColors.peach, width: 1.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome, color: NutriviaColors.marigold, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Observed Pattern: ${selectedNode!.label}',
                        style: const TextStyle(
                          color: NutriviaColors.plum,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedNode!.insightText,
                        style: const TextStyle(
                          color: NutriviaColors.nightPlum,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ConstellationPainter extends CustomPainter {
  final List<ConstellationNode> nodes;
  final double glowValue;
  final String? selectedId;

  _ConstellationPainter({
    required this.nodes,
    required this.glowValue,
    this.selectedId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background faint stars
    final random = math.Random(42);
    final faintStar = Paint()..color = Colors.white.withValues(alpha: 0.25);
    for (int i = 0; i < 35; i++) {
      canvas.drawCircle(Offset(random.nextDouble() * w, random.nextDouble() * h), 1.0, faintStar);
    }

    // Connect nodes with celestial links
    final linkPaint = Paint()
      ..color = NutriviaColors.peach.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final p1 = Offset(nodes[i].x * w, nodes[i].y * h);
        final p2 = Offset(nodes[j].x * w, nodes[j].y * h);
        final dist = (p1 - p2).distance;
        if (dist < w * 0.45) {
          canvas.drawLine(p1, p2, linkPaint);
        }
      }
    }

    // Draw glowing star nodes
    for (var node in nodes) {
      final pos = Offset(node.x * w, node.y * h);
      final isSelected = node.id == selectedId;
      final severityScale = 0.6 + (node.severity / 10.0 * 0.4);

      // Outer Pulsing Glow
      final glowPaint = Paint()
        ..color = NutriviaColors.marigold.withValues(alpha: 0.20 + (glowValue * 0.25))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(pos, 16 * severityScale * (1.0 + glowValue * 0.15), glowPaint);

      // Star Core
      final corePaint = Paint()
        ..color = isSelected ? Colors.white : NutriviaColors.marigold
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pos, 7 * severityScale, corePaint);

      // Selected ring
      if (isSelected) {
        final ringPaint = Paint()
          ..color = NutriviaColors.marigold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        canvas.drawCircle(pos, 12, ringPaint);
      }

      // Star Label
      final tp = TextPainter(
        text: TextSpan(
          text: node.label,
          style: TextStyle(
            color: isSelected ? NutriviaColors.peach : Colors.white.withValues(alpha: 0.85),
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(pos.dx - (tp.width / 2), pos.dy + 12));
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationPainter oldDelegate) =>
      oldDelegate.glowValue != glowValue || oldDelegate.selectedId != selectedId;
}
