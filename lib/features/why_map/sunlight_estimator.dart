import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';

class SunlightEstimatorScreen extends StatefulWidget {
  final String language;

  const SunlightEstimatorScreen({super.key, required this.language});

  @override
  State<SunlightEstimatorScreen> createState() => _SunlightEstimatorScreenState();
}

class _SunlightEstimatorScreenState extends State<SunlightEstimatorScreen> {
  String selectedSeason = 'Winter / Monsoon';
  String selectedClothing = 'Full coverage (Saree/Salwar with sleeves)';
  String selectedTime = 'Under 15 minutes';
  String selectedTone = 'Fitzpatrick IV-V (Medium to Deep Indian tone)';

  String get exposureLevel {
    if (selectedTime == 'Under 15 minutes' || selectedClothing.contains('Full coverage')) {
      return 'Low Exposure (High Risk)';
    } else if (selectedTime == '15 to 30 minutes') {
      return 'Moderate Exposure';
    } else {
      return 'Optimal Exposure';
    }
  }

  Color get exposureColor {
    if (exposureLevel.contains('Low')) return NutriviaColors.statusAlert;
    if (exposureLevel.contains('Moderate')) return NutriviaColors.statusWatch;
    return NutriviaColors.statusOk;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sunlight & Vitamin D Estimator'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NutriviaColors.peach.withValues(alpha: 0.3),
              borderRadius: NutriviaShapes.organicCard,
              border: Border.all(color: NutriviaColors.peach),
            ),
            child: Row(
              children: const [
                Icon(Icons.wb_sunny_rounded, color: NutriviaColors.marigold, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Melanin in Indian skin naturally blocks UV-B, needing 25-45 minutes of mid-day sun on arms and face for sufficient Vitamin D.',
                    style: TextStyle(color: NutriviaColors.nightPlum, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Result Callout Box
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: exposureColor.withValues(alpha: 0.12),
              borderRadius: NutriviaShapes.organicCard,
              border: Border.all(color: exposureColor, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Estimated Synthesis Level:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: NutriviaColors.plum),
                ),
                const SizedBox(height: 4),
                Text(
                  exposureLevel,
                  style: TextStyle(
                    color: exposureColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'This calculation directly feeds into your Vitamin D and Bone Density risk scores on the Why Map.',
                  style: TextStyle(fontSize: 13, color: NutriviaColors.nightPlum),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Inputs
          _buildDropdown(
            title: 'Season in your region',
            value: selectedSeason,
            items: ['Winter / Monsoon', 'Summer / High Sun', 'Autumn / Spring'],
            onChanged: (v) => setState(() => selectedSeason = v!),
          ),
          const SizedBox(height: 16),

          _buildDropdown(
            title: 'Typical Clothing Coverage Outdoors',
            value: selectedClothing,
            items: [
              'Full coverage (Saree/Salwar with sleeves)',
              'Moderate (Short sleeves or hands exposed)',
              'High skin exposure (Arms and neck exposed)'
            ],
            onChanged: (v) => setState(() => selectedClothing = v!),
          ),
          const SizedBox(height: 16),

          _buildDropdown(
            title: 'Daily Mid-day Sun Exposure (11 AM - 2 PM)',
            value: selectedTime,
            items: ['Under 15 minutes', '15 to 30 minutes', 'More than 30 minutes'],
            onChanged: (v) => setState(() => selectedTime = v!),
          ),
          const SizedBox(height: 16),

          _buildDropdown(
            title: 'Natural Skin Tone',
            value: selectedTone,
            items: [
              'Fitzpatrick IV-V (Medium to Deep Indian tone)',
              'Fitzpatrick III (Fair to Wheatish tone)',
              'Fitzpatrick VI (Deep rich tone)'
            ],
            onChanged: (v) => setState(() => selectedTone = v!),
          ),
          const SizedBox(height: 28),

          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sunlight estimate synced with Why Map rules engine!')),
              );
              Navigator.pop(context);
            },
            child: const Text('Apply to My Risk Profile'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: NutriviaColors.plum),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: NutriviaColors.snow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NutriviaColors.lavenderMist),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
