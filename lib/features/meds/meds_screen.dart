import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';
import '../../core/services/rules_service.dart';
import '../../core/providers/app_state_provider.dart';
import 'effectiveness_ribbon.dart';
import '../medical_history/medical_history_screen.dart';

class MedsScreen extends StatelessWidget {
  final AppState state;
  final String language;

  const MedsScreen({super.key, required this.state, required this.language});

  @override
  Widget build(BuildContext context) {
    final rules = ClinicalRulesService();
    final interactions = (rules.interactionsData['interactions'] as List<dynamic>? ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text(language == 'mr'
            ? 'औषधे व वैद्यकीय तिजोरी'
            : (language == 'hi' ? 'दवाएं व स्वास्थ्य तिजोरी' : 'Medicine Vault & Response')),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: NutriviaColors.plum),
            tooltip: 'Add Medicine or Lab Report',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MedicalHistoryScreen(language: language)),
              );
            },
          ),
        ],
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
                Icon(Icons.verified_outlined, color: NutriviaColors.statusOk, size: 28),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Track medicine response over time and review drug-nutrient timing. Nutrivia never recommends altering doses without doctor consultation.',
                    style: TextStyle(fontSize: 13, color: NutriviaColors.nightPlum, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Medicine Effectiveness Ribbons Section
          const Text(
            'Medicine Effectiveness & Symptom Trends:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
          ),
          const SizedBox(height: 12),
          ...state.medicines.map((med) => Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: MedicineEffectivenessRibbon(
              medicineName: med.name,
              targetProblem: med.targetProblem,
              severityBefore: med.severityBefore,
              severityAfter: med.severityAfter,
              adherencePercent: med.adherencePercent,
              notes: med.notes,
            ),
          )),
          const SizedBox(height: 16),

          // Medicine-Nutrient & Supplement Safety Check Section
          const Text(
            'Medicine-Nutrient Safety Warnings:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
          ),
          const SizedBox(height: 10),
          ...interactions.map((inter) {
            final guidanceObj = inter['guidance'] as Map<String, dynamic>? ?? {};
            final guidanceText = guidanceObj[language] ?? guidanceObj['en'] ?? '';

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: NutriviaColors.cream,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: NutriviaColors.peach),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_rounded, color: NutriviaColors.terracotta, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Interaction: ${inter['affected_nutrient']}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: NutriviaColors.terracotta),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          guidanceText,
                          style: const TextStyle(fontSize: 13, color: NutriviaColors.nightPlum, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),

          // Lab Report Trend Vault
          const Text(
            'Verified Lab Values (Confirmed with Doctor):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NutriviaColors.snow,
              borderRadius: NutriviaShapes.organicCard,
              border: Border.all(color: NutriviaColors.lavenderMist),
            ),
            child: Column(
              children: state.labs.map((lab) {
                final isLow = lab.status == 'low';
                final color = isLow ? NutriviaColors.statusAlert : NutriviaColors.statusOk;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lab.testName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: NutriviaColors.plum),
                          ),
                          Text(
                            'Tested 6 weeks ago',
                            style: const TextStyle(fontSize: 12, color: NutriviaColors.stone),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: color),
                        ),
                        child: Text(
                          '${lab.value} ${lab.unit} (${lab.status.toUpperCase()})',
                          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showAddMedicineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: NutriviaShapes.organicCard),
          title: const Text('Add Medicine or Lab Report', style: TextStyle(color: NutriviaColors.plum, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.document_scanner_outlined, color: NutriviaColors.marigold),
                title: const Text('Scan Prescription / Strip (OCR)'),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Simulated OCR: Parsed "Calcium Carbonate 500mg" and verified!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.mic_outlined, color: NutriviaColors.plum),
                title: const Text('Speak Medicine by Voice'),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Voice logged: "Thyronorm 50mcg in morning"')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_note_outlined, color: NutriviaColors.statusOk),
                title: const Text('Type Manually'),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }
}
