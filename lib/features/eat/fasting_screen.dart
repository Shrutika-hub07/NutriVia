import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';
import '../../core/services/rules_service.dart';

class FastingScreen extends StatefulWidget {
  final String language;

  const FastingScreen({super.key, required this.language});

  @override
  State<FastingScreen> createState() => _FastingScreenState();
}

class _FastingScreenState extends State<FastingScreen> {
  final ClinicalRulesService _rulesService = ClinicalRulesService();

  @override
  Widget build(BuildContext context) {
    final fastingData = _rulesService.fastingRulesData;
    final festivals = (fastingData['festivals'] as List<dynamic>? ?? []);
    final contraindications = (fastingData['contraindications'] as List<dynamic>? ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fasting Companion'),
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
              children: [
                const Icon(Icons.shield_outlined, color: NutriviaColors.statusOk, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Honor spiritual fasting traditions with clinical safety: steady blood sugar, balanced electrolytes, and gentle break-fast protocols.',
                    style: const TextStyle(fontSize: 13, color: NutriviaColors.nightPlum, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Pre-Fast Clinical Safety Alerts
          const Text(
            'Clinical Pre-Fast Safety Rules:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
          ),
          const SizedBox(height: 10),
          ...contraindications.map((c) {
            final guidanceMap = c['guidance'] as Map<String, dynamic>? ?? {};
            final text = guidanceMap[widget.language] ?? guidanceMap['en'] ?? '';

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: NutriviaColors.statusWatch.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: NutriviaColors.statusWatch),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded, color: NutriviaColors.statusWatch, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 13, height: 1.4, color: NutriviaColors.nightPlum),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),

          // Fasting Plate Builder
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: NutriviaColors.cream,
              borderRadius: NutriviaShapes.organicCard,
              border: Border.all(color: NutriviaColors.peach, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fasting Plate Builder (Avoid the Sabudana Crash)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Build your plate for steady stamina and muscle sparing:',
                  style: TextStyle(fontSize: 13, color: NutriviaColors.stone),
                ),
                const SizedBox(height: 14),
                _buildPlateRow('Steady Energy', 'Rajgira Thalipeeth, Boiled Sweet Potato, Vari (Bhagar) Rice', NutriviaColors.statusOk),
                _buildPlateRow('Protein Power', 'Roasted Peanuts (Shengdana), Curd, Roasted Makhana, Paneer', NutriviaColors.marigold),
                _buildPlateRow('Hydration', 'Spiced Buttermilk with rock salt, Fresh Coconut Water', NutriviaColors.plum),
                _buildPlateRow('Go Easy On', 'Excessive deep-fried Sabudana Vada, potato wafers, heavy sugar syrups', NutriviaColors.statusAlert),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Gentle Break-Fast Guide
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NutriviaColors.paper,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: NutriviaColors.lavenderMist),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.restaurant, color: NutriviaColors.plum, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Gentle Break-Fast Protocol:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: NutriviaColors.plum),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.language == 'mr'
                      ? 'उपवास सोडताना: सुरुवातीला एक ग्लास कोमट पाणी किंवा शहाळ्याचे पाणी व खजूर घ्या. एकदम तळलेले किंवा जड अन्न खाल्ल्यास पित्त व रक्तातील साखर वेगाने वाढू शकते.'
                      : 'Break your fast gently: Start with warm water or coconut water and 1-2 soaked dates. Avoid diving straight into heavy fried food to prevent sudden gastric distress and blood sugar spikes.',
                  style: const TextStyle(fontSize: 13, height: 1.4, color: NutriviaColors.nightPlum),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Festival Fast Calendar
          const Text(
            'Festival Fast Tradition Reference:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
          ),
          const SizedBox(height: 10),
          ...festivals.map((f) {
            final names = f['name'] as Map<String, dynamic>? ?? {};
            final name = names[widget.language] ?? names['en'] ?? '';
            final foods = (f['tradition_foods'] as List<dynamic>? ?? []).join(', ');

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: NutriviaColors.plum)),
                subtitle: Text('Traditional Nourishment: $foods', style: const TextStyle(fontSize: 12, color: NutriviaColors.stone)),
                leading: const Icon(Icons.wb_sunny_outlined, color: NutriviaColors.marigold),
              ),
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPlateRow(String category, String items, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
          const SizedBox(height: 2),
          Text(items, style: const TextStyle(fontSize: 13, color: NutriviaColors.nightPlum)),
        ],
      ),
    );
  }
}
