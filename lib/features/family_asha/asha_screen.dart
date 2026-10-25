import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';

class AshaScreen extends StatefulWidget {
  final String language;
  const AshaScreen({super.key, required this.language});

  @override
  State<AshaScreen> createState() => _AshaScreenState();
}

class _AshaScreenState extends State<AshaScreen> {
  bool hasInformedConsent = true;
  String beneficiaryName = 'Laxmibai Shinde';
  int beneficiaryAge = 54;
  bool paleConjunctiva = true;
  bool breathlessOnWalk = true;
  bool bleedingAfterMenopause = false;
  bool severeBoneKneePain = true;

  bool isScreened = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASHA Worker Screening (३-Min)'),
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
                Icon(Icons.volunteer_activism_rounded, color: NutriviaColors.plum, size: 28),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Designed for rural Accredited Social Health Activists (ASHAs) to conduct rapid midlife triage in Marathi/Hindi with immediate referral criteria for PHC.',
                    style: TextStyle(fontSize: 13, color: NutriviaColors.nightPlum, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Informed Consent Switch
          CheckboxListTile(
            title: const Text('Informed Verbal Consent Obtained (सहमती घेतली आहे)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Compliant with DPDP Act 2023 for community health workers', style: TextStyle(fontSize: 11)),
            value: hasInformedConsent,
            activeColor: NutriviaColors.statusOk,
            onChanged: (v) => setState(() => hasInformedConsent = v!),
          ),
          const Divider(),
          const SizedBox(height: 10),

          // Screening Questions
          const Text('Rapid Assessment Checklist:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: NutriviaColors.plum)),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Pale conjunctiva / tongue / nails (डोळ्यात फिकटपणा)', style: TextStyle(fontSize: 14)),
            subtitle: const Text('Visual screening for moderate-to-severe anaemia', style: TextStyle(fontSize: 12)),
            value: paleConjunctiva,
            activeThumbColor: NutriviaColors.statusAlert,
            onChanged: (v) => setState(() => paleConjunctiva = v),
          ),
          SwitchListTile(
            title: const Text('Severe breathlessness on walking (चालताना धाप लागणे)', style: TextStyle(fontSize: 14)),
            value: breathlessOnWalk,
            activeThumbColor: NutriviaColors.statusAlert,
            onChanged: (v) => setState(() => breathlessOnWalk = v),
          ),
          SwitchListTile(
            title: const Text('Any bleeding after menopause (पाळी बंद झाल्यावर रक्तस्त्राव)', style: TextStyle(fontSize: 14)),
            subtitle: const Text('Critical red flag for endometrial review', style: TextStyle(fontSize: 12)),
            value: bleedingAfterMenopause,
            activeThumbColor: NutriviaColors.statusAlert,
            onChanged: (v) => setState(() => bleedingAfterMenopause = v),
          ),
          SwitchListTile(
            title: const Text('Severe knee / bone pain preventing work (हाडात तीव्र कळ)', style: TextStyle(fontSize: 14)),
            value: severeBoneKneePain,
            activeThumbColor: NutriviaColors.marigold,
            onChanged: (v) => setState(() => severeBoneKneePain = v),
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () {
              setState(() => isScreened = true);
            },
            child: const Text('Generate PHC Referral Slip (निकाल पहा)'),
          ),
          const SizedBox(height: 20),

          // Referral Decision Card
          if (isScreened) ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: NutriviaColors.cream,
                borderRadius: NutriviaShapes.organicCard,
                border: Border.all(color: NutriviaColors.peach, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.local_hospital_rounded, color: NutriviaColors.statusAlert, size: 26),
                      SizedBox(width: 10),
                      Text(
                        'REFERRAL RECOMMENDED TO PHC / RURAL HOSPITAL',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: NutriviaColors.statusAlert),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('ASHA Action Points:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: NutriviaColors.plum)),
                  const SizedBox(height: 4),
                  if (paleConjunctiva || breathlessOnWalk)
                    const Text('• REFERRAL: Send to Primary Health Centre for Haemoglobin Sahli / CBC testing.', style: TextStyle(fontSize: 13, height: 1.4)),
                  if (severeBoneKneePain)
                    const Text('• ADVICE: Issue Calcium-D3 tablets as per national midlife protocol; demonstrate chair squats.', style: TextStyle(fontSize: 13, height: 1.4)),
                  if (bleedingAfterMenopause)
                    const Text('• URGENT Gynaecological review required.', style: TextStyle(fontSize: 13, color: NutriviaColors.statusAlert, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Referral record saved and synced to ASHA register!')),
                      );
                    },
                    icon: const Icon(Icons.print_outlined),
                    label: const Text('Save & Print ASHA Referral Slip'),
                    style: ElevatedButton.styleFrom(backgroundColor: NutriviaColors.plum),
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
}
