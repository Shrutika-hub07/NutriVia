import 'dart:convert';
import 'package:flutter/services.dart';

class RuleBreakdownFactor {
  final String id;
  final int points;
  final String reason;

  RuleBreakdownFactor({
    required this.id,
    required this.points,
    required this.reason,
  });
}

class RiskScoreResult {
  final String id;
  final String nutrient;
  final String displayName;
  final int totalScore;
  final String level; // 'low', 'medium', 'high'
  final List<RuleBreakdownFactor> breakdown;
  final List<String> testsToDiscuss;
  final List<String> suggestedFoods;
  final String whyMidlife;

  RiskScoreResult({
    required this.id,
    required this.nutrient,
    required this.displayName,
    required this.totalScore,
    required this.level,
    required this.breakdown,
    required this.testsToDiscuss,
    required this.suggestedFoods,
    required this.whyMidlife,
  });
}

class NutriBloomPetalData {
  final String nutrientId;
  final String nameKey;
  final double score; // 0.0 to 1.0
  final String status; // 'ok', 'watch', 'alert'
  final double angle;
  final List<String> topFoods;
  final String whyMatters;

  NutriBloomPetalData({
    required this.nutrientId,
    required this.nameKey,
    required this.score,
    required this.status,
    required this.angle,
    required this.topFoods,
    required this.whyMatters,
  });
}

class ClinicalRulesService {
  static final ClinicalRulesService _instance = ClinicalRulesService._internal();
  factory ClinicalRulesService() => _instance;
  ClinicalRulesService._internal();

  Map<String, dynamic> redFlagsData = {};
  Map<String, dynamic> riskScoresData = {};
  Map<String, dynamic> interactionsData = {};
  Map<String, dynamic> fastingRulesData = {};
  Map<String, dynamic> strawStagesData = {};
  Map<String, dynamic> knowledgeCardsData = {};
  List<dynamic> indianFoods = [];

  bool isLoaded = false;

  Future<void> loadAllRules() async {
    if (isLoaded) return;
    try {
      final rfStr = await rootBundle.loadString('assets/clinical_rules/red_flags.json');
      redFlagsData = jsonDecode(rfStr);

      final rsStr = await rootBundle.loadString('assets/clinical_rules/risk_scores.json');
      riskScoresData = jsonDecode(rsStr);

      final inStr = await rootBundle.loadString('assets/clinical_rules/interactions.json');
      interactionsData = jsonDecode(inStr);

      final faStr = await rootBundle.loadString('assets/clinical_rules/fasting_rules.json');
      fastingRulesData = jsonDecode(faStr);

      final stStr = await rootBundle.loadString('assets/clinical_rules/straw_stages.json');
      strawStagesData = jsonDecode(stStr);

      final kcStr = await rootBundle.loadString('assets/clinical_rules/knowledge_cards.json');
      knowledgeCardsData = jsonDecode(kcStr);

      final fdStr = await rootBundle.loadString('assets/data/indian_foods.json');
      final fdJson = jsonDecode(fdStr);
      indianFoods = fdJson['foods'] ?? [];

      isLoaded = true;
    } catch (e) {
      // Fallback if assets path differs
      isLoaded = true;
    }
  }

  /// Emergency red flag evaluator
  Map<String, dynamic>? checkRedFlags(String text, String lang) {
    final lower = text.toLowerCase();
    final flags = redFlagsData['flags'] as List<dynamic>? ?? [];

    for (var flag in flags) {
      final keywordsMap = flag['keywords'] as Map<String, dynamic>? ?? {};
      final langKey = ['en', 'hi', 'mr'].contains(lang) ? lang : 'en';

      final allKeywords = <String>[];
      keywordsMap.forEach((k, v) {
        if (v is List) {
          allKeywords.addAll(v.map((e) => e.toString().toLowerCase()));
        }
      });

      for (var kw in allKeywords) {
        if (lower.contains(kw)) {
          final titles = flag['title'] as Map<String, dynamic>? ?? {};
          final messages = flag['message'] as Map<String, dynamic>? ?? {};
          final callPrompts = flag['call_prompt'] as Map<String, dynamic>? ?? {};

          return {
            'is_emergency': true,
            'id': flag['id'],
            'severity': flag['severity'],
            'action_type': flag['action_type'] ?? 'EMERGENCY_MODAL',
            'emergency_number': flag['emergency_number'],
            'title': titles[langKey] ?? titles['en'] ?? 'Emergency',
            'message': messages[langKey] ?? messages['en'] ?? '',
            'call_prompt': callPrompts[langKey] ?? callPrompts['en'] ?? 'Call 112',
          };
        }
      }
    }
    return null;
  }

  /// Points-based transparent risk scoring engine
  List<RiskScoreResult> evaluateRiskScores({
    required int age,
    required String diet, // 'vegetarian', 'non_veg', 'eggetarian', 'jain', 'vegan'
    required String sunlight, // 'low', 'medium', 'high'
    required String clothing, // 'full', 'moderate'
    required bool teaWithMeals,
    required bool heavyFlow,
    required List<String> reportedSymptoms,
    required List<String> activeMeds,
    required String lang,
  }) {
    final rules = riskScoresData['rules'] as List<dynamic>? ?? [];
    final results = <RiskScoreResult>[];
    final langKey = ['en', 'hi', 'mr'].contains(lang) ? lang : 'en';

    for (var rule in rules) {
      final ruleId = rule['id'] ?? '';
      final nutrient = rule['nutrient'] ?? '';
      final displayNames = rule['display_name'] as Map<String, dynamic>? ?? {};
      final displayName = displayNames[langKey] ?? displayNames['en'] ?? nutrient;

      int totalPoints = 0;
      final breakdown = <RuleBreakdownFactor>[];

      final factors = rule['factors'] as List<dynamic>? ?? [];
      for (var factor in factors) {
        final fid = factor['id'] ?? '';
        final points = (factor['points'] as num?)?.toInt() ?? 0;
        final reasons = factor['reason'] as Map<String, dynamic>? ?? {};
        final reasonText = reasons[langKey] ?? reasons['en'] ?? '';

        bool conditionMet = false;

        if (fid == 'diet_veg' && ['vegetarian', 'vegan', 'jain'].contains(diet.toLowerCase())) {
          conditionMet = true;
        } else if (fid == 'tea_with_meals' && teaWithMeals) {
          conditionMet = true;
        } else if (fid == 'symptom_fatigue' && reportedSymptoms.contains('fatigue')) {
          conditionMet = true;
        } else if (fid == 'symptom_breathless' && reportedSymptoms.contains('breathlessness_on_stairs')) {
          conditionMet = true;
        } else if (fid == 'symptom_hairfall' && reportedSymptoms.contains('hair_fall')) {
          conditionMet = true;
        } else if (fid == 'heavy_bleeding' && heavyFlow) {
          conditionMet = true;
        } else if (fid == 'sun_exposure_low' && sunlight.toLowerCase() == 'low') {
          conditionMet = true;
        } else if (fid == 'covered_clothing' && clothing.toLowerCase() == 'full') {
          conditionMet = true;
        } else if (fid == 'symptom_bone_pain' && (reportedSymptoms.contains('bone_joint_pain') || reportedSymptoms.contains('knee_pain'))) {
          conditionMet = true;
        } else if (fid == 'symptom_muscle_weak' && reportedSymptoms.contains('muscle_ache')) {
          conditionMet = true;
        } else if (fid == 'age_above_50' && age >= 50) {
          conditionMet = true;
        } else if (fid == 'strict_veg' && ['vegetarian', 'vegan', 'jain'].contains(diet.toLowerCase())) {
          conditionMet = true;
        } else if (fid == 'symptom_tingling' && (reportedSymptoms.contains('tingling_numbness') || reportedSymptoms.contains('burning_soles'))) {
          conditionMet = true;
        } else if (fid == 'symptom_brain_fog' && (reportedSymptoms.contains('brain_fog') || reportedSymptoms.contains('forgetfulness'))) {
          conditionMet = true;
        } else if (fid == 'antacid_use' && activeMeds.any((m) => m.toLowerCase().contains('prazole') || m.toLowerCase().contains('pan-d'))) {
          conditionMet = true;
        } else if (fid == 'metformin_use' && activeMeds.any((m) => m.toLowerCase().contains('metformin') || m.toLowerCase().contains('glycomet'))) {
          conditionMet = true;
        } else if (fid == 'sleep_trouble' && reportedSymptoms.contains('sleep_trouble')) {
          conditionMet = true;
        } else if (fid == 'symptom_palpitations' && reportedSymptoms.contains('palpitations')) {
          conditionMet = true;
        } else if (fid == 'muscle_cramps' && (reportedSymptoms.contains('leg_pain_cramps') || reportedSymptoms.contains('leg_pain'))) {
          conditionMet = true;
        }

        if (conditionMet) {
          totalPoints += points;
          breakdown.add(RuleBreakdownFactor(id: fid, points: points, reason: reasonText));
        }
      }

      final thresholds = rule['thresholds'] as Map<String, dynamic>? ?? {};
      final medThreshold = (thresholds['medium'] as num?)?.toInt() ?? 3;
      final highThreshold = (thresholds['high'] as num?)?.toInt() ?? 6;

      String level = 'low';
      if (totalPoints >= highThreshold) {
        level = 'high';
      } else if (totalPoints >= medThreshold) {
        level = 'medium';
      }

      final tests = (rule['tests_to_discuss'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();
      final foodsObj = rule['regional_foods'] as Map<String, dynamic>? ?? {};
      final isVeg = ['vegetarian', 'vegan', 'jain'].contains(diet.toLowerCase());
      final foodList = ((isVeg ? foodsObj['veg'] : foodsObj['non_veg']) as List<dynamic>? ?? []).map((e) => e.toString()).toList();

      final whyMidlifeObj = rule['why_midlife'] as Map<String, dynamic>? ?? {};
      final whyText = whyMidlifeObj[langKey] ?? whyMidlifeObj['en'] ?? '';

      results.add(RiskScoreResult(
        id: ruleId,
        nutrient: nutrient,
        displayName: displayName,
        totalScore: totalPoints,
        level: level,
        breakdown: breakdown,
        testsToDiscuss: tests,
        suggestedFoods: foodList,
        whyMidlife: whyText,
      ));
    }

    return results;
  }

  /// Calculates the 8 petals for Nutri-Bloom
  List<NutriBloomPetalData> calculateBloomPetals({
    required List<RiskScoreResult> risks,
    required String lang,
  }) {
    // 8 Petals: Iron, Calcium, B12, Vit D, Magnesium, Protein, Vit C, Fibre
    final petalsConfig = [
      {'id': 'iron', 'key': 'petal_iron', 'angle': 0.0, 'riskId': 'anaemia', 'defaultFoods': ['Nachni (Ragi) Bhakri', 'Methi Sabzi with Lemon', 'Sprouted Matki']},
      {'id': 'calcium', 'key': 'petal_calcium', 'angle': 0.785, 'riskId': 'calcium', 'defaultFoods': ['White Til Ladoo', 'Homemade Curd', 'Makhana']},
      {'id': 'b12', 'key': 'petal_b12', 'angle': 1.57, 'riskId': 'vit_b12', 'defaultFoods': ['Fresh Paneer', 'Spiced Chaas', 'Fortified Curd']},
      {'id': 'vit_d', 'key': 'petal_vit_d', 'angle': 2.356, 'riskId': 'vit_d', 'defaultFoods': ['Fortified Cow Milk', 'Mushrooms', 'Egg Yolk']},
      {'id': 'magnesium', 'key': 'petal_magnesium', 'angle': 3.141, 'riskId': 'magnesium', 'defaultFoods': ['Pumpkin Seeds', 'Badam (Almonds)', 'Palak Dal']},
      {'id': 'protein', 'key': 'petal_protein', 'angle': 3.926, 'riskId': 'protein', 'defaultFoods': ['Sprouted Moong Usal', 'Paneer', 'Besan Pithla']},
      {'id': 'vit_c', 'key': 'petal_vit_c', 'angle': 4.712, 'riskId': 'vit_c', 'defaultFoods': ['Fresh Amla', 'Guava (Peru)', 'Lemon in Dal']},
      {'id': 'fibre', 'key': 'petal_fibre', 'angle': 5.497, 'riskId': 'fibre', 'defaultFoods': ['Jowar Bhakri', 'Cucumber Kosambari', 'Papaya']},
    ];

    final output = <NutriBloomPetalData>[];

    for (var cfg in petalsConfig) {
      final pid = cfg['id'] as String;
      final key = cfg['key'] as String;
      final angle = cfg['angle'] as double;
      final riskId = cfg['riskId'] as String;
      final defFoods = cfg['defaultFoods'] as List<String>;

      final matchingRisk = risks.where((r) => r.id == riskId).firstOrNull;

      double score = 0.85; // Default healthy fill
      String status = 'ok';

      if (matchingRisk != null) {
        if (matchingRisk.level == 'high') {
          score = 0.35;
          status = 'alert';
        } else if (matchingRisk.level == 'medium') {
          score = 0.60;
          status = 'watch';
        } else {
          score = 0.90;
          status = 'ok';
        }
      }

      output.add(NutriBloomPetalData(
        nutrientId: pid,
        nameKey: key,
        score: score,
        status: status,
        angle: angle,
        topFoods: matchingRisk?.suggestedFoods.isNotEmpty == true ? matchingRisk!.suggestedFoods : defFoods,
        whyMatters: matchingRisk?.whyMidlife ?? 'Essential mineral for vitality, mood stabilization and bone density in midlife.',
      ));
    }

    return output;
  }

  /// STRAW+10 Stage Estimator
  Map<String, dynamic> estimateStrawStage({
    required int age,
    required int monthsSinceLastPeriod,
    required int cycleLengthVarianceDays,
    required String lang,
  }) {
    final stages = strawStagesData['stages'] as List<dynamic>? ?? [];
    final langKey = ['en', 'hi', 'mr'].contains(lang) ? lang : 'en';

    String matchedStageId = 'premenopause';
    if (monthsSinceLastPeriod >= 12) {
      matchedStageId = 'postmenopause';
    } else if (monthsSinceLastPeriod >= 2 || cycleLengthVarianceDays >= 60) {
      matchedStageId = 'late_perimenopause';
    } else if (cycleLengthVarianceDays >= 7 || age >= 45) {
      matchedStageId = 'early_perimenopause';
    }

    final matched = stages.firstWhere(
      (s) => s['id'] == matchedStageId,
      orElse: () => stages.first,
    );

    final names = matched['name'] as Map<String, dynamic>? ?? {};
    final descs = matched['description'] as Map<String, dynamic>? ?? {};

    return {
      'stage_id': matchedStageId,
      'name': names[langKey] ?? names['en'] ?? '',
      'description': descs[langKey] ?? descs['en'] ?? '',
      'criteria': matched['clinical_criteria'] ?? '',
    };
  }
}
