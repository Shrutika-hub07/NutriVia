import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';

class AnaemiaStep {
  final int stepNumber;
  final String title;
  final String subtitle;
  final String detail;
  final bool isCompleted;
  final bool isCurrent;

  const AnaemiaStep({
    required this.stepNumber,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.isCompleted,
    required this.isCurrent,
  });
}

class AnaemiaLoopScreen extends StatelessWidget {
  final String language;

  const AnaemiaLoopScreen({super.key, required this.language});

  final List<AnaemiaStep> steps = const [
    AnaemiaStep(
      stepNumber: 1,
      title: '1. Detect & Screen',
      subtitle: 'Identify fatigue, brittle nails, breathlessness',
      detail: 'Predictive score on Why Map flagged High Anaemia Risk based on symptoms and vegetarian diet.',
      isCompleted: true,
      isCurrent: false,
    ),
    AnaemiaStep(
      stepNumber: 2,
      title: '2. Clinical Blood Test',
      subtitle: 'Complete Blood Count (CBC) & Serum Ferritin',
      detail: 'Lab values confirmed: Hb 10.2 g/dL (Mild Anaemia), Ferritin 14 ng/mL (Low Iron Stores).',
      isCompleted: true,
      isCurrent: false,
    ),
    AnaemiaStep(
      stepNumber: 3,
      title: '3. Find the Cause',
      subtitle: 'Differentiate blood loss vs dietary absorption',
      detail: 'Primary contributors: Perimenopausal flooding cycles (+3) and habitual tea with meals (+2).',
      isCompleted: true,
      isCurrent: false,
    ),
    AnaemiaStep(
      stepNumber: 4,
      title: '4. Treat & Replenish',
      subtitle: 'Doctor\'s iron plan + Vitamin C pairing',
      detail: 'Ferrous Ascorbate tablet daily after lunch + Nachni bhakri with lemon juice pairing; 1-hr tea gap.',
      isCompleted: false,
      isCurrent: true,
    ),
    AnaemiaStep(
      stepNumber: 5,
      title: '5. Track Adherence & Vitality',
      subtitle: 'Monitor energy return and side-effects',
      detail: 'Currently at 85% adherence. Fatigue severity reduced from 8/10 to 5/10 over 5 weeks.',
      isCompleted: false,
      isCurrent: false,
    ),
    AnaemiaStep(
      stepNumber: 6,
      title: '6. Retest & Long-Term Shield',
      subtitle: 'Repeat CBC and Ferritin in 8-12 weeks',
      detail: 'Retest scheduled in 3 weeks to evaluate store replenishment and transition to food maintenance.',
      isCompleted: false,
      isCurrent: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anaemia Care Loop'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NutriviaColors.snow,
              borderRadius: NutriviaShapes.organicCard,
              border: Border.all(color: NutriviaColors.lavenderMist),
            ),
            child: Row(
              children: const [
                Icon(Icons.route_rounded, color: NutriviaColors.statusAlert, size: 28),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'The 6-step care loop closes the gap between feeling tired, discovering low ferritin, taking action with your doctor, and celebrating retest vitality.',
                    style: TextStyle(fontSize: 13, color: NutriviaColors.nightPlum, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Journey Path Visual
          ...steps.map((step) => _buildJourneyStep(step, isLast: step.stepNumber == steps.length)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildJourneyStep(AnaemiaStep step, {required bool isLast}) {
    Color nodeColor = NutriviaColors.stone;
    if (step.isCompleted) {
      nodeColor = NutriviaColors.statusOk;
    } else if (step.isCurrent) {
      nodeColor = NutriviaColors.marigold;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Line & Marker
          Column(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: step.isCurrent ? nodeColor : nodeColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: nodeColor, width: 2),
                ),
                child: Center(
                  child: step.isCompleted
                      ? const Icon(Icons.check, color: NutriviaColors.statusOk, size: 20)
                      : Text(
                          '${step.stepNumber}',
                          style: TextStyle(
                            color: step.isCurrent ? Colors.white : nodeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.5,
                    color: step.isCompleted ? NutriviaColors.statusOk : NutriviaColors.lavenderMist,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Step Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: step.isCurrent ? NutriviaColors.cream : NutriviaColors.snow,
                  borderRadius: NutriviaShapes.organicCard,
                  border: Border.all(
                    color: step.isCurrent ? NutriviaColors.peach : NutriviaColors.lavenderMist,
                    width: step.isCurrent ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          step.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: step.isCurrent ? NutriviaColors.plum : NutriviaColors.nightPlum,
                          ),
                        ),
                        if (step.isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: NutriviaColors.marigold,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Current Stage', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step.subtitle,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: NutriviaColors.terracotta),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      step.detail,
                      style: const TextStyle(fontSize: 13, color: NutriviaColors.nightPlum, height: 1.4),
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
