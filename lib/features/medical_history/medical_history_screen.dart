import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/tokens.dart';
import '../../core/localization/app_strings.dart';
import '../../core/providers/app_state_provider.dart';

class MedicalHistoryScreen extends ConsumerStatefulWidget {
  final String language;

  const MedicalHistoryScreen({super.key, required this.language});

  @override
  ConsumerState<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends ConsumerState<MedicalHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers for Add Medicine
  final _medNameController = TextEditingController();
  final _medDosageController = TextEditingController();
  final _medReasonController = TextEditingController();
  final _medNotesController = TextEditingController();
  double _severityBefore = 7.0;
  double _severityAfter = 4.0;

  // Controllers for Add Lab
  final _labNameController = TextEditingController();
  final _labValueController = TextEditingController();
  final _labUnitController = TextEditingController(text: 'g/dL');
  String _labStatus = 'low';

  // Profile History
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late String _selectedDiet;
  late String _selectedSunlight;
  late bool _teaWithMeals;
  late bool _heavyFlow;
  late int _monthsPeriod;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final p = ref.read(appStateProvider).profile;
    _nameController = TextEditingController(text: p.name);
    _ageController = TextEditingController(text: p.age.toString());
    _selectedDiet = p.diet;
    _selectedSunlight = p.sunlight;
    _teaWithMeals = p.teaWithMeals;
    _heavyFlow = p.heavyFlow;
    _monthsPeriod = p.monthsSinceLastPeriod;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _medNameController.dispose();
    _medDosageController.dispose();
    _medReasonController.dispose();
    _medNotesController.dispose();
    _labNameController.dispose();
    _labValueController.dispose();
    _labUnitController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    final notifier = ref.read(appStateProvider.notifier);
    final lang = widget.language;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang == 'mr'
              ? 'वैद्यकीय इतिहास व नोंदी'
              : (lang == 'hi' ? 'चिकित्सा इतिहास व रिपोर्ट' : 'Medical History & Records'),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: NutriviaColors.plum,
          indicatorColor: NutriviaColors.marigold,
          indicatorWeight: 3,
          tabs: [
            Tab(
              icon: const Icon(Icons.person_outline),
              text: lang == 'mr' ? 'आरोग्य माहिती' : (lang == 'hi' ? 'स्वास्थ्य' : 'Health Info'),
            ),
            Tab(
              icon: const Icon(Icons.medication_outlined),
              text: lang == 'mr' ? 'औषधे' : (lang == 'hi' ? 'दवाएं' : 'Medicines'),
            ),
            Tab(
              icon: const Icon(Icons.science_outlined),
              text: lang == 'mr' ? 'चाचण्या' : (lang == 'hi' ? 'रिपोर्ट्स' : 'Lab Reports'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: Profile & Gynecological History
          _buildHealthProfileTab(state, notifier, lang),

          // TAB 2: Medicines Vault & Input
          _buildMedicinesTab(state, notifier, lang),

          // TAB 3: Lab Reports Vault & Input
          _buildLabsTab(state, notifier, lang),
        ],
      ),
    );
  }

  Widget _buildHealthProfileTab(AppState state, AppStateNotifier notifier, String lang) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: NutriviaColors.cream,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NutriviaColors.peach),
          ),
          child: Row(
            children: [
              const Icon(Icons.shield_outlined, color: NutriviaColors.plum, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  lang == 'mr'
                      ? 'येथे भरलेली माहिती थेट तुमच्या न्यूट्री-ब्लूम आणि जोखीम विश्लेषणासाठी वापरली जाते.'
                      : (lang == 'hi'
                          ? 'यहाँ दी गई जानकारी सीधे आपके न्यूट्री-ब्लूम और जोखिम विश्लेषण को अपडेट करती है।'
                          : 'Your inputs here directly recalculate the Nutri-Bloom petals and Why Map risks.'),
                  style: const TextStyle(fontSize: 13, color: NutriviaColors.nightPlum),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Full Name
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: lang == 'mr' ? 'तुमचे पूर्ण नाव' : (lang == 'hi' ? 'पूरा नाम' : 'Full Name'),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 14),

        // Age
        TextField(
          controller: _ageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: lang == 'mr' ? 'वय (वर्षे)' : (lang == 'hi' ? 'आयु (वर्ष)' : 'Age (Years)'),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 18),

        // Diet Type
        Text(
          lang == 'mr' ? 'आहार प्रकार:' : (lang == 'hi' ? 'आहार प्रकार:' : 'Diet Type:'),
          style: const TextStyle(fontWeight: FontWeight.bold, color: NutriviaColors.plum),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _buildChoiceChip('vegetarian', lang == 'mr' ? 'शाकाहारी' : (lang == 'hi' ? 'शाकाहारी' : 'Vegetarian'), _selectedDiet, (v) => setState(() => _selectedDiet = v)),
            _buildChoiceChip('eggetarian', lang == 'mr' ? 'अंड्यांसह' : (lang == 'hi' ? 'अंडा युक्त' : 'Eggetarian'), _selectedDiet, (v) => setState(() => _selectedDiet = v)),
            _buildChoiceChip('non_vegetarian', lang == 'mr' ? 'मांसाहारी' : (lang == 'hi' ? 'मांसाहारी' : 'Non-Veg'), _selectedDiet, (v) => setState(() => _selectedDiet = v)),
            _buildChoiceChip('jain', lang == 'mr' ? 'जैन' : (lang == 'hi' ? 'जैन' : 'Jain'), _selectedDiet, (v) => setState(() => _selectedDiet = v)),
          ],
        ),
        const SizedBox(height: 18),

        // Sunlight Exposure
        Text(
          lang == 'mr' ? 'दैनिक सूर्यप्रकाश एक्सपोजर:' : (lang == 'hi' ? 'दैनिक धूप:' : 'Daily Sunlight Exposure:'),
          style: const TextStyle(fontWeight: FontWeight.bold, color: NutriviaColors.plum),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _buildChoiceChip('low', lang == 'mr' ? 'कमी (< 15 मिनिटे)' : (lang == 'hi' ? 'कम (< 15 मिनट)' : 'Low (< 15 min)'), _selectedSunlight, (v) => setState(() => _selectedSunlight = v)),
            _buildChoiceChip('medium', lang == 'mr' ? 'मध्यम (15-30 मिनिटे)' : (lang == 'hi' ? 'मध्यम (15-30 मिनट)' : 'Moderate (15-30 min)'), _selectedSunlight, (v) => setState(() => _selectedSunlight = v)),
            _buildChoiceChip('high', lang == 'mr' ? 'भरपूर (> 30 मिनिटे)' : (lang == 'hi' ? 'अधिक (> 30 मिनट)' : 'High (> 30 min)'), _selectedSunlight, (v) => setState(() => _selectedSunlight = v)),
          ],
        ),
        const SizedBox(height: 18),

        // Lifestyle & Habit Switches
        SwitchListTile(
          title: Text(lang == 'mr' ? 'जेवणासोबत चहा किंवा कॉफी पिण्याची सवय' : (lang == 'hi' ? 'भोजन के साथ चाय/कॉफी पीने की आदत' : 'Habit of Tea/Coffee with meals')),
          subtitle: Text(lang == 'mr' ? 'चहामधील टॅनिनमुळे लोहाचे शोषण ७०% कमी होते' : (lang == 'hi' ? 'चाय आयरन अवशोषण घटाती है' : 'Tannins in tea block non-heme iron absorption')),
          value: _teaWithMeals,
          activeThumbColor: NutriviaColors.marigold,
          onChanged: (v) => setState(() => _teaWithMeals = v),
        ),
        SwitchListTile(
          title: Text(lang == 'mr' ? 'मासिक पाळीत अतिरक्तस्त्राव (Heavy Flow) चा त्रास' : (lang == 'hi' ? 'माहवारी में भारी रक्तस्राव' : 'History of heavy menstrual bleeding')),
          value: _heavyFlow,
          activeThumbColor: NutriviaColors.statusAlert,
          onChanged: (v) => setState(() => _heavyFlow = v),
        ),
        const SizedBox(height: 12),

        // Menopause / Cycle Status
        Text(
          lang == 'mr' ? 'शेवटची पाळी येऊन किती महिने झाले?' : (lang == 'hi' ? 'अंतिम माहवारी को कितने महीने हुए?' : 'Months since last menstrual period:'),
          style: const TextStyle(fontWeight: FontWeight.bold, color: NutriviaColors.plum),
        ),
        Slider(
          value: _monthsPeriod.toDouble(),
          min: 0,
          max: 24,
          divisions: 24,
          label: '$_monthsPeriod ${lang == 'mr' ? 'महिने' : 'months'}',
          activeColor: NutriviaColors.plum,
          onChanged: (v) => setState(() => _monthsPeriod = v.toInt()),
        ),
        Center(
          child: Text(
            '$_monthsPeriod ${lang == 'mr' ? 'महिने' : (lang == 'hi' ? 'महीने' : 'months')}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: NutriviaColors.marigold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: () {
            notifier.updateProfileHistory(
              name: _nameController.text.trim(),
              age: int.tryParse(_ageController.text.trim()) ?? 48,
              diet: _selectedDiet,
              sunlight: _selectedSunlight,
              teaWithMeals: _teaWithMeals,
              heavyFlow: _heavyFlow,
              monthsSinceLastPeriod: _monthsPeriod,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  lang == 'mr'
                      ? 'माहिती यशस्वीरीत्या जतन केली व आरोग्य गुण अद्यतनित केले!'
                      : (lang == 'hi' ? 'जानकारी सहेजी गई और रिपोर्ट अपडेट हो गई!' : 'Health profile updated & risks recalculated!'),
                ),
                backgroundColor: NutriviaColors.statusOk,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: NutriviaColors.plum,
            minimumSize: const Size(double.infinity, 48),
          ),
          child: Text(
            lang == 'mr' ? 'माहिती जतन करा व पुनर्गणना करा' : (lang == 'hi' ? 'सहेजें व अपडेट करें' : 'Save & Recalculate Health Model'),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicinesTab(AppState state, AppStateNotifier notifier, String lang) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Add Medicine Form Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NutriviaColors.snow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NutriviaColors.lavenderMist),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang == 'mr' ? '+ नवीन औषध नोंदवा' : (lang == 'hi' ? '+ नई दवा जोड़ें' : '+ Add New Medicine / Supplement'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _medNameController,
                decoration: InputDecoration(
                  labelText: lang == 'mr' ? 'औषधाचे नाव (उदा. Calcium, Metformin)' : 'Medicine Name (e.g. Iron, Thyronorm)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _medDosageController,
                decoration: InputDecoration(
                  labelText: lang == 'mr' ? 'डोस व वेळ (उदा. 1 गोळी जेवणानंतर)' : 'Dosage & Timing (e.g. 1 tab morning)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _medReasonController,
                decoration: InputDecoration(
                  labelText: lang == 'mr' ? 'कशासाठी घेत आहात? (उदा. गुडघेदुखी, थकवा)' : 'Target Symptom (e.g. Knee pain, Fatigue)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                lang == 'mr' ? 'औषधापूर्वी त्रास किती होता? (${_severityBefore.toInt()}/10):' : 'Severity before medicine (${_severityBefore.toInt()}/10):',
                style: const TextStyle(fontSize: 13, color: NutriviaColors.terracotta, fontWeight: FontWeight.bold),
              ),
              Slider(
                value: _severityBefore,
                min: 0,
                max: 10,
                divisions: 10,
                activeColor: NutriviaColors.statusAlert,
                onChanged: (v) => setState(() => _severityBefore = v),
              ),
              Text(
                lang == 'mr' ? 'औषधानंतर आता त्रास किती आहे? (${_severityAfter.toInt()}/10):' : 'Severity now after medicine (${_severityAfter.toInt()}/10):',
                style: const TextStyle(fontSize: 13, color: NutriviaColors.statusOk, fontWeight: FontWeight.bold),
              ),
              Slider(
                value: _severityAfter,
                min: 0,
                max: 10,
                divisions: 10,
                activeColor: NutriviaColors.statusOk,
                onChanged: (v) => setState(() => _severityAfter = v),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (_medNameController.text.trim().isEmpty) return;
                  notifier.addMedicine(
                    name: _medNameController.text.trim(),
                    dosage: _medDosageController.text.trim().isEmpty ? '1 tablet daily' : _medDosageController.text.trim(),
                    targetProblem: _medReasonController.text.trim().isEmpty ? 'General Wellness' : _medReasonController.text.trim(),
                    severityBefore: _severityBefore.toInt(),
                    severityAfter: _severityAfter.toInt(),
                    notes: 'Self-reported by user.',
                  );
                  _medNameController.clear();
                  _medDosageController.clear();
                  _medReasonController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(lang == 'mr' ? 'औषध सुरक्षितरीत्या जोडले गेले!' : 'Medicine logged successfully!'),
                      backgroundColor: NutriviaColors.statusOk,
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: Text(lang == 'mr' ? 'औषध जोडा' : (lang == 'hi' ? 'दवा जोड़ें' : 'Save Medicine to Vault')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: NutriviaColors.plum,
                  minimumSize: const Size(double.infinity, 42),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text(
          lang == 'mr' ? 'सध्या सुरू असलेली औषधे (${state.medicines.length}):' : 'Active Medicines (${state.medicines.length}):',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
        ),
        const SizedBox(height: 8),

        ...state.medicines.map((med) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: NutriviaColors.peach,
                  child: Icon(Icons.medication, color: NutriviaColors.terracotta),
                ),
                title: Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${med.dosage} • ${med.targetProblem}\nबदल: ${med.severityBefore}/10 ➔ ${med.severityAfter}/10'),
                isThreeLine: true,
              ),
            )),
      ],
    );
  }

  Widget _buildLabsTab(AppState state, AppStateNotifier notifier, String lang) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Add Lab Form Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NutriviaColors.snow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NutriviaColors.lavenderMist),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang == 'mr' ? '+ नवीन लॅब टेस्ट रिपोर्ट नोंदवा' : (lang == 'hi' ? '+ नई लैब रिपोर्ट जोड़ें' : '+ Add New Lab Test Report'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _labNameController,
                decoration: InputDecoration(
                  labelText: lang == 'mr' ? 'चाचणीचे नाव (उदा. Haemoglobin, Vitamin D, TSH)' : 'Test Name (e.g. Haemoglobin, Ferritin, B12)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _labValueController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: lang == 'mr' ? 'चाचणी मूल्य' : 'Test Value',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _labUnitController,
                      decoration: InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                lang == 'mr' ? 'डॉक्टरांचा निष्कर्ष:' : 'Status / Finding:',
                style: const TextStyle(fontSize: 13, color: NutriviaColors.plum, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  _buildChoiceChip('low', lang == 'mr' ? 'कमी (Low)' : 'Low', _labStatus, (v) => setState(() => _labStatus = v)),
                  const SizedBox(width: 8),
                  _buildChoiceChip('normal', lang == 'mr' ? 'सामान्य (Normal)' : 'Normal', _labStatus, (v) => setState(() => _labStatus = v)),
                  const SizedBox(width: 8),
                  _buildChoiceChip('high', lang == 'mr' ? 'जास्त (High)' : 'High', _labStatus, (v) => setState(() => _labStatus = v)),
                ],
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: () {
                  if (_labNameController.text.trim().isEmpty) return;
                  final val = double.tryParse(_labValueController.text.trim()) ?? 0.0;
                  notifier.addLabReport(
                    testName: _labNameController.text.trim(),
                    value: val,
                    unit: _labUnitController.text.trim().isEmpty ? 'units' : _labUnitController.text.trim(),
                    status: _labStatus,
                  );
                  _labNameController.clear();
                  _labValueController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(lang == 'mr' ? 'लॅब रिपोर्ट यशस्वीरित्या जोडली गेली!' : 'Lab report saved!'),
                      backgroundColor: NutriviaColors.statusOk,
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: Text(lang == 'mr' ? 'रिपोर्ट नोंदवा' : (lang == 'hi' ? 'रिपोर्ट सहेजें' : 'Save Lab Report')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: NutriviaColors.plum,
                  minimumSize: const Size(double.infinity, 42),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text(
          lang == 'mr' ? 'जतन केलेले लॅब रिपोर्ट्स (${state.labs.length}):' : 'Recorded Lab Values (${state.labs.length}):',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
        ),
        const SizedBox(height: 8),

        ...state.labs.map((lab) {
          final isLow = lab.status == 'low';
          final color = isLow ? NutriviaColors.statusAlert : NutriviaColors.statusOk;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(Icons.biotech, color: color),
              title: Text(lab.testName, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color),
                ),
                child: Text(
                  '${lab.value} ${lab.unit} (${lab.status.toUpperCase()})',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildChoiceChip(String value, String label, String groupValue, Function(String) onSelect) {
    final isSelected = value == groupValue;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: NutriviaColors.plum,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : NutriviaColors.nightPlum,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      onSelected: (v) {
        if (v) onSelect(value);
      },
    );
  }
}
