import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';
import '../../core/services/rules_service.dart';
import 'differential_view.dart';
import 'sunlight_estimator.dart';

class WhyMapScreen extends StatelessWidget {
  final List<RiskScoreResult> riskResults;
  final String language;

  const WhyMapScreen({
    super.key,
    required this.riskResults,
    required this.language,
  });

  Color _getRiskColor(String level) {
    switch (level) {
      case 'high':
        return NutriviaColors.statusAlert;
      case 'medium':
        return NutriviaColors.statusWatch;
      case 'low':
      default:
        return NutriviaColors.statusOk;
    }
  }

  String _getRiskBadgeText(String level) {
    if (language == 'mr') {
      switch (level) {
        case 'high': return 'तातडीचे लक्ष हवे (High Attention)';
        case 'medium': return 'मध्यम लक्ष (Moderate Attention)';
        case 'low': default: return 'संतुलित (Balanced)';
      }
    } else if (language == 'hi') {
      switch (level) {
        case 'high': return 'विशेष ध्यान दें (High)';
        case 'medium': return 'मध्यम जोखिम (Moderate)';
        case 'low': default: return 'सामान्य (Low Risk)';
      }
    } else {
      switch (level) {
        case 'high': return 'High Attention Needed';
        case 'medium': return 'Moderate Attention';
        case 'low': default: return 'Balanced / Low Risk';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Why Map: Explainable Risk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.wb_sunny_outlined, color: NutriviaColors.marigold),
            tooltip: 'Sunlight Estimator',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SunlightEstimatorScreen(language: language)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.compare_arrows_rounded, color: NutriviaColors.plum),
            tooltip: 'Deficiency or Hormones?',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DeficiencyOrHormonesScreen(language: language)),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Explainability Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NutriviaColors.cream,
              borderRadius: NutriviaShapes.organicCard,
              border: Border.all(color: NutriviaColors.peach),
            ),
            child: Row(
              children: [
                const Icon(Icons.psychology_alt_outlined, color: NutriviaColors.terracotta, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Rules decide, AI explains. Every score shows exactly which reported factors contributed points.',
                    style: const TextStyle(
                      color: NutriviaColors.nightPlum,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quick Navigation to Signature Comparative Tool
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DeficiencyOrHormonesScreen(language: language)),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [NutriviaColors.deepPlum, NutriviaColors.plum],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.balance_rounded, color: Colors.white, size: 26),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Deficiency or Hormones?',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Compare fatigue, aches & brain fog with lab tests',
                          style: TextStyle(color: NutriviaColors.peach, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Risk Cards List
          ...riskResults.map((result) => _buildRiskCard(context, result)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRiskCard(BuildContext context, RiskScoreResult result) {
    final statusColor = _getRiskColor(result.level);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: const RoundedRectangleBorder(
        borderRadius: NutriviaShapes.organicCard,
        side: BorderSide(color: NutriviaColors.lavenderMist, width: 1.2),
      ),
      child: ExpansionTile(
        initiallyExpanded: result.level == 'high',
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: statusColor, width: 1.5),
          ),
          child: Center(
            child: Text(
              '${result.totalScore}p',
              style: TextStyle(color: statusColor, fontWeight: FontWeight.w800, fontSize: 13),
            ),
          ),
        ),
        title: Text(
          result.displayName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(
                _getRiskBadgeText(result.level),
                style: TextStyle(color: statusColor, fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ],
          ),
        ),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          const Divider(),

          // Why Midlife Context
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Why this matters in midlife:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: NutriviaColors.terracotta,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              result.whyMidlife,
              style: const TextStyle(fontSize: 14, color: NutriviaColors.nightPlum, height: 1.4),
            ),
          ),
          const SizedBox(height: 14),

          // Contributing Factors Breakdown
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Contributing Answers (${result.breakdown.length} triggers):',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: NutriviaColors.plum),
            ),
          ),
          const SizedBox(height: 6),
          ...result.breakdown.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.add_circle_outline, color: NutriviaColors.marigold, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    f.reason,
                    style: const TextStyle(fontSize: 13, color: NutriviaColors.nightPlum),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 14),

          // Tests to Discuss with Doctor
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: NutriviaColors.snow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: NutriviaColors.lavenderMist),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.biotech_outlined, color: NutriviaColors.plum, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Tests to discuss with your doctor:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: NutriviaColors.plum),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ...result.testsToDiscuss.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text('• $t', style: const TextStyle(fontSize: 13, color: NutriviaColors.nightPlum)),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
