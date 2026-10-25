import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';
import '../../core/providers/app_state_provider.dart';

class MenopauseScreen extends StatelessWidget {
  final AppState state;
  final String language;

  const MenopauseScreen({super.key, required this.state, required this.language});

  @override
  Widget build(BuildContext context) {
    final stageName = state.strawStage['name'] ?? 'Late Perimenopause';
    final stageDesc = state.strawStage['description'] ?? 'Marked menstrual irregularity with gaps of 60 days or more between cycles.';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menopause & Cycle Journey'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // STRAW+10 Estimator Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [NutriviaColors.plum, NutriviaColors.deepPlum],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: NutriviaColors.marigold,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'STRAW+10 Framework',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                    const Text('Wide Uncertainty Range', style: TextStyle(color: NutriviaColors.peach, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  stageName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 6),
                Text(
                  stageDesc,
                  style: const TextStyle(color: NutriviaColors.peach, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Last period was ~${state.profile.monthsSinceLastPeriod} months ago. Menopause is officially confirmed after 12 full consecutive months.',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Red Flag Gynaecological Alerts
          const Text(
            'Important Clinical Gynaecologist Prompts:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
          ),
          const SizedBox(height: 10),
          _buildAlertPrompt(
            'Bleeding After Menopause',
            'Any vaginal bleeding after 12 months without periods is NOT a renewed cycle and requires immediate ultrasound evaluation by a gynaecologist.',
            NutriviaColors.statusAlert,
          ),
          _buildAlertPrompt(
            'Rapid Cycles (<21 Days)',
            'Bleeding episodes occurring closer than 3 weeks apart cause rapid iron depletion and warrant a gynaecological consult.',
            NutriviaColors.statusWatch,
          ),
          _buildAlertPrompt(
            'Heavy Flooding Flow',
            'Soaking through a pad or tampon every 1-2 hours or large clots indicates menorrhagia; report this at your next visit.',
            NutriviaColors.statusAlert,
          ),
          const SizedBox(height: 20),

          // Original Non-Ring Horizontal Cycle Timeline Visual
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: NutriviaColors.snow,
              borderRadius: NutriviaShapes.organicCard,
              border: Border.all(color: NutriviaColors.lavenderMist),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent 6 Months Cycle Spacing (Original Ribbon View):',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: NutriviaColors.plum),
                ),
                const SizedBox(height: 14),
                _buildTimelineBar('May (LMP)', 'Heavy flow 5 days (Flooding)', NutriviaColors.statusAlert),
                _buildTimelineBar('June', 'No period (42 days gap)', NutriviaColors.lavenderMist),
                _buildTimelineBar('July', 'No period (70 days gap)', NutriviaColors.lavenderMist),
                _buildTimelineBar('August', 'Spotting 1 day', NutriviaColors.statusWatch),
                _buildTimelineBar('September', 'No period (Gap continues)', NutriviaColors.lavenderMist),
                _buildTimelineBar('October (Current)', 'Month 8 of transition milestone', NutriviaColors.marigold),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAlertPrompt(String title, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 13, height: 1.4, color: NutriviaColors.nightPlum)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineBar(String month, String note, Color barColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(month, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: NutriviaColors.plum)),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: barColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(note, style: const TextStyle(fontSize: 12, color: NutriviaColors.nightPlum)),
          ),
        ],
      ),
    );
  }
}
