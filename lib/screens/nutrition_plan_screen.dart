import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/nutrition_plan_service.dart';

class NutritionPlanScreen extends StatelessWidget {
  final UserModel user;
  const NutritionPlanScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final plan = NutritionPlanService.getPlan(user);
    final isLoseFat = user.goal == 'lose_fat';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isLoseFat ? '🥗 Fat Loss Meal Plan' : '🍗 Muscle Gain Meal Plan',
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('Daily target: ${user.dailyCalorieTarget.round()} kcal',
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 20),

          // Macro overview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MacroChip('Protein', '${user.dailyProteinTarget.round()}g', const Color(0xFFFF6B35)),
                _div(),
                _MacroChip('Carbs', '${user.dailyCarbTarget.round()}g', const Color(0xFFFFD700)),
                _div(),
                _MacroChip('Fat', '${user.dailyFatTarget.round()}g', const Color(0xFF64B5F6)),
                _div(),
                _MacroChip('Calories', '${user.dailyCalorieTarget.round()}', const Color(0xFF1DB954)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Meals
          ...plan.map((meal) => _MealCard(meal: meal, isLoseFat: isLoseFat)),

          // Tips
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2332),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💧 Hydration & Tips', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 12),
                ...const [
                  'Drink at least 2.5–3 liters of water daily.',
                  'Eat slowly and stop when 80% full.',
                  'Prep your meals on Sunday to stay consistent.',
                  'Don\'t skip breakfast — it sets your metabolism.',
                ].map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('• ', style: TextStyle(color: Color(0xFF1DB954), fontSize: 18)),
                    Expanded(child: Text(t, style: const TextStyle(color: Colors.grey, fontSize: 13))),
                  ]),
                )),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _div() => Container(width: 1, height: 40, color: const Color(0xFF263040));
}

class _MacroChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MacroChip(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
    ]);
  }
}

class _MealCard extends StatefulWidget {
  final MealPlan meal;
  final bool isLoseFat;
  const _MealCard({required this.meal, required this.isLoseFat});

  @override
  State<_MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<_MealCard> {
  bool _expanded = true;

  int get _totalCals => widget.meal.items.fold(0, (s, i) => s + i.calories);
  double get _totalProtein => widget.meal.items.fold(0.0, (s, i) => s + i.protein);
  double get _totalCarbs => widget.meal.items.fold(0.0, (s, i) => s + i.carbs);
  double get _totalFat => widget.meal.items.fold(0.0, (s, i) => s + i.fat);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        // Header
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFF1DB954).withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.restaurant_menu, color: Color(0xFF1DB954), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.meal.mealName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(widget.meal.time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ]),
              ),
              Text('$_totalCals kcal', style: const TextStyle(color: Color(0xFF1DB954), fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
            ]),
          ),
        ),
        if (_expanded) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(children: [
              const Divider(color: Color(0xFF263040)),
              const SizedBox(height: 8),
              ...widget.meal.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.circle, color: Color(0xFF1DB954), size: 8),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                    Text(item.portion, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('${item.calories} kcal', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    Text('P: ${item.protein.round()}g', style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 11)),
                  ]),
                ]),
              )),
              // Meal total
              const Divider(color: Color(0xFF263040)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Meal Total', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  '${_totalCals} kcal | P: ${_totalProtein.round()}g | C: ${_totalCarbs.round()}g | F: ${_totalFat.round()}g',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ]),
            ]),
          ),
        ],
      ]),
    );
  }
}
