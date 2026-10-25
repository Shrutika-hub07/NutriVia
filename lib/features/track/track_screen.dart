import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';
import '../../core/providers/app_state_provider.dart';
import 'body_map_widget.dart';
import 'symptom_constellation.dart';
import 'anaemia_loop_screen.dart';
import 'checkin_screen.dart';
import '../medical_history/medical_history_screen.dart';

class TrackScreen extends StatefulWidget {
  final AppState state;
  final String language;
  final VoidCallback onCheckinDone;

  const TrackScreen({
    super.key,
    required this.state,
    required this.language,
    required this.onCheckinDone,
  });

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  BodyPartTarget? selectedPart;
  double severity = 7.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.language == 'mr'
            ? 'लक्षणे व वैद्यकीय नोंदी'
            : (widget.language == 'hi' ? 'लक्षण व मेडिकल रिकॉर्ड्स' : 'Symptom Tracker & Records')),
        actions: [
          IconButton(
            icon: const Icon(Icons.note_add_outlined, color: NutriviaColors.marigold),
            tooltip: 'Enter Medical Records & History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MedicalHistoryScreen(language: widget.language)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.route_outlined, color: NutriviaColors.plum),
            tooltip: 'Anaemia Care Loop',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AnaemiaLoopScreen(language: widget.language)),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Daily Check-in CTA Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [NutriviaColors.plum, NutriviaColors.deepPlum],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_florist, color: NutriviaColors.marigold, size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Day ${widget.state.streakDays} Check-in',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Text(
                        'Under 90 seconds to log sleep & mood',
                        style: TextStyle(color: NutriviaColors.peach, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DailyCheckinScreen(
                          language: widget.language,
                          onSaved: widget.onCheckinDone,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NutriviaColors.marigold,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(80, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  child: const Text('Check-in'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // SECTION 1: INTERACTIVE BODY MAP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '1-Tap Body Map (Where is it hurting?):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap any botanical node on front or back body to record symptoms:',
            style: TextStyle(fontSize: 13, color: NutriviaColors.stone),
          ),
          const SizedBox(height: 14),

          BodyMapWidget(
            activeSymptoms: widget.state.profile.symptoms,
            onSelectPart: (part) {
              setState(() {
                selectedPart = part;
              });
            },
          ),
          const SizedBox(height: 16),

          // Selected Body Part Symptom Logger
          if (selectedPart != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NutriviaColors.cream,
                borderRadius: NutriviaShapes.organicCard,
                border: Border.all(color: NutriviaColors.peach, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Area: ${selectedPart!.label}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: NutriviaColors.plum),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Severity: ${severity.toInt()}/10',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: NutriviaColors.terracotta, fontSize: 14),
                  ),
                  Slider(
                    value: severity,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    activeColor: NutriviaColors.plum,
                    onChanged: (v) => setState(() => severity = v),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectedPart!.commonSymptoms.map((sym) {
                      return Chip(
                        label: Text(sym.replaceAll('_', ' ')),
                        backgroundColor: NutriviaColors.snow,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logged ${selectedPart!.label} symptom with severity ${severity.toInt()}/10!')),
                      );
                      setState(() => selectedPart = null);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NutriviaColors.plum,
                      minimumSize: const Size(double.infinity, 44),
                    ),
                    child: const Text('Save Symptom Record'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // SECTION 2: SYMPTOM CONSTELLATION & CORRELATIONS
          const Text(
            'Symptom Constellation & Observed Correlations:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
          ),
          const SizedBox(height: 4),
          const Text(
            'Derived from 6 weeks of seeded check-in logs. Tap stars to explore relationships:',
            style: TextStyle(fontSize: 13, color: NutriviaColors.stone),
          ),
          const SizedBox(height: 12),

          SymptomConstellationWidget(language: widget.language),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
