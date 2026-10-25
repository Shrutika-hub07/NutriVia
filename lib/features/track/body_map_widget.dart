import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';

class BodyPartTarget {
  final String id;
  final String label;
  final Offset relativePos; // (0.0 - 1.0) on canvas
  final List<String> commonSymptoms;

  BodyPartTarget({
    required this.id,
    required this.label,
    required this.relativePos,
    required this.commonSymptoms,
  });
}

class BodyMapWidget extends StatefulWidget {
  final Function(BodyPartTarget) onSelectPart;
  final List<String> activeSymptoms;

  const BodyMapWidget({
    super.key,
    required this.onSelectPart,
    required this.activeSymptoms,
  });

  @override
  State<BodyMapWidget> createState() => _BodyMapWidgetState();
}

class _BodyMapWidgetState extends State<BodyMapWidget> {
  bool isFront = true;

  final List<BodyPartTarget> frontParts = [
    BodyPartTarget(id: 'head', label: 'Head & Brain', relativePos: const Offset(0.5, 0.12), commonSymptoms: ['headache', 'brain_fog', 'dizziness']),
    BodyPartTarget(id: 'chest', label: 'Chest & Heart', relativePos: const Offset(0.5, 0.32), commonSymptoms: ['palpitations', 'breathlessness_on_stairs']),
    BodyPartTarget(id: 'abdomen', label: 'Abdomen & Pelvis', relativePos: const Offset(0.5, 0.46), commonSymptoms: ['waist_weight_gain', 'urinary_urgency']),
    BodyPartTarget(id: 'hands', label: 'Hands & Fingers', relativePos: const Offset(0.24, 0.48), commonSymptoms: ['tingling_numbness', 'brittle_nails']),
    BodyPartTarget(id: 'knees', label: 'Knees & Joints', relativePos: const Offset(0.5, 0.70), commonSymptoms: ['knee_pain', 'joint_stiffness']),
    BodyPartTarget(id: 'legs', label: 'Calves & Feet', relativePos: const Offset(0.5, 0.86), commonSymptoms: ['leg_pain_cramps', 'burning_soles']),
  ];

  final List<BodyPartTarget> backParts = [
    BodyPartTarget(id: 'neck', label: 'Neck & Shoulders', relativePos: const Offset(0.5, 0.18), commonSymptoms: ['headache', 'joint_stiffness']),
    BodyPartTarget(id: 'upper_back', label: 'Upper Back', relativePos: const Offset(0.5, 0.32), commonSymptoms: ['night_sweats', 'muscle_ache']),
    BodyPartTarget(id: 'lower_back', label: 'Lower Back & Spine', relativePos: const Offset(0.5, 0.46), commonSymptoms: ['bone_joint_pain', 'back_pain']),
    BodyPartTarget(id: 'calves_back', label: 'Leg Cramps / Calves', relativePos: const Offset(0.5, 0.78), commonSymptoms: ['leg_pain_cramps']),
  ];

  @override
  Widget build(BuildContext context) {
    final currentParts = isFront ? frontParts : backParts;

    return Column(
      children: [
        // Toggle Front / Back
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              label: const Text('Front Body'),
              selected: isFront,
              onSelected: (val) => setState(() => isFront = true),
              selectedColor: NutriviaColors.plum,
              labelStyle: TextStyle(
                color: isFront ? Colors.white : NutriviaColors.plum,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            ChoiceChip(
              label: const Text('Back Body'),
              selected: !isFront,
              onSelected: (val) => setState(() => isFront = false),
              selectedColor: NutriviaColors.plum,
              labelStyle: TextStyle(
                color: !isFront ? Colors.white : NutriviaColors.plum,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Interactive Silhouette Canvas
        Center(
          child: Container(
            width: 240,
            height: 380,
            decoration: BoxDecoration(
              color: NutriviaColors.snow,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: NutriviaColors.lavenderMist),
            ),
            child: Stack(
              children: [
                // Custom drawn female anatomical silhouette in brand purple
                CustomPaint(
                  size: const Size(240, 380),
                  painter: _BodySilhouettePainter(isFront: isFront),
                ),

                // Touchpoints
                ...currentParts.map((part) {
                  final hasActiveSymptom = part.commonSymptoms.any((s) => widget.activeSymptoms.contains(s));
                  final color = hasActiveSymptom ? NutriviaColors.statusAlert : NutriviaColors.plum;

                  return Positioned(
                    left: (part.relativePos.dx * 240) - 20,
                    top: (part.relativePos.dy * 380) - 20,
                    child: GestureDetector(
                      onTap: () => widget.onSelectPart(part),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withValues(alpha: 0.22),
                          border: Border.all(color: color, width: 2),
                        ),
                        child: Center(
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BodySilhouettePainter extends CustomPainter {
  final bool isFront;
  _BodySilhouettePainter({required this.isFront});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = NutriviaColors.lavenderMist.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final stroke = Paint()
      ..color = NutriviaColors.plum.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final w = size.width;
    final h = size.height;

    // Head
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.12), width: w * 0.18, height: h * 0.14), paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.12), width: w * 0.18, height: h * 0.14), stroke);

    // Torso & Pelvis
    final torso = Path();
    torso.moveTo(w * 0.38, h * 0.20);
    torso.lineTo(w * 0.62, h * 0.20);
    torso.quadraticBezierTo(w * 0.70, h * 0.32, w * 0.64, h * 0.44); // Waist taper
    torso.quadraticBezierTo(w * 0.72, h * 0.52, w * 0.62, h * 0.58); // Hip curve
    torso.lineTo(w * 0.38, h * 0.58);
    torso.quadraticBezierTo(w * 0.28, h * 0.52, w * 0.36, h * 0.44);
    torso.quadraticBezierTo(w * 0.30, h * 0.32, w * 0.38, h * 0.20);
    torso.close();
    canvas.drawPath(torso, paint);
    canvas.drawPath(torso, stroke);

    // Legs
    // Left Leg
    final leftLeg = Path();
    leftLeg.moveTo(w * 0.40, h * 0.58);
    leftLeg.quadraticBezierTo(w * 0.38, h * 0.72, w * 0.40, h * 0.92);
    leftLeg.lineTo(w * 0.47, h * 0.92);
    leftLeg.quadraticBezierTo(w * 0.47, h * 0.72, w * 0.48, h * 0.58);
    leftLeg.close();
    canvas.drawPath(leftLeg, paint);
    canvas.drawPath(leftLeg, stroke);

    // Right Leg
    final rightLeg = Path();
    rightLeg.moveTo(w * 0.52, h * 0.58);
    rightLeg.quadraticBezierTo(w * 0.53, h * 0.72, w * 0.53, h * 0.92);
    rightLeg.lineTo(w * 0.60, h * 0.92);
    rightLeg.quadraticBezierTo(w * 0.62, h * 0.72, w * 0.60, h * 0.58);
    rightLeg.close();
    canvas.drawPath(rightLeg, paint);
    canvas.drawPath(rightLeg, stroke);
  }

  @override
  bool shouldRepaint(covariant _BodySilhouettePainter oldDelegate) => oldDelegate.isFront != isFront;
}
