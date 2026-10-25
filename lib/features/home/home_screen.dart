import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';
import '../../core/localization/app_strings.dart';
import '../../core/providers/app_state_provider.dart';
import '../../core/widgets/vector_motifs.dart';
import '../assistant/sakhi_avatar.dart';
import 'nutri_bloom.dart';
import 'garland_streak.dart';
import '../calm/calm_screen.dart';
import '../why_map/why_map_screen.dart';
import '../track/checkin_screen.dart';
import '../period_menopause/menopause_screen.dart';
import '../movement/movement_screen.dart';
import '../doctor_visit/doctor_visit_screen.dart';
import '../medical_history/medical_history_screen.dart';

class HomeScreen extends StatelessWidget {
  final AppState state;
  final String language;
  final VoidCallback onOpenAssistant;
  final VoidCallback onCheckinDone;
  final Function(String) onLanguageChange;
  final VoidCallback onToggleDemoMode;

  const HomeScreen({
    super.key,
    required this.state,
    required this.language,
    required this.onOpenAssistant,
    required this.onCheckinDone,
    required this.onLanguageChange,
    required this.onToggleDemoMode,
  });

  @override
  Widget build(BuildContext context) {
    String tr(String key) => AppStrings.get(key, language);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Floral Scalloped Top App Bar
          SliverAppBar(
            pinned: true,
            expandedHeight: 70,
            backgroundColor: NutriviaColors.snow,
            elevation: 0,
            title: GestureDetector(
              onLongPress: onToggleDemoMode,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomPaint(
                    size: const Size(24, 24),
                    painter: LotusPoppyPainter(),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      tr('app_name'),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: NutriviaColors.plum,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  if (state.isSampleData) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: NutriviaColors.marigold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: NutriviaColors.marigold, width: 0.8),
                      ),
                      child: Text(
                        tr('sample_data_badge'),
                        style: const TextStyle(
                          color: NutriviaColors.terracotta,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              // Garland Streak Counter
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: GarlandStreakWidget(
                  streakDays: state.streakDays,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DailyCheckinScreen(
                          language: language,
                          onSaved: onCheckinDone,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 4),
              // Language Switch Menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.language_rounded, color: NutriviaColors.plum, size: 24),
                onSelected: onLanguageChange,
                itemBuilder: (ctx) => [
                  const PopupMenuItem(value: 'mr', child: Text('मराठी (Marathi)')),
                  const PopupMenuItem(value: 'hi', child: Text('हिंदी (Hindi)')),
                  const PopupMenuItem(value: 'en', child: Text('English')),
                ],
              ),
              const SizedBox(width: 4),
            ],
          ),

          // Main Home Content
          SliverList(
            delegate: SliverChildListDelegate([
              // 1. ASSISTANT HERO CARD ("Sakhi")
              // Prominent Medical Records & Intake Action Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MedicalHistoryScreen(language: language),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: NutriviaColors.snow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: NutriviaColors.marigold, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: NutriviaColors.marigold.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: NutriviaColors.marigold.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.note_add_rounded, color: NutriviaColors.terracotta, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr('medical_history'),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: NutriviaColors.plum),
                              ),
                              Text(
                                tr('medical_history_sub'),
                                style: const TextStyle(fontSize: 11, color: NutriviaColors.nightPlum),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, color: NutriviaColors.marigold, size: 14),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: NutriviaColors.snow,
                    borderRadius: NutriviaShapes.organicCard,
                    border: Border.all(color: NutriviaColors.lavenderMist),
                    boxShadow: [
                      BoxShadow(
                        color: NutriviaColors.plum.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // Subtle decorative rangoli watermark safely bounded inside
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Opacity(
                          opacity: 0.08,
                          child: CustomPaint(
                            size: const Size(100, 100),
                            painter: KolamRangoliPainter(opacity: 0.8),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SakhiAvatarWidget(
                                  size: 72,
                                  styleIndex: state.avatarStyle,
                                  isSpeaking: false,
                                  isReducedMotion: false,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        language == 'mr'
                                            ? 'नमस्कार, ${state.profile.name}'
                                            : (language == 'hi' ? 'नमस्ते, ${state.profile.name}' : 'Hello, ${state.profile.name}'),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: NutriviaColors.plum,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        tr('assistant_tag'),
                                        style: const TextStyle(
                                          color: NutriviaColors.terracotta,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        language == 'mr'
                                            ? 'कसे वाटते आहे आज? मी तुमची सखी सोबत आहे.'
                                            : 'How are you feeling today? Sakhi is here.',
                                        style: const TextStyle(fontSize: 13, color: NutriviaColors.nightPlum),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Big "Talk to Sakhi" CTA
                            ElevatedButton.icon(
                              onPressed: onOpenAssistant,
                              icon: const Icon(Icons.forum_outlined, size: 20),
                              label: Text(tr('talk_to_assistant')),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: NutriviaColors.plum,
                                minimumSize: const Size(double.infinity, 48),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // 3 Quick Action Chips
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildQuickActionButton(
                                  context: context,
                                  icon: Icons.checklist_rounded,
                                  label: tr('quick_checkin'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DailyCheckinScreen(
                                          language: language,
                                          onSaved: onCheckinDone,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                _buildQuickActionButton(
                                  context: context,
                                  icon: Icons.help_outline_rounded,
                                  label: tr('quick_question'),
                                  onTap: onOpenAssistant,
                                ),
                                _buildQuickActionButton(
                                  context: context,
                                  icon: Icons.spa_outlined,
                                  label: tr('quick_relax'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CalmSpaceScreen(language: language),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. NUTRI-BLOOM HERO (The 8-petal signature flower)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: NutriviaColors.snow,
                    borderRadius: NutriviaShapes.organicCard,
                    border: Border.all(color: NutriviaColors.lavenderMist),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tr('bloom_title'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: NutriviaColors.plum,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: NutriviaColors.lavenderMist.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text('8 Vital Minerals', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tr('bloom_subtitle'),
                              style: const TextStyle(fontSize: 13, color: NutriviaColors.stone),
                            ),
                          ],
                        ),
                      ),

                      // Animated Nutri-Bloom Flower
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: NutriBloomFlowerWidget(
                          petals: state.bloomPetals,
                          language: language,
                          onPetalTap: (petal) {
                            showNutriBloomPetalSheet(
                              context: context,
                              petal: petal,
                              language: language,
                            );
                          },
                        ),
                      ),

                      // Tap hint footer
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Text(
                          tr('tap_petal_hint'),
                          style: const TextStyle(
                            fontSize: 12,
                            color: NutriviaColors.terracotta,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. WHY MAP HIGHLIGHT (High Risk Predictive Alerts)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.psychology_rounded, color: NutriviaColors.terracotta, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'Why Map: Midlife Deficiencies',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => WhyMapScreen(
                                    riskResults: state.riskResults,
                                    language: language,
                                  ),
                                ),
                              );
                            },
                            child: const Text('View All', style: TextStyle(fontWeight: FontWeight.bold, color: NutriviaColors.plum)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Highlights top high risk items
                      ...state.riskResults.where((r) => r.level == 'high').map((r) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: NutriviaColors.statusAlert,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${r.displayName}: ${r.totalScore} points (High attention)',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: NutriviaColors.nightPlum),
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, color: NutriviaColors.stone, size: 12),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // 4. MORE SIGNATURE MODULES GRID
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildFeatureCard(
                        title: 'Menopause',
                        subtitle: state.strawStage['name'] ?? 'STRAW Stage',
                        icon: Icons.calendar_month_outlined,
                        color: NutriviaColors.plum,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MenopauseScreen(state: state, language: language),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFeatureCard(
                        title: 'Gentle Yoga',
                        subtitle: 'Bone & Knee Safe',
                        icon: Icons.self_improvement_rounded,
                        color: NutriviaColors.marigold,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MovementScreen(language: language),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFeatureCard(
                        title: 'Doctor PDF',
                        subtitle: '1-Tap Export',
                        icon: Icons.assignment_outlined,
                        color: NutriviaColors.statusOk,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DoctorVisitScreen(state: state, language: language),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: NutriviaColors.paper,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: NutriviaColors.lavenderMist),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: NutriviaColors.plum, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: NutriviaColors.nightPlum,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: NutriviaColors.snow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: NutriviaColors.lavenderMist),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: NutriviaColors.plum),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: NutriviaColors.stone),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
