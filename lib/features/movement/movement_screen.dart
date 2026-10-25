import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';
import '../../core/services/voice_service.dart';

class YogaPose {
  final String sanskritName;
  final String englishName;
  final String benefits;
  final String precautions;
  final int defaultHoldSecs;

  const YogaPose({
    required this.sanskritName,
    required this.englishName,
    required this.benefits,
    required this.precautions,
    required this.defaultHoldSecs,
  });
}

class MovementScreen extends StatefulWidget {
  final String language;

  const MovementScreen({super.key, required this.language});

  @override
  State<MovementScreen> createState() => _MovementScreenState();
}

class _MovementScreenState extends State<MovementScreen> {
  final List<YogaPose> poses = const [
    YogaPose(
      sanskritName: 'Tadasana',
      englishName: 'Mountain Pose',
      benefits: 'Grounds postural alignment, strengthens pelvic stability.',
      precautions: 'Stand near a wall if experiencing dizziness or hot flashes.',
      defaultHoldSecs: 30,
    ),
    YogaPose(
      sanskritName: 'Vrikshasana (Wall Supported)',
      englishName: 'Tree Pose with Support',
      benefits: 'Crucial neuromuscular balance training to prevent midlife falls.',
      precautions: 'Place foot on calf or ankle; never directly press against the knee joint.',
      defaultHoldSecs: 25,
    ),
    YogaPose(
      sanskritName: 'Setu Bandhasana',
      englishName: 'Bridge Pose',
      benefits: 'Strengthens pelvic floor, gluteal chain, and supports thyroid circulation.',
      precautions: 'Avoid deep neck flexion if cervical stiffness is present.',
      defaultHoldSecs: 40,
    ),
    YogaPose(
      sanskritName: 'Bhujangasana (Gentle Cobra)',
      englishName: 'Gentle Cobra Pose',
      benefits: 'Opens thoracic cage, counteracts perimenopausal forward-slump posture.',
      precautions: 'Keep elbows softly bent; do not hyper-extend the lumbar spine.',
      defaultHoldSecs: 30,
    ),
    YogaPose(
      sanskritName: 'Viparita Karani',
      englishName: 'Legs-Up-The-Wall Pose',
      benefits: 'Venous drainage for tired, swollen legs; calms central nervous system.',
      precautions: 'Place a soft cushion under the hips for restorative comfort.',
      defaultHoldSecs: 60,
    ),
  ];

  int currentPoseIndex = 0;
  bool isPracticing = false;

  void _speakCue(String text) {
    VoiceService().speak(text, widget.language);
  }

  @override
  Widget build(BuildContext context) {
    final currentPose = poses[currentPoseIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movement & Gentle Yoga'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // PAR-Q Safety & Osteoporosis Notice
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NutriviaColors.snow,
              borderRadius: NutriviaShapes.organicCard,
              border: Border.all(color: NutriviaColors.lavenderMist),
            ),
            child: Row(
              children: const [
                Icon(Icons.health_and_safety_outlined, color: NutriviaColors.statusOk, size: 28),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'PAR-Q screened for knee comfort and bone mineral density. Deep forward spinal flexion and extreme twists are omitted to protect osteopenic vertebrae.',
                    style: TextStyle(fontSize: 13, color: NutriviaColors.nightPlum, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Pose Card with Custom Vector Figure Illustration
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: NutriviaColors.snow,
              borderRadius: NutriviaShapes.organicCard,
              border: Border.all(color: NutriviaColors.lavenderMist),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pose ${currentPoseIndex + 1} of ${poses.length}',
                      style: const TextStyle(color: NutriviaColors.stone, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded, color: NutriviaColors.marigold),
                      onPressed: () => _speakCue('${currentPose.sanskritName}, ${currentPose.englishName}. ${currentPose.benefits}'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Stylized Vector Pose Drawing
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _YogaPoseVectorPainter(poseIndex: currentPoseIndex),
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  currentPose.sanskritName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: NutriviaColors.plum),
                ),
                Text(
                  currentPose.englishName,
                  style: const TextStyle(color: NutriviaColors.terracotta, fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Text(
                  currentPose.benefits,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: NutriviaColors.nightPlum, height: 1.4),
                ),
                const SizedBox(height: 10),

                // Caution Box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: NutriviaColors.cream,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: NutriviaColors.peach),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined, color: NutriviaColors.terracotta, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          currentPose.precautions,
                          style: const TextStyle(fontSize: 12, color: NutriviaColors.nightPlum),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: currentPoseIndex > 0
                          ? () => setState(() => currentPoseIndex--)
                          : null,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(100, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Previous'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isPracticing = !isPracticing;
                        });
                        if (isPracticing) {
                          _speakCue('Hold ${currentPose.sanskritName}. Breathe gently.');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NutriviaColors.marigold,
                        minimumSize: const Size(110, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text(isPracticing ? 'Pause' : 'Start Hold'),
                    ),
                    OutlinedButton(
                      onPressed: currentPoseIndex < poses.length - 1
                          ? () => setState(() => currentPoseIndex++)
                          : null,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(100, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _YogaPoseVectorPainter extends CustomPainter {
  final int poseIndex;
  _YogaPoseVectorPainter({required this.poseIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    final linePaint = Paint()
      ..color = NutriviaColors.plum
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final headPaint = Paint()..color = NutriviaColors.marigold..style = PaintingStyle.fill;

    // Stylized botanical yoga silhouette based on pose
    if (poseIndex == 0) {
      // Tadasana: Straight standing pose
      canvas.drawCircle(Offset(center.dx, h * 0.22), 12, headPaint);
      canvas.drawLine(Offset(center.dx, h * 0.28), Offset(center.dx, h * 0.65), linePaint); // Spine
      canvas.drawLine(Offset(center.dx, h * 0.35), Offset(center.dx - 22, h * 0.55), linePaint); // Left arm
      canvas.drawLine(Offset(center.dx, h * 0.35), Offset(center.dx + 22, h * 0.55), linePaint); // Right arm
      canvas.drawLine(Offset(center.dx, h * 0.65), Offset(center.dx - 12, h * 0.95), linePaint); // Left leg
      canvas.drawLine(Offset(center.dx, h * 0.65), Offset(center.dx + 12, h * 0.95), linePaint); // Right leg
    } else if (poseIndex == 1) {
      // Vrikshasana: Tree pose
      canvas.drawCircle(Offset(center.dx, h * 0.20), 12, headPaint);
      canvas.drawLine(Offset(center.dx, h * 0.26), Offset(center.dx, h * 0.62), linePaint); // Spine
      // Namaste arms above
      canvas.drawLine(Offset(center.dx, h * 0.32), Offset(center.dx, h * 0.10), linePaint);
      canvas.drawLine(Offset(center.dx, h * 0.62), Offset(center.dx, h * 0.95), linePaint); // Standing leg
      // Bent leg folded at calf
      final bentLeg = Path();
      bentLeg.moveTo(center.dx, h * 0.62);
      bentLeg.lineTo(center.dx + 24, h * 0.72);
      bentLeg.lineTo(center.dx + 4, h * 0.78);
      canvas.drawPath(bentLeg, linePaint);
    } else {
      // Restorative reclining / gentle floor posture (Setu Bandhasana / Viparita Karani)
      canvas.drawCircle(Offset(w * 0.32, h * 0.70), 12, headPaint);
      final floorPath = Path();
      floorPath.moveTo(w * 0.32, h * 0.72);
      floorPath.quadraticBezierTo(w * 0.50, h * 0.35, w * 0.68, h * 0.85);
      canvas.drawPath(floorPath, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _YogaPoseVectorPainter oldDelegate) => oldDelegate.poseIndex != poseIndex;
}
