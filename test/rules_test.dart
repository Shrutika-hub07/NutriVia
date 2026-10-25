import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivia_app/core/services/rules_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Clinical Rules Deterministic Verification', () {
    late ClinicalRulesService rules;

    setUp(() async {
      rules = ClinicalRulesService();
      await rules.loadAllRules();
    });

    test('Red flags trigger on critical cardiac keywords', () {
      final flagEn = rules.checkRedFlags('I feel heavy chest pain and breathlessness', 'en');
      expect(flagEn, isNotNull);
      expect(flagEn!['severity'], 'CRITICAL');
      expect(flagEn['emergency_number'], '112');

      final flagMr = rules.checkRedFlags('माझ्या छातीत दुखणे आणि धाप लागणे सुरू आहे', 'mr');
      expect(flagMr, isNotNull);
      expect(flagMr!['severity'], 'CRITICAL');

      final flagHi = rules.checkRedFlags('सीने में दर्द हो रहा है', 'hi');
      expect(flagHi, isNotNull);
      expect(flagHi!['severity'], 'CRITICAL');
    });

    test('Red flags trigger on mental health crisis with Tele-MANAS', () {
      final crisis = rules.checkRedFlags('I want to harm myself and end my life', 'en');
      expect(crisis, isNotNull);
      expect(crisis!['emergency_number'], '14416');

      final crisisMr = rules.checkRedFlags('मला जगावेसे वाटत नाही आणि आत्महत्या करावी वाटते', 'mr');
      expect(crisisMr, isNotNull);
      expect(crisisMr!['emergency_number'], '14416');
    });

    test('Sunita Persona yields High Anaemia and High Vitamin D Risk', () {
      final risks = rules.evaluateRiskScores(
        age: 52,
        diet: 'vegetarian',
        sunlight: 'low',
        clothing: 'full',
        teaWithMeals: true,
        heavyFlow: true,
        reportedSymptoms: ['fatigue', 'knee_pain', 'leg_pain_cramps', 'tingling_numbness', 'breathlessness_on_stairs', 'bone_joint_pain'],
        activeMeds: ['Iron Folic Tablet', 'Vitamin D3 Sachet'],
        lang: 'mr',
      );

      final anaemiaRisk = risks.firstWhere((r) => r.id == 'anaemia');
      expect(anaemiaRisk.level, 'high');
      expect(anaemiaRisk.totalScore, greaterThanOrEqualTo(8));
      expect(anaemiaRisk.testsToDiscuss, contains('Complete Blood Count (CBC) with Haemoglobin'));

      final vitDRisk = risks.firstWhere((r) => r.id == 'vit_d');
      expect(vitDRisk.level, 'high');
      expect(vitDRisk.totalScore, greaterThanOrEqualTo(6));

      final b12Risk = risks.firstWhere((r) => r.id == 'vit_b12');
      expect(b12Risk.level, anyOf('medium', 'high'));
    });

    test('STRAW+10 stage estimation', () {
      final latePeri = rules.estimateStrawStage(
        age: 52,
        monthsSinceLastPeriod: 8,
        cycleLengthVarianceDays: 45,
        lang: 'en',
      );
      expect(latePeri['stage_id'], 'late_perimenopause');

      final postMeno = rules.estimateStrawStage(
        age: 55,
        monthsSinceLastPeriod: 14,
        cycleLengthVarianceDays: 90,
        lang: 'en',
      );
      expect(postMeno['stage_id'], 'postmenopause');
    });

    test('Nutri-Bloom petals generation contains 8 vital minerals', () {
      final risks = rules.evaluateRiskScores(
        age: 52,
        diet: 'vegetarian',
        sunlight: 'low',
        clothing: 'full',
        teaWithMeals: true,
        heavyFlow: true,
        reportedSymptoms: ['fatigue', 'knee_pain'],
        activeMeds: [],
        lang: 'en',
      );

      final petals = rules.calculateBloomPetals(risks: risks, lang: 'en');
      expect(petals.length, 8);
      final nutrientIds = petals.map((p) => p.nutrientId).toList();
      expect(nutrientIds, containsAll(['iron', 'calcium', 'b12', 'vit_d', 'magnesium', 'protein', 'vit_c', 'fibre']));
    });
  });
}
