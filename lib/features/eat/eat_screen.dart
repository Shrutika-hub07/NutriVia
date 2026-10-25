import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';
import '../../core/services/rules_service.dart';
import 'thali_lens_screen.dart';
import 'fasting_screen.dart';

class EatScreen extends StatefulWidget {
  final String language;

  const EatScreen({super.key, required this.language});

  @override
  State<EatScreen> createState() => _EatScreenState();
}

class _EatScreenState extends State<EatScreen> {
  final ClinicalRulesService _rulesService = ClinicalRulesService();
  String searchQuery = '';
  String selectedDietFilter = 'all'; // all, veg, eggetarian, non_veg
  String selectedRegionFilter = 'all'; // all, Maharashtra, South India, Gujarat, North India
  bool budgetFilterOnly = false;

  @override
  Widget build(BuildContext context) {
    final allFoods = _rulesService.indianFoods;

    final filteredFoods = allFoods.where((food) {
      final name = (food['name'] ?? '').toString().toLowerCase();
      final localName = (food['local_name'] ?? '').toString().toLowerCase();
      final diet = (food['diet'] ?? '').toString().toLowerCase();
      final region = (food['region'] ?? '').toString().toLowerCase();

      final matchesSearch = name.contains(searchQuery.toLowerCase()) || localName.contains(searchQuery.toLowerCase());
      final matchesDiet = selectedDietFilter == 'all' || diet == selectedDietFilter;
      final matchesRegion = selectedRegionFilter == 'all' || region.contains(selectedRegionFilter.toLowerCase());

      if (!matchesSearch || !matchesDiet || !matchesRegion) return false;

      if (budgetFilterOnly) {
        // Affordable everyday staples
        final isStaple = ['nachni', 'bajra', 'jowar', 'chaas', 'curd', 'peanuts', 'til', 'gul', 'amla', 'poha', 'moong', 'spinach', 'methi']
            .any((s) => name.contains(s) || localName.contains(s));
        if (!isStaple) return false;
      }

      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Indian Midlife Nutrition'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: NutriviaColors.marigold),
            tooltip: 'Thali Lens',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ThaliLensScreen(language: widget.language)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.event_note_outlined, color: NutriviaColors.plum),
            tooltip: 'Fasting Companion',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FastingScreen(language: widget.language)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Thali Lens Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ThaliLensScreen(language: widget.language)),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [NutriviaColors.plum, NutriviaColors.deepPlum],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: NutriviaColors.marigold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_enhance_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Thali Lens: Photo Meal Logger',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Snap your plate or test 3 demo thalis',
                            style: TextStyle(color: NutriviaColors.peach, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
                  ],
                ),
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search foods (e.g. Nachni, Til, Chaas)...',
                prefixIcon: const Icon(Icons.search_rounded, color: NutriviaColors.plum),
                filled: true,
                fillColor: NutriviaColors.snow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: NutriviaColors.lavenderMist),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: NutriviaColors.lavenderMist),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              onChanged: (v) => setState(() => searchQuery = v),
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All Diets'),
                  selected: selectedDietFilter == 'all',
                  onSelected: (v) => setState(() => selectedDietFilter = 'all'),
                  selectedColor: NutriviaColors.plum,
                  labelStyle: TextStyle(color: selectedDietFilter == 'all' ? Colors.white : NutriviaColors.plum),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Veg'),
                  selected: selectedDietFilter == 'veg',
                  onSelected: (v) => setState(() => selectedDietFilter = 'veg'),
                  selectedColor: NutriviaColors.plum,
                  labelStyle: TextStyle(color: selectedDietFilter == 'veg' ? Colors.white : NutriviaColors.plum),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Non-Veg / Fish'),
                  selected: selectedDietFilter == 'non_veg',
                  onSelected: (v) => setState(() => selectedDietFilter = 'non_veg'),
                  selectedColor: NutriviaColors.plum,
                  labelStyle: TextStyle(color: selectedDietFilter == 'non_veg' ? Colors.white : NutriviaColors.plum),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Maharashtra'),
                  selected: selectedRegionFilter == 'Maharashtra',
                  onSelected: (v) => setState(() => selectedRegionFilter = v ? 'Maharashtra' : 'all'),
                  selectedColor: NutriviaColors.marigold,
                  labelStyle: TextStyle(color: selectedRegionFilter == 'Maharashtra' ? Colors.white : NutriviaColors.plum),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Affordable Staples'),
                  selected: budgetFilterOnly,
                  onSelected: (v) => setState(() => budgetFilterOnly = v),
                  selectedColor: NutriviaColors.statusOk,
                  labelStyle: TextStyle(color: budgetFilterOnly ? Colors.white : NutriviaColors.plum),
                ),
              ],
            ),
          ),

          // Food Count & Disclaimer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredFoods.length} Indian foods curated',
                  style: const TextStyle(color: NutriviaColors.stone, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const Text(
                  'Approx. values (IFCT 2017)',
                  style: TextStyle(color: NutriviaColors.stone, fontSize: 11),
                ),
              ],
            ),
          ),

          // Food Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredFoods.length,
              itemBuilder: (context, index) {
                final food = filteredFoods[index];
                return _buildFoodCard(food);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(dynamic food) {
    final iron = (food['iron_mg'] as num?)?.toDouble() ?? 0.0;
    final calcium = (food['calcium_mg'] as num?)?.toDouble() ?? 0.0;
    final protein = (food['protein_g'] as num?)?.toDouble() ?? 0.0;
    final vitC = (food['vit_c_mg'] as num?)?.toDouble() ?? 0.0;
    final hasB12 = food['b12_flag'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food['name'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum),
                      ),
                      if (food['local_name'] != null)
                        Text(
                          food['local_name'],
                          style: const TextStyle(color: NutriviaColors.terracotta, fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: NutriviaColors.lavenderMist.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    food['portion'] ?? '',
                    style: const TextStyle(fontSize: 12, color: NutriviaColors.nightPlum, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Nutrient Badges
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _buildNutrientBadge('Fe: ${iron}mg', iron >= 3.0 ? NutriviaColors.statusAlert : NutriviaColors.plum),
                _buildNutrientBadge('Ca: ${calcium.toInt()}mg', calcium >= 150 ? NutriviaColors.marigold : NutriviaColors.plum),
                _buildNutrientBadge('Prot: ${protein}g', NutriviaColors.plum),
                if (vitC > 5)
                  _buildNutrientBadge('Vit C: ${vitC.toInt()}mg', NutriviaColors.statusOk),
                if (hasB12)
                  _buildNutrientBadge('B12 Source', NutriviaColors.plum),
              ],
            ),
            const SizedBox(height: 8),

            // Clinical Absorption Note
            if (food['salt_oil_notes'] != null && food['salt_oil_notes'].toString().isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.tips_and_updates_outlined, color: NutriviaColors.marigold, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      food['salt_oil_notes'],
                      style: const TextStyle(fontSize: 12, color: NutriviaColors.stone),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11),
      ),
    );
  }
}
