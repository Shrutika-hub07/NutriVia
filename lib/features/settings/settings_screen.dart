import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/tokens.dart';
import '../../core/providers/app_state_provider.dart';
import '../family_asha/caregiver_screen.dart';
import '../family_asha/asha_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final notifier = ref.read(appStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Privacy'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // DEMO MODE JUDGING BOX
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: NutriviaColors.cream,
              borderRadius: NutriviaShapes.organicCard,
              border: Border.all(color: NutriviaColors.marigold, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.workspace_premium_rounded, color: NutriviaColors.marigold, size: 26),
                        SizedBox(width: 8),
                        Text(
                          'Hackathon Demo Personas',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
                        ),
                      ],
                    ),
                    Text('Judging Mode', style: TextStyle(color: NutriviaColors.terracotta, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Switch between seeded patient journeys. All seeded records bear the visible "Sample data" badge:',
                  style: TextStyle(fontSize: 13, color: NutriviaColors.nightPlum),
                ),
                const SizedBox(height: 14),

                // Persona buttons
                ElevatedButton(
                  onPressed: () {
                    notifier.loadPersona('sunita');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Loaded Sunita (52, Marathi, 6-Wk Seeded History)')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.persona == 'sunita' ? NutriviaColors.plum : NutriviaColors.snow,
                    foregroundColor: state.persona == 'sunita' ? Colors.white : NutriviaColors.plum,
                    side: const BorderSide(color: NutriviaColors.plum),
                  ),
                  child: const Text('Persona 1: Sunita (52, Marathi, High Anaemia/Vit D Risk)'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    notifier.loadPersona('meera');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Loaded Meera (44, English/Hindi, Urban Perimenopause)')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.persona == 'meera' ? NutriviaColors.plum : NutriviaColors.snow,
                    foregroundColor: state.persona == 'meera' ? Colors.white : NutriviaColors.plum,
                    side: const BorderSide(color: NutriviaColors.plum),
                  ),
                  child: const Text('Persona 2: Meera (44, Hindi/Eng, Early Perimenopause)'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    notifier.loadPersona('fresh');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cleared data: Start fresh profile')),
                    );
                  },
                  child: const Text('Start Fresh (Blank Canvas)'),
                ),
                const SizedBox(height: 12),

                // 8-Step Demo Script Guide for Judges
                InkWell(
                  onTap: () => _showDemoScriptDialog(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.menu_book_rounded, color: NutriviaColors.plum, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'View 8-Step Judging Flow Script',
                        style: TextStyle(fontWeight: FontWeight.bold, color: NutriviaColors.plum, fontSize: 13, decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // LANGUAGE SWITCHER
          const Text('Language / भाषा निवडा:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: NutriviaColors.plum)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildLangChip('मराठी (mr)', 'mr', state.language, notifier),
              const SizedBox(width: 8),
              _buildLangChip('हिंदी (hi)', 'hi', state.language, notifier),
              const SizedBox(width: 8),
              _buildLangChip('English (en)', 'en', state.language, notifier),
            ],
          ),
          const SizedBox(height: 20),

          // ACCESSIBILITY & TEXT SCALE
          const Text('Reading Accessibility & Text Size:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: NutriviaColors.plum)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildScaleChip('100%', 1.0, state.textScale, notifier),
              const SizedBox(width: 8),
              _buildScaleChip('125%', 1.25, state.textScale, notifier),
              const SizedBox(width: 8),
              _buildScaleChip('150%', 1.5, state.textScale, notifier),
            ],
          ),
          const SizedBox(height: 20),

          // PRIVACY & DPDP ACT 2023
          const Text('Privacy, DPDP Act 2023 & Security:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: NutriviaColors.plum)),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Discreet / Private Mode (Locker)', style: TextStyle(fontSize: 14)),
            subtitle: const Text('Hides menopause keywords in system notifications', style: TextStyle(fontSize: 12)),
            value: state.isPrivateMode,
            activeThumbColor: NutriviaColors.plum,
            onChanged: (v) => notifier.togglePrivateMode(),
          ),
          ListTile(
            leading: const Icon(Icons.family_restroom, color: NutriviaColors.plum),
            title: const Text('Caregiver Sharing Permissions'),
            subtitle: const Text('Manage revocable read-only QR code', style: TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => CaregiverShareScreen(state: state)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.volunteer_activism, color: NutriviaColors.marigold),
            title: const Text('ASHA Worker Assisted Mode'),
            subtitle: const Text('3-minute rapid rural health screening tool', style: TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AshaScreen(language: state.language)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: NutriviaColors.statusAlert),
            title: const Text('Erase All My Data (Right to be Forgotten)', style: TextStyle(color: NutriviaColors.statusAlert)),
            subtitle: const Text('DPDP 2023 compliant local SQLite/state purging', style: TextStyle(fontSize: 12)),
            onTap: () {
              notifier.loadPersona('fresh');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All local health logs erased permanently.')),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLangChip(String label, String code, String current, AppStateNotifier notifier) {
    final isSelected = current == code;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (v) => notifier.setLanguage(code),
      selectedColor: NutriviaColors.marigold,
      labelStyle: TextStyle(color: isSelected ? Colors.white : NutriviaColors.plum, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildScaleChip(String label, double scale, double current, AppStateNotifier notifier) {
    final isSelected = (current - scale).abs() < 0.05;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (v) => notifier.setTextScale(scale),
      selectedColor: NutriviaColors.plum,
      labelStyle: TextStyle(color: isSelected ? Colors.white : NutriviaColors.plum, fontWeight: FontWeight.bold),
    );
  }

  void _showDemoScriptDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: NutriviaShapes.organicCard),
          title: const Text('8-Step Judging Flow Script', style: TextStyle(color: NutriviaColors.plum, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('1. Switch language to Marathi (मराठी) or Hindi.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                SizedBox(height: 6),
                Text('2. Observe Persona Sunita with 6 weeks of seeded logs and "Sample data" badges.', style: TextStyle(fontSize: 13)),
                SizedBox(height: 6),
                Text('3. Tap Nutri-Bloom on Home: Tap Iron petal to see gap, ragi/nachni regional food advice.', style: TextStyle(fontSize: 13)),
                SizedBox(height: 6),
                Text('4. Tap Why Map: Inspect explainable risk factor breakdown ("Vegetarian +2, Tea with meals +2").', style: TextStyle(fontSize: 13)),
                SizedBox(height: 6),
                Text('5. Tap "Deficiency or Hormones?" view to see side-by-side clinical comparisons.', style: TextStyle(fontSize: 13)),
                SizedBox(height: 6),
                Text('6. Enter Calm Space: Run a Sheetali / Anulom Vilom breathing cycle with animated blooming circle.', style: TextStyle(fontSize: 13)),
                SizedBox(height: 6),
                Text('7. Tap Meds: Inspect flowing Before/After Ribbon (bone pain down from 7 to 4 on Vit D).', style: TextStyle(fontSize: 13)),
                SizedBox(height: 6),
                Text('8. Generate Doctor Summary PDF: 1 tap generates doctor-ready care summary.', style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Got it!'),
            ),
          ],
        );
      },
    );
  }
}
