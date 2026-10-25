import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';

class OnboardingScreen extends StatefulWidget {
  final Function(String lang, int age, String diet, List<String> fasts) onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentStep = 0;
  String selectedLang = 'mr';
  int age = 52;
  String selectedDiet = 'vegetarian';
  final List<String> selectedFasts = ['Mondays', 'Ekadashi'];
  final TextEditingController _voiceFillController = TextEditingController(
    text: 'I am 52, vegetarian, I fast on Mondays and Ekadashi',
  );

  void _parseVoiceSentence() {
    final text = _voiceFillController.text.toLowerCase();
    setState(() {
      if (text.contains('52')) age = 52;
      if (text.contains('vegetarian') || text.contains('शाकाहारी')) selectedDiet = 'vegetarian';
      if (text.contains('monday') || text.contains('सोमवार')) {
        if (!selectedFasts.contains('Mondays')) selectedFasts.add('Mondays');
      }
      if (text.contains('ekadashi') || text.contains('एकादशी')) {
        if (!selectedFasts.contains('Ekadashi')) selectedFasts.add('Ekadashi');
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Auto-filled fields from voice sentence!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NutriviaColors.paper,
      appBar: AppBar(
        title: const Text('Welcome to Nutrivia'),
        actions: [
          TextButton(
            onPressed: () => widget.onComplete(selectedLang, age, selectedDiet, selectedFasts),
            child: const Text('Skip / Use Demo', style: TextStyle(fontWeight: FontWeight.bold, color: NutriviaColors.terracotta)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STEP 1: First screen language picker
            if (currentStep == 0) ...[
              const Text(
                'पहिली पायरी: भाषा निवडा / भाषा चुनें / Select Language',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: NutriviaColors.plum),
              ),
              const SizedBox(height: 6),
              const Text('You can change this anytime from top-right or settings.', style: TextStyle(fontSize: 13, color: NutriviaColors.stone)),
              const SizedBox(height: 20),
              _buildLangTile('मराठी', 'mr', 'महाराष्ट्रातील माता-भगिनींसाठी अस्सल मराठीत'),
              _buildLangTile('हिंदी', 'hi', 'स्वाभाविक और सरल हिंदी भाषा में'),
              _buildLangTile('English', 'en', 'Midlife health companion in English'),
              const Spacer(),
              ElevatedButton(
                onPressed: () => setState(() => currentStep = 1),
                child: const Text('Next / पुढे चला'),
              ),
            ] else ...[
              // STEP 2: Conversational Profile with Voice Sentence Auto-Fill
              const Text(
                'Voice Onboarding / बोलून माहिती भरा',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: NutriviaColors.plum),
              ),
              const SizedBox(height: 4),
              const Text(
                'Speak or type: e.g. "I am 52, vegetarian, I fast on Mondays"',
                style: TextStyle(fontSize: 13, color: NutriviaColors.stone),
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NutriviaColors.snow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: NutriviaColors.lavenderMist),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _voiceFillController,
                      decoration: const InputDecoration(border: InputBorder.none),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _parseVoiceSentence,
                          icon: const Icon(Icons.auto_awesome, size: 18),
                          label: const Text('Auto-Fill'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: NutriviaColors.marigold,
                            minimumSize: const Size(120, 36),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Confirmed Fields Display
              Text('Age: $age years', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: NutriviaColors.plum)),
              Text('Diet: ${selectedDiet.toUpperCase()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: NutriviaColors.plum)),
              Text('Fasting habits: ${selectedFasts.join(", ")}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: NutriviaColors.plum)),
              const SizedBox(height: 8),

              // Why we ask disclaimer
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: NutriviaColors.cream,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Why we ask: Diet and fasting habits determine which iron and B12 sources are culturally relevant to you.',
                  style: TextStyle(fontSize: 12, color: NutriviaColors.terracotta),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => widget.onComplete(selectedLang, age, selectedDiet, selectedFasts),
                child: const Text('Confirm & Enter Nutrivia'),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLangTile(String title, String code, String subtitle) {
    final isSelected = selectedLang == code;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? NutriviaColors.marigold : NutriviaColors.lavenderMist,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: isSelected ? const Icon(Icons.check_circle, color: NutriviaColors.marigold) : null,
        onTap: () => setState(() => selectedLang = code),
      ),
    );
  }
}
