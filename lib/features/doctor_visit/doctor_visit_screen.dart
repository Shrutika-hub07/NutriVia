import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';
import '../../core/providers/app_state_provider.dart';
import 'doctor_report_pdf.dart';

class DoctorVisitScreen extends StatefulWidget {
  final AppState state;
  final String language;

  const DoctorVisitScreen({super.key, required this.state, required this.language});

  @override
  State<DoctorVisitScreen> createState() => _DoctorVisitScreenState();
}

class _DoctorVisitScreenState extends State<DoctorVisitScreen> {
  final TextEditingController _voiceNoteController = TextEditingController(
    text: 'Doctor asked me to do CBC and ferritin, and said to repeat vitamin D in 8 weeks.',
  );

  bool isParsed = false;
  List<String> parsedActions = [];

  void _parseSpokenNote() {
    setState(() {
      isParsed = true;
      parsedActions = [
        'Lab Test Scheduled: Complete Blood Count (CBC)',
        'Lab Test Scheduled: Serum Ferritin (Iron stores)',
        'Retest Follow-up: Repeat 25-OH Vitamin D in 8 weeks',
        'Medicine Note: Continue Vitamin D weekly sachet with evening milk',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Visit Mode'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined, color: NutriviaColors.marigold),
            tooltip: 'Export Doctor PDF',
            onPressed: () => DoctorReportPdfGenerator.generateAndPrintReport(context, widget.state),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Doctor Report PDF Export Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [NutriviaColors.plum, NutriviaColors.deepPlum],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: NutriviaColors.marigold,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '1-Tap Doctor Summary PDF',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Clean clinical report of symptoms, meds & labs',
                        style: TextStyle(color: NutriviaColors.peach, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => DoctorReportPdfGenerator.generateAndPrintReport(context, widget.state),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: NutriviaColors.plum,
                    minimumSize: const Size(80, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  child: const Text('View PDF', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // PART 1: BEFORE VISIT QUESTIONS
          const Text(
            'Before Your Visit (Questions to Ask Your Doctor):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
          ),
          const SizedBox(height: 10),
          _buildQuestionCard(
            '1. Iron & Ferritin Check:',
            '“Doctor, my tiredness has continued despite diet changes. Could we run a CBC and Ferritin to check if my iron stores are depleted?”',
          ),
          _buildQuestionCard(
            '2. Vitamin D Retest Timing:',
            '“I have completed 6 weeks of weekly Vitamin D sachets and my knee aches decreased from 7 to 4. Is it time to repeat my 25-OH test?”',
          ),
          _buildQuestionCard(
            '3. Supplement & Tea Timing:',
            '“I take tea in the afternoon. What is the safest time gap for taking my iron or calcium supplements?”',
          ),
          const SizedBox(height: 24),

          // PART 2: AFTER VISIT CLOSING THE LOOP
          const Text(
            'After Your Visit (Voice Follow-Up Loop):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
          ),
          const SizedBox(height: 6),
          const Text(
            'Speak what the doctor told you; Nutrivia will parse it into calendar tests & reminders:',
            style: TextStyle(fontSize: 13, color: NutriviaColors.stone),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _voiceNoteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Speak or type what the doctor instructed...',
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton.filled(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Listening for doctor follow-up instructions...')),
                        );
                      },
                      icon: const Icon(Icons.mic, color: Colors.white),
                      style: IconButton.styleFrom(backgroundColor: NutriviaColors.marigold),
                    ),
                    ElevatedButton(
                      onPressed: _parseSpokenNote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NutriviaColors.plum,
                        minimumSize: const Size(140, 44),
                      ),
                      child: const Text('Parse Instructions'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Parsed Entries Preview
          if (isParsed) ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: NutriviaColors.cream,
                borderRadius: NutriviaShapes.organicCard,
                border: Border.all(color: NutriviaColors.peach, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Proposed Follow-Up Actions (Confirm to Save):',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: NutriviaColors.plum),
                  ),
                  const SizedBox(height: 12),
                  ...parsedActions.map((act) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_rounded, color: NutriviaColors.statusOk, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            act,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: NutriviaColors.nightPlum),
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Closed doctor loop! Reminders and tests queued.')),
                      );
                      setState(() => isParsed = false);
                    },
                    child: const Text('Confirm & Save to Health Record'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionCard(String title, String question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: NutriviaColors.plum)),
            const SizedBox(height: 4),
            Text(question, style: const TextStyle(fontSize: 13, color: NutriviaColors.nightPlum, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
