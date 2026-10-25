import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';

class OverlapItem {
  final String symptom;
  final String deficiencyPerspective;
  final String hormonePerspective;
  final String distinguishingTest;

  const OverlapItem({
    required this.symptom,
    required this.deficiencyPerspective,
    required this.hormonePerspective,
    required this.distinguishingTest,
  });
}

class DeficiencyOrHormonesScreen extends StatelessWidget {
  final String language;

  const DeficiencyOrHormonesScreen({super.key, required this.language});

  final List<OverlapItem> overlaps = const [
    OverlapItem(
      symptom: 'Persistent Fatigue & Weakness',
      deficiencyPerspective: 'Low Iron/Ferritin (anaemia), low B12, or low Vitamin D deplete cellular ATP and oxygen delivery.',
      hormonePerspective: 'Fluctuating progesterone and dropping estrogen disrupt sleep architecture and energy metabolism.',
      distinguishingTest: 'CBC with Ferritin, Serum B12, 25-OH Vitamin D',
    ),
    OverlapItem(
      symptom: 'Pins, Needles & Tingling',
      deficiencyPerspective: 'Vitamin B12 deficiency leads to peripheral nerve demyelination and burning soles at night.',
      hormonePerspective: 'Estrogen drop causes temporary microvascular constriction, but rarely symmetrical numbness.',
      distinguishingTest: 'Serum Vitamin B12, Homocysteine, Fasting Blood Sugar',
    ),
    OverlapItem(
      symptom: 'Brain Fog & Memory Lapses',
      deficiencyPerspective: 'B12 deficiency or low Ferritin impairs neurotransmitter synthesis and cerebral oxygenation.',
      hormonePerspective: 'Estrogen receptors in the hippocampus regulate recall; erratic levels cause short-term forgetfulness.',
      distinguishingTest: 'TSH (Thyroid), Serum B12, Ferritin',
    ),
    OverlapItem(
      symptom: 'Deep Bone & Joint Aches',
      deficiencyPerspective: 'Severe Vitamin D deficiency (<20 ng/mL) causes osteomalacia (tender shin and pelvic bones).',
      hormonePerspective: 'Estrogen loss decreases joint lubrication and increases pro-inflammatory cytokines.',
      distinguishingTest: '25-OH Vitamin D, Serum Calcium, DEXA Scan',
    ),
    OverlapItem(
      symptom: 'Low Mood & Anxiety Waves',
      deficiencyPerspective: 'Magnesium and Vitamin D deficits lower serotonin and dopamine receptor sensitivity.',
      hormonePerspective: 'Abrupt estrogen dips trigger acute sympathetic nervous system flares and heart fluttering.',
      distinguishingTest: 'Serum Magnesium, Thyroid (TSH, FT4)',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deficiency or Hormones?'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NutriviaColors.peach.withValues(alpha: 0.35),
              borderRadius: NutriviaShapes.organicCard,
              border: Border.all(color: NutriviaColors.peach),
            ),
            child: const Text(
              'Symptoms like fatigue and brain fog can feel identical. While perimenopause is a natural transition, treating underlying nutrient gaps often brings immediate relief. Simple blood tests tell them apart.',
              style: TextStyle(
                color: NutriviaColors.nightPlum,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 20),

          ...overlaps.map((item) => _buildOverlapCard(context, item)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOverlapCard(BuildContext context, OverlapItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.compare_arrows_rounded, color: NutriviaColors.plum, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.symptom,
                    style: const TextStyle(
                      color: NutriviaColors.plum,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Two-column side-by-side comparison
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: NutriviaColors.cream,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'If Nutritional Gap:',
                          style: TextStyle(
                            color: NutriviaColors.terracotta,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.deficiencyPerspective,
                          style: const TextStyle(fontSize: 13, height: 1.4, color: NutriviaColors.nightPlum),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: NutriviaColors.snow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: NutriviaColors.lavenderMist),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'If Hormonal Transition:',
                          style: TextStyle(
                            color: NutriviaColors.plum,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.hormonePerspective,
                          style: const TextStyle(fontSize: 13, height: 1.4, color: NutriviaColors.nightPlum),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tests that tell them apart
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: NutriviaColors.paper,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: NutriviaColors.lavenderMist),
              ),
              child: Row(
                children: [
                  const Icon(Icons.biotech_rounded, color: NutriviaColors.statusOk, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: NutriviaColors.nightPlum, fontSize: 13),
                        children: [
                          const TextSpan(
                            text: 'Tests that clarify: ',
                            style: TextStyle(fontWeight: FontWeight.bold, color: NutriviaColors.plum),
                          ),
                          TextSpan(text: item.distinguishingTest),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
