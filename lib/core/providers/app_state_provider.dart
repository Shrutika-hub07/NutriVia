import 'package:flutter_riverpod/legacy.dart';
import '../services/rules_service.dart';

class UserProfile {
  final String name;
  final int age;
  final String state;
  final String region;
  final String diet;
  final String sunlight;
  final String clothing;
  final bool teaWithMeals;
  final bool heavyFlow;
  final int monthsSinceLastPeriod;
  final int cycleLengthVarianceDays;
  final List<String> fasts;
  final List<String> symptoms;
  final List<String> activeMeds;

  UserProfile({
    required this.name,
    required this.age,
    required this.state,
    required this.region,
    required this.diet,
    required this.sunlight,
    required this.clothing,
    required this.teaWithMeals,
    required this.heavyFlow,
    required this.monthsSinceLastPeriod,
    required this.cycleLengthVarianceDays,
    required this.fasts,
    required this.symptoms,
    required this.activeMeds,
  });

  UserProfile copyWith({
    String? name,
    int? age,
    String? state,
    String? region,
    String? diet,
    String? sunlight,
    String? clothing,
    bool? teaWithMeals,
    bool? heavyFlow,
    int? monthsSinceLastPeriod,
    int? cycleLengthVarianceDays,
    List<String>? fasts,
    List<String>? symptoms,
    List<String>? activeMeds,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      state: state ?? this.state,
      region: region ?? this.region,
      diet: diet ?? this.diet,
      sunlight: sunlight ?? this.sunlight,
      clothing: clothing ?? this.clothing,
      teaWithMeals: teaWithMeals ?? this.teaWithMeals,
      heavyFlow: heavyFlow ?? this.heavyFlow,
      monthsSinceLastPeriod: monthsSinceLastPeriod ?? this.monthsSinceLastPeriod,
      cycleLengthVarianceDays: cycleLengthVarianceDays ?? this.cycleLengthVarianceDays,
      fasts: fasts ?? this.fasts,
      symptoms: symptoms ?? this.symptoms,
      activeMeds: activeMeds ?? this.activeMeds,
    );
  }
}

class MedicineEntry {
  final String name;
  final String dosage;
  final String targetProblem;
  final DateTime startDate;
  final double adherencePercent;
  final int severityBefore;
  final int severityAfter;
  final String notes;

  MedicineEntry({
    required this.name,
    required this.dosage,
    required this.targetProblem,
    required this.startDate,
    required this.adherencePercent,
    required this.severityBefore,
    required this.severityAfter,
    required this.notes,
  });
}

class LabEntry {
  final String testName;
  final double value;
  final String unit;
  final String status; // 'low', 'normal', 'high'
  final DateTime date;

  LabEntry({
    required this.testName,
    required this.value,
    required this.unit,
    required this.status,
    required this.date,
  });
}

class AppState {
  final String language; // 'mr', 'hi', 'en'
  final double textScale; // 1.0, 1.25, 1.5
  final String persona; // 'sunita', 'meera', 'fresh'
  final bool isSampleData;
  final UserProfile profile;
  final List<RiskScoreResult> riskResults;
  final List<NutriBloomPetalData> bloomPetals;
  final Map<String, dynamic> strawStage;
  final int streakDays;
  final List<MedicineEntry> medicines;
  final List<LabEntry> labs;
  final bool isPrivateMode;
  final int avatarStyle; // 0: Paithani saree, 1: Cotton saree, 2: Kurta

  AppState({
    required this.language,
    required this.textScale,
    required this.persona,
    required this.isSampleData,
    required this.profile,
    required this.riskResults,
    required this.bloomPetals,
    required this.strawStage,
    required this.streakDays,
    required this.medicines,
    required this.labs,
    this.isPrivateMode = false,
    this.avatarStyle = 0,
  });

  AppState copyWith({
    String? language,
    double? textScale,
    String? persona,
    bool? isSampleData,
    UserProfile? profile,
    List<RiskScoreResult>? riskResults,
    List<NutriBloomPetalData>? bloomPetals,
    Map<String, dynamic>? strawStage,
    int? streakDays,
    List<MedicineEntry>? medicines,
    List<LabEntry>? labs,
    bool? isPrivateMode,
    int? avatarStyle,
  }) {
    return AppState(
      language: language ?? this.language,
      textScale: textScale ?? this.textScale,
      persona: persona ?? this.persona,
      isSampleData: isSampleData ?? this.isSampleData,
      profile: profile ?? this.profile,
      riskResults: riskResults ?? this.riskResults,
      bloomPetals: bloomPetals ?? this.bloomPetals,
      strawStage: strawStage ?? this.strawStage,
      streakDays: streakDays ?? this.streakDays,
      medicines: medicines ?? this.medicines,
      labs: labs ?? this.labs,
      isPrivateMode: isPrivateMode ?? this.isPrivateMode,
      avatarStyle: avatarStyle ?? this.avatarStyle,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  final ClinicalRulesService _rules = ClinicalRulesService();

  AppStateNotifier() : super(_buildInitialState()) {
    _initRules();
  }

  static AppState _buildInitialState() {
    final sunitaProfile = UserProfile(
      name: 'Sunita Patil',
      age: 52,
      state: 'Maharashtra',
      region: 'Rural / Western Maharashtra',
      diet: 'vegetarian',
      sunlight: 'low',
      clothing: 'full',
      teaWithMeals: true,
      heavyFlow: true,
      monthsSinceLastPeriod: 8,
      cycleLengthVarianceDays: 45,
      fasts: ['Mondays', 'Ekadashi'],
      symptoms: ['fatigue', 'knee_pain', 'leg_pain_cramps', 'tingling_numbness', 'breathlessness_on_stairs', 'bone_joint_pain'],
      activeMeds: ['Iron Folic Tablet', 'Vitamin D3 Sachet (Weekly)'],
    );

    return AppState(
      language: 'mr', // Default to Marathi for Sunita persona
      textScale: 1.0,
      persona: 'sunita',
      isSampleData: true,
      profile: sunitaProfile,
      riskResults: [],
      bloomPetals: [],
      strawStage: {},
      streakDays: 42, // 6 weeks streak
      avatarStyle: 0,
      medicines: [
        MedicineEntry(
          name: 'Vitamin D3 (Cholecalciferol 60K)',
          dosage: 'Weekly sachet with milk',
          targetProblem: 'Knee & Bone Aches',
          startDate: DateTime.now().subtract(const Duration(days: 42)),
          adherencePercent: 92.0,
          severityBefore: 7,
          severityAfter: 4,
          notes: 'Bone pain down from 7 to 4 after 6 weeks of weekly sachets.',
        ),
        MedicineEntry(
          name: 'Ferrous Ascorbate + Folic Acid',
          dosage: '1 tablet once daily after lunch',
          targetProblem: 'Low Energy & Pale Conjunctiva',
          startDate: DateTime.now().subtract(const Duration(days: 35)),
          adherencePercent: 85.0,
          severityBefore: 8,
          severityAfter: 5,
          notes: '85% adherence. Reported occasional mild constipation.',
        )
      ],
      labs: [
        LabEntry(testName: 'Haemoglobin (Hb)', value: 10.2, unit: 'g/dL', status: 'low', date: DateTime.now().subtract(const Duration(days: 45))),
        LabEntry(testName: 'Serum Ferritin', value: 14.0, unit: 'ng/mL', status: 'low', date: DateTime.now().subtract(const Duration(days: 45))),
        LabEntry(testName: '25-OH Vitamin D', value: 12.4, unit: 'ng/mL', status: 'low', date: DateTime.now().subtract(const Duration(days: 45))),
        LabEntry(testName: 'Vitamin B12', value: 185.0, unit: 'pg/mL', status: 'low', date: DateTime.now().subtract(const Duration(days: 45))),
        LabEntry(testName: 'Serum Calcium', value: 8.9, unit: 'mg/dL', status: 'normal', date: DateTime.now().subtract(const Duration(days: 45))),
        LabEntry(testName: 'TSH (Thyroid)', value: 2.8, unit: 'uIU/mL', status: 'normal', date: DateTime.now().subtract(const Duration(days: 45))),
      ],
    );
  }

  Future<void> _initRules() async {
    await _rules.loadAllRules();
    recalculateState();
  }

  void recalculateState() {
    final risks = _rules.evaluateRiskScores(
      age: state.profile.age,
      diet: state.profile.diet,
      sunlight: state.profile.sunlight,
      clothing: state.profile.clothing,
      teaWithMeals: state.profile.teaWithMeals,
      heavyFlow: state.profile.heavyFlow,
      reportedSymptoms: state.profile.symptoms,
      activeMeds: state.profile.activeMeds,
      lang: state.language,
    );

    final petals = _rules.calculateBloomPetals(risks: risks, lang: state.language);
    final straw = _rules.estimateStrawStage(
      age: state.profile.age,
      monthsSinceLastPeriod: state.profile.monthsSinceLastPeriod,
      cycleLengthVarianceDays: state.profile.cycleLengthVarianceDays,
      lang: state.language,
    );

    state = state.copyWith(
      riskResults: risks,
      bloomPetals: petals,
      strawStage: straw,
    );
  }

  void setLanguage(String lang) {
    state = state.copyWith(language: lang);
    recalculateState();
  }

  void setTextScale(double scale) {
    state = state.copyWith(textScale: scale);
  }

  void setAvatarStyle(int style) {
    state = state.copyWith(avatarStyle: style);
  }

  void togglePrivateMode() {
    state = state.copyWith(isPrivateMode: !state.isPrivateMode);
  }

  // Increment streak for daily check‑in
  void incrementStreak() {
    state = state.copyWith(streakDays: state.streakDays + 1);
    recalculateState();
  }

  void addMedicine({
    required String name,
    required String dosage,
    required String targetProblem,
    required int severityBefore,
    required int severityAfter,
    required String notes,
  }) {
    final entry = MedicineEntry(
      name: name,
      dosage: dosage,
      targetProblem: targetProblem,
      startDate: DateTime.now(),
      adherencePercent: 100.0,
      severityBefore: severityBefore,
      severityAfter: severityAfter,
      notes: notes,
    );
    final updatedMeds = List<MedicineEntry>.from(state.medicines)..insert(0, entry);
    final updatedActiveNames = List<String>.from(state.profile.activeMeds)..add(name);
    state = state.copyWith(
      medicines: updatedMeds,
      profile: state.profile.copyWith(activeMeds: updatedActiveNames),
    );
    recalculateState();
  }

  void addLabReport({
    required String testName,
    required double value,
    required String unit,
    required String status,
  }) {
    final lab = LabEntry(
      testName: testName,
      value: value,
      unit: unit,
      status: status,
      date: DateTime.now(),
    );
    final updatedLabs = List<LabEntry>.from(state.labs)..insert(0, lab);
    state = state.copyWith(labs: updatedLabs);
    recalculateState();
  }

  void updateProfileHistory({
    String? name,
    int? age,
    String? diet,
    String? sunlight,
    String? clothing,
    bool? teaWithMeals,
    bool? heavyFlow,
    int? monthsSinceLastPeriod,
    List<String>? symptoms,
  }) {
    final updatedProfile = state.profile.copyWith(
      name: name,
      age: age,
      diet: diet,
      sunlight: sunlight,
      clothing: clothing,
      teaWithMeals: teaWithMeals,
      heavyFlow: heavyFlow,
      monthsSinceLastPeriod: monthsSinceLastPeriod,
      symptoms: symptoms,
    );
    state = state.copyWith(profile: updatedProfile);
    recalculateState();
  }

  void loadPersona(String personaType) {
    if (personaType == 'sunita') {
      state = _buildInitialState().copyWith(language: 'mr');
    } else if (personaType == 'meera') {
      final meeraProfile = UserProfile(
        name: 'Meera Deshmukh',
        age: 44,
        state: 'Maharashtra',
        region: 'Pune Urban',
        diet: 'eggetarian',
        sunlight: 'medium',
        clothing: 'moderate',
        teaWithMeals: false,
        heavyFlow: false,
        monthsSinceLastPeriod: 0,
        cycleLengthVarianceDays: 14,
        fasts: ['Navratri'],
        symptoms: ['hot_flashes', 'night_sweats', 'brain_fog', 'sleep_trouble'],
        activeMeds: ['Calcium + D3 Tablet'],
      );

      state = AppState(
        language: 'hi',
        textScale: 1.0,
        persona: 'meera',
        isSampleData: true,
        profile: meeraProfile,
        riskResults: [],
        bloomPetals: [],
        strawStage: {},
        streakDays: 18,
        avatarStyle: 1,
        medicines: [
          MedicineEntry(
            name: 'Calcium Carbonate 500mg',
            dosage: '1 tablet with dinner',
            targetProblem: 'Early Perimenopause Bone Shield',
            startDate: DateTime.now().subtract(const Duration(days: 20)),
            adherencePercent: 95.0,
            severityBefore: 5,
            severityAfter: 3,
            notes: 'Consistent daily intake',
          )
        ],
        labs: [
          LabEntry(testName: 'Haemoglobin', value: 12.1, unit: 'g/dL', status: 'normal', date: DateTime.now().subtract(const Duration(days: 20))),
          LabEntry(testName: '25-OH Vitamin D', value: 24.0, unit: 'ng/mL', status: 'normal', date: DateTime.now().subtract(const Duration(days: 20))),
        ],
      );
    } else {
      // Start Fresh
      final freshProfile = UserProfile(
        name: 'You',
        age: 45,
        state: 'Maharashtra',
        region: 'Urban',
        diet: 'vegetarian',
        sunlight: 'medium',
        clothing: 'moderate',
        teaWithMeals: false,
        heavyFlow: false,
        monthsSinceLastPeriod: 1,
        cycleLengthVarianceDays: 5,
        fasts: [],
        symptoms: [],
        activeMeds: [],
      );
      state = AppState(
        language: state.language,
        textScale: state.textScale,
        persona: 'fresh',
        isSampleData: false,
        profile: freshProfile,
        riskResults: [],
        bloomPetals: [],
        strawStage: {},
        streakDays: 1,
        medicines: [],
        labs: [],
      );
    }
    recalculateState();
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});
