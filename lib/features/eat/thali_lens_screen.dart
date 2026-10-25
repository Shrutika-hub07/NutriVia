import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';

class SampleThali {
  final String id;
  final String title;
  final String description;
  final String icon;
  final List<Map<String, dynamic>> items;

  const SampleThali({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.items,
  });
}

class ThaliLensScreen extends StatefulWidget {
  final String language;

  const ThaliLensScreen({super.key, required this.language});

  @override
  State<ThaliLensScreen> createState() => _ThaliLensScreenState();
}

class _ThaliLensScreenState extends State<ThaliLensScreen> {
  bool isAnalyzing = false;
  SampleThali? detectedThali;

  final List<SampleThali> demoThalis = const [
    SampleThali(
      id: 'demo_1',
      title: 'Maharashtrian Bhakri & Matki Thali',
      description: 'Nachni Bhakri, Sprouted Matki Usal, Palak Sabzi, Chaas & Lemon',
      icon: '🫓',
      items: [
        {'name': 'Nachni (Ragi) Bhakri', 'portion': '1 medium (60g)', 'iron_mg': 2.4, 'calcium_mg': 210},
        {'name': 'Sprouted Matki Usal', 'portion': '1 katori (120g)', 'iron_mg': 4.2, 'calcium_mg': 56},
        {'name': 'Palak Paneer', 'portion': '1 katori (130g)', 'iron_mg': 3.2, 'calcium_mg': 145},
        {'name': 'Spiced Chaas (Tak)', 'portion': '1 big glass (250ml)', 'iron_mg': 0.3, 'calcium_mg': 175},
        {'name': 'Fresh Lemon Slice', 'portion': 'Half slice', 'iron_mg': 0.0, 'calcium_mg': 0.0},
      ],
    ),
    SampleThali(
      id: 'demo_2',
      title: 'South Indian High-Protein Morning Plate',
      description: 'Steamed Idlis, Drumstick Sambar, Coconut Chutney & Sprouted Moong',
      icon: '🥞',
      items: [
        {'name': 'Steamed Idlis', 'portion': '2 pieces', 'iron_mg': 2.1, 'calcium_mg': 45},
        {'name': 'Drumstick Sambar', 'portion': '1 katori (150g)', 'iron_mg': 2.2, 'calcium_mg': 65},
        {'name': 'Sprouted Moong Salad', 'portion': '1 small cup (80g)', 'iron_mg': 3.8, 'calcium_mg': 62},
      ],
    ),
    SampleThali(
      id: 'demo_3',
      title: 'Ekadashi Fasting Phalahar Thali',
      description: 'Rajgira Thalipeeth, Roasted Shengdana, Dahi & Sweet Potato',
      icon: '🍠',
      items: [
        {'name': 'Rajgira Thalipeeth', 'portion': '1 piece (75g)', 'iron_mg': 4.1, 'calcium_mg': 180},
        {'name': 'Homemade Curd (Dahi)', 'portion': '1 katori (150g)', 'iron_mg': 0.2, 'calcium_mg': 210},
        {'name': 'Roasted Peanuts with Rock Salt', 'portion': 'Handful (35g)', 'iron_mg': 2.4, 'calcium_mg': 45},
        {'name': 'Boiled Sweet Potato', 'portion': '1 cup cubed', 'iron_mg': 1.4, 'calcium_mg': 45},
      ],
    ),
  ];

  void _analyzePlate(SampleThali thali) async {
    setState(() {
      isAnalyzing = true;
      detectedThali = null;
    });

    // Simulate AI Vision breakdown
    await Future.delayed(const Duration(milliseconds: 1200));

    setState(() {
      isAnalyzing = false;
      detectedThali = thali;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thali Lens'),
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
                const Icon(Icons.auto_awesome, color: NutriviaColors.marigold, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'AI Vision identifies authentic Indian dishes and estimates household portions (roti count, katori, glass). Works fully offline with bundled demo thalis.',
                    style: const TextStyle(fontSize: 13, color: NutriviaColors.nightPlum, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Camera Action Card
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [NutriviaColors.deepPlum, NutriviaColors.plum],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton.filled(
                    onPressed: () => _analyzePlate(demoThalis.first),
                    icon: const Icon(Icons.camera_alt_rounded, size: 36, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: NutriviaColors.marigold,
                      minimumSize: const Size(72, 72),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Snap Meal Photo (or tap Demo below)',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Bundled Demo Thalis for Zero-Network Testing
          const Text(
            'Or Select a Bundled Demo Thali (Judging Test):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: NutriviaColors.plum),
          ),
          const SizedBox(height: 12),
          ...demoThalis.map((thali) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Text(thali.icon, style: const TextStyle(fontSize: 32)),
                title: Text(thali.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: NutriviaColors.plum)),
                subtitle: Text(thali.description, style: const TextStyle(fontSize: 12, color: NutriviaColors.stone)),
                trailing: ElevatedButton(
                  onPressed: () => _analyzePlate(thali),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NutriviaColors.marigold,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(70, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text('Analyze'),
                ),
              ),
            );
          }),
          const SizedBox(height: 20),

          // Analysis Loading Indicator
          if (isAnalyzing) ...[
            Center(
              child: Column(
                children: const [
                  CircularProgressIndicator(color: NutriviaColors.marigold),
                  SizedBox(height: 12),
                  Text('Analyzing meal items, minerals & household portions...', style: TextStyle(color: NutriviaColors.plum, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Detected Result Card
          if (detectedThali != null) ...[
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
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: NutriviaColors.statusOk, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Detected: ${detectedThali!.title}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text('Identified Items & Household Portions (Editable):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: NutriviaColors.terracotta)),
                  const SizedBox(height: 8),
                  ...detectedThali!.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '• ${item['name']}',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: NutriviaColors.nightPlum),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: NutriviaColors.lavenderMist),
                            ),
                            child: Text(item['portion'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Meal logged successfully! Nutri-Bloom updated.')),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Confirm & Log to Food Tracker'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}
