import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/vector_motifs.dart';
import '../../core/services/voice_service.dart';

class CalmTechnique {
  final String id;
  final String name;
  final String subtitle;
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;
  final String specialNote;

  const CalmTechnique({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.inhaleSeconds,
    required this.holdSeconds,
    required this.exhaleSeconds,
    required this.specialNote,
  });
}

class CalmSpaceScreen extends StatefulWidget {
  final String language;

  const CalmSpaceScreen({super.key, required this.language});

  @override
  State<CalmSpaceScreen> createState() => _CalmSpaceScreenState();
}

class _CalmSpaceScreenState extends State<CalmSpaceScreen>
    with SingleTickerProviderStateMixin {
  final List<CalmTechnique> techniques = const [
    CalmTechnique(
      id: 'sheetali',
      name: 'Sheetali (Cooling Breath)',
      subtitle: 'Best for sudden hot flashes & night sweats',
      inhaleSeconds: 4,
      holdSeconds: 2,
      exhaleSeconds: 6,
      specialNote: 'Curl your tongue into a tube or part your lips, inhale cooling air slowly.',
    ),
    CalmTechnique(
      id: 'anulom_vilom',
      name: 'Anulom Vilom (Alternate Nostril)',
      subtitle: 'Harmonizes nervous system & clears mind',
      inhaleSeconds: 4,
      holdSeconds: 4,
      exhaleSeconds: 4,
      specialNote: 'Inhale through left, exhale right; inhale right, exhale left.',
    ),
    CalmTechnique(
      id: 'bhramari',
      name: 'Bhramari (Humming Bee)',
      subtitle: 'Dissolves anxiety, palpitations & anger',
      inhaleSeconds: 4,
      holdSeconds: 0,
      exhaleSeconds: 8,
      specialNote: 'Close ears with thumbs, make gentle humming bee sound on exhale.',
    ),
    CalmTechnique(
      id: '4_7_8',
      name: '4-7-8 Deep Sleep',
      subtitle: 'Restores parasympathetic calm for sleep',
      inhaleSeconds: 4,
      holdSeconds: 7,
      exhaleSeconds: 8,
      specialNote: 'Deep diaphragmatic breathing to release adrenaline.',
    ),
  ];

  late CalmTechnique selectedTechnique;
  bool isPlaying = false;
  late AnimationController _breatheAnim;
  String currentPhase = 'Ready';
  bool isNightMode = true;

  @override
  void initState() {
    super.initState();
    selectedTechnique = techniques.first;
    _initAnimation();
  }

  void _initAnimation() {
    final totalCycle = selectedTechnique.inhaleSeconds +
        selectedTechnique.holdSeconds +
        selectedTechnique.exhaleSeconds;

    _breatheAnim = AnimationController(
      vsync: this,
      duration: Duration(seconds: totalCycle),
    );

    _breatheAnim.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _breatheAnim.forward(from: 0.0);
      }
    });

    _breatheAnim.addListener(() {
      final t = _breatheAnim.value * totalCycle;
      final inhaleEnd = selectedTechnique.inhaleSeconds;
      final holdEnd = inhaleEnd + selectedTechnique.holdSeconds;

      String nextPhase;
      if (t <= inhaleEnd) {
        nextPhase = widget.language == 'mr'
            ? 'हळूच श्वास घ्या (Inhale)'
            : (widget.language == 'hi' ? 'श्वास अंदर लें' : 'Breathe In...');
      } else if (t <= holdEnd) {
        nextPhase = widget.language == 'mr'
            ? 'श्वास रोखा (Hold)'
            : (widget.language == 'hi' ? 'रोकें' : 'Hold Gently...');
      } else {
        nextPhase = widget.language == 'mr'
            ? 'हळूवार श्वास सोडा (Exhale)'
            : (widget.language == 'hi' ? 'श्वास छोड़ें' : 'Breathe Out...');
      }

      if (nextPhase != currentPhase) {
        setState(() {
          currentPhase = nextPhase;
        });
      }
    });
  }

  void _togglePlay() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _breatheAnim.forward(from: 0.0);
        VoiceService().speak(currentPhase, widget.language);
      } else {
        _breatheAnim.stop();
        VoiceService().stopSpeaking();
      }
    });
  }

  @override
  void dispose() {
    _breatheAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = isNightMode ? NutriviaColors.nightPlum : NutriviaColors.paper;
    final cardColor = isNightMode ? NutriviaColors.deepPlum : NutriviaColors.snow;
    final textColor = isNightMode ? Colors.white : NutriviaColors.nightPlum;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Calm Space',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isNightMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: NutriviaColors.marigold,
            ),
            onPressed: () => setState(() => isNightMode = !isNightMode),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Technique Picker Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: techniques.map((t) {
                  final isSelected = t.id == selectedTechnique.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(t.name),
                      selected: isSelected,
                      selectedColor: NutriviaColors.marigold,
                      onSelected: (val) {
                        setState(() {
                          selectedTechnique = t;
                          isPlaying = false;
                          _breatheAnim.stop();
                          _initAnimation();
                        });
                      },
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),

            // Subtitle & Clinical Guidance
            Text(
              selectedTechnique.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: NutriviaColors.peach,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 28),

            // Animated Breathing Circle
            SizedBox(
              height: 280,
              child: AnimatedBuilder(
                animation: _breatheAnim,
                builder: (context, child) {
                  final progress = _breatheAnim.value;
                  final scale = isPlaying
                      ? 0.70 + (0.35 * (progress <= 0.4 ? (progress / 0.4) : (1.0 - ((progress - 0.4) / 0.6))))
                      : 0.85;

                  return Center(
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              NutriviaColors.marigold.withValues(alpha: 0.9),
                              NutriviaColors.plum.withValues(alpha: 0.7),
                              NutriviaColors.deepPlum.withValues(alpha: 0.2),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: NutriviaColors.marigold.withValues(alpha: isPlaying ? 0.45 : 0.15),
                              blurRadius: isPlaying ? 35 : 15,
                              spreadRadius: isPlaying ? 10 : 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomPaint(
                                size: const Size(44, 44),
                                painter: PetalPainter(color: Colors.white, fill: true),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                currentPhase,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Play / Pause Button
            ElevatedButton.icon(
              onPressed: _togglePlay,
              icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 28),
              label: Text(
                isPlaying ? 'Pause Practice' : 'Begin Breathing Session',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: NutriviaColors.marigold,
                foregroundColor: Colors.white,
                minimumSize: const Size(260, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
            ),
            const SizedBox(height: 20),

            // Instruction Box
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: NutriviaShapes.organicCard,
                border: Border.all(color: NutriviaColors.lavenderMist.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: NutriviaColors.peach, size: 24),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      selectedTechnique.specialNote,
                      style: TextStyle(color: textColor.withValues(alpha: 0.9), fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // "How do you feel now?" Rating
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: NutriviaShapes.organicCard,
              ),
              child: Column(
                children: [
                  Text(
                    'How do you feel now?',
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMoodIcon('Much calmer', '😌', NutriviaColors.statusOk),
                      _buildMoodIcon('A bit better', '🙂', NutriviaColors.marigold),
                      _buildMoodIcon('About same', '😐', NutriviaColors.stone),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodIcon(String label, String emoji, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thank you! Your feedback helps tailor future sessions.')),
        );
      },
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: NutriviaColors.stone, fontSize: 12)),
        ],
      ),
    );
  }
}
