import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';

class DailyCheckinScreen extends StatefulWidget {
  final String language;
  final VoidCallback onSaved;

  const DailyCheckinScreen({super.key, required this.language, required this.onSaved});

  @override
  State<DailyCheckinScreen> createState() => _DailyCheckinScreenState();
}

class _DailyCheckinScreenState extends State<DailyCheckinScreen> {
  double sleepHours = 7.0;
  int selectedMoodFace = 3; // 1-5 face scale
  final List<String> selectedSymptoms = ['fatigue'];
  int waterGlasses = 6;
  bool medsTaken = true;

  final List<Map<String, dynamic>> moodFaces = [
    {'score': 1, 'emoji': '😢', 'label': 'Down'},
    {'score': 2, 'emoji': '😟', 'label': 'Anxious'},
    {'score': 3, 'emoji': '😐', 'label': 'Neutral'},
    {'score': 4, 'emoji': '🙂', 'label': 'Peaceful'},
    {'score': 5, 'emoji': '🌸', 'label': 'Vital'},
  ];

  final List<String> quickSymptomOptions = [
    'Fatigue / Exhaustion',
    'Leg Pain / Cramps',
    'Knee Stiffness',
    'Hot Flash / Night Sweat',
    'Pins & Needles',
    'Headache',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Check-in (< 90s)'),
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
                Icon(Icons.local_florist, color: NutriviaColors.marigold, size: 28),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Quick check-in adds a blossom to your garland. Never guilt, only awareness.',
                    style: TextStyle(fontSize: 13, color: NutriviaColors.nightPlum, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 1. Sleep Hours
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Last Night Sleep:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: NutriviaColors.plum)),
                      Text('${sleepHours.toStringAsFixed(1)} hours', style: const TextStyle(fontWeight: FontWeight.bold, color: NutriviaColors.marigold, fontSize: 16)),
                    ],
                  ),
                  Slider(
                    value: sleepHours,
                    min: 3.0,
                    max: 11.0,
                    divisions: 16,
                    activeColor: NutriviaColors.plum,
                    inactiveColor: NutriviaColors.lavenderMist,
                    onChanged: (v) => setState(() => sleepHours = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 2. 5-Face Mood Slider
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('How are you feeling today?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: NutriviaColors.plum)),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: moodFaces.map((f) {
                      final isSelected = f['score'] == selectedMoodFace;
                      return GestureDetector(
                        onTap: () => setState(() => selectedMoodFace = f['score']),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected ? NutriviaColors.marigold.withValues(alpha: 0.15) : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? NutriviaColors.marigold : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(f['emoji'], style: const TextStyle(fontSize: 32)),
                              const SizedBox(height: 4),
                              Text(
                                f['label'],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? NutriviaColors.marigold : NutriviaColors.stone,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 3. Symptoms Today
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Any noticeable symptoms today?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: NutriviaColors.plum)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: quickSymptomOptions.map((sym) {
                      final isSelected = selectedSymptoms.contains(sym);
                      return FilterChip(
                        label: Text(sym),
                        selected: isSelected,
                        onSelected: (v) {
                          setState(() {
                            if (v) {
                              selectedSymptoms.add(sym);
                            } else {
                              selectedSymptoms.remove(sym);
                            }
                          });
                        },
                        selectedColor: NutriviaColors.marigold,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : NutriviaColors.nightPlum,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 4. Hydration & Meds Taken
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Water / Chaas glasses:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: NutriviaColors.plum)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: NutriviaColors.plum),
                            onPressed: waterGlasses > 0 ? () => setState(() => waterGlasses--) : null,
                          ),
                          Text('$waterGlasses', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: NutriviaColors.plum),
                            onPressed: () => setState(() => waterGlasses++),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Prescribed Medicines Taken Today', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: NutriviaColors.plum)),
                    subtitle: const Text('Iron, Vitamin D, or regular tablets', style: TextStyle(fontSize: 12)),
                    value: medsTaken,
                    activeThumbColor: NutriviaColors.statusOk,
                    onChanged: (v) => setState(() => medsTaken = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {
              widget.onSaved();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Daily check-in saved! A new petal blooms on your garland.')),
              );
              Navigator.pop(context);
            },
            child: const Text('Confirm & Add to Garland'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
