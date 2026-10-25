import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';
import '../../core/providers/app_state_provider.dart';

class CaregiverShareScreen extends StatefulWidget {
  final AppState state;
  const CaregiverShareScreen({super.key, required this.state});

  @override
  State<CaregiverShareScreen> createState() => _CaregiverShareScreenState();
}

class _CaregiverShareScreenState extends State<CaregiverShareScreen> {
  bool isLinkActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Caregiver View'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NutriviaColors.snow,
              borderRadius: NutriviaShapes.organicCard,
              border: Border.all(color: NutriviaColors.lavenderMist),
            ),
            child: Row(
              children: const [
                Icon(Icons.family_restroom_rounded, color: NutriviaColors.plum, size: 28),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Share read-only health and medicine updates with a trusted daughter, sister, or spouse. You retain complete control and can revoke access anytime with one tap.',
                    style: TextStyle(fontSize: 13, color: NutriviaColors.nightPlum, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // QR Code Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: NutriviaColors.cream,
              borderRadius: NutriviaShapes.organicCard,
              border: Border.all(color: NutriviaColors.peach, width: 1.5),
            ),
            child: Column(
              children: [
                const Text(
                  'Scan to Connect Caregiver Phone',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: NutriviaColors.lavenderMist),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.qr_code_2_rounded, size: 100, color: NutriviaColors.plum),
                        Text('nutrivia.app/care/sunita', style: TextStyle(fontSize: 10, color: NutriviaColors.stone)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isLinkActive ? 'Status: Active (Access Allowed)' : 'Status: Revoked (Access Blocked)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isLinkActive ? NutriviaColors.statusOk : NutriviaColors.statusAlert,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() => isLinkActive = !isLinkActive);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isLinkActive ? 'Caregiver link re-enabled' : 'Caregiver access revoked immediately!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLinkActive ? NutriviaColors.statusAlert : NutriviaColors.statusOk,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 46),
                  ),
                  child: Text(isLinkActive ? 'Revoke Caregiver Access' : 'Re-Activate Access Link'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
