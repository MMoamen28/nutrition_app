import 'package:flutter/material.dart';
import '../models/user_model.dart';

class HomeTab extends StatelessWidget {
  final UserModel user;
  const HomeTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final target = user.dailyCalorieTarget;
    final consumed = user.caloriesConsumedToday;
    final remaining = user.remainingCalories;
    final progress = (consumed / target).clamp(0.0, 1.0);
    final todayLog = user.todayFoodLog;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Hello, ${user.name.split(' ').first} 👋',
            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(user.goal == 'lose_fat' ? '🔥 Fat Loss Program' : '💪 Muscle Building Program',
            style: const TextStyle(color: Color(0xFF1DB954), fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),

        // Plan badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: user.isPro ? const Color(0xFFFFD700).withOpacity(0.1) : const Color(0xFF1A2332),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: user.isPro ? const Color(0xFFFFD700).withOpacity(0.4) : const Color(0xFF263040)),
          ),
          child: Row(children: [
            Text(user.isPro ? '👑' : '🆓', style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(child: Text(
              user.isPro ? 'Pro Plan Active · Full access unlocked' : 'Free Plan · Upgrade to unlock all features',
              style: TextStyle(color: user.isPro ? const Color(0xFFFFD700) : Colors.grey, fontSize: 12),
            )),
            Row(children: [
              const Text('🪙', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text('${user.walletBalance.round()}',
                  style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 14)),
            ]),
          ]),
        ),
        const SizedBox(height: 16),

        // Calorie ring
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF1A2332), Color(0xFF1E2D40)],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(children: [
            const Text('Daily Calories', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 16),
            Stack(alignment: Alignment.center, children: [
              SizedBox(width: 140, height: 140,
                child: CircularProgressIndicator(value: progress, strokeWidth: 12,
                  backgroundColor: const Color(0xFF263040),
                  valueColor: AlwaysStoppedAnimation<Color>(progress >= 1.0 ? Colors.orange : const Color(0xFF1DB954)))),
              Column(children: [
                Text(consumed.round().toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                const Text('kcal eaten', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ]),
            ]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _CI('Target', '${target.round()} kcal', Colors.white70),
              _CI(remaining >= 0 ? 'Remaining' : 'Over by',
                  '${remaining.abs().round()} kcal',
                  remaining >= 0 ? const Color(0xFF1DB954) : Colors.orange),
              _CI('Burned (est.)', '${(user.bmr * 0.2).round()} kcal', Colors.blue.shade300),
            ]),
          ]),
        ),
        const SizedBox(height: 14),

        // Macros
        Row(children: [
          _MC('Protein', '${user.dailyProteinTarget.round()}g', Icons.egg_alt_outlined, const Color(0xFFFF6B35)),
          const SizedBox(width: 10),
          _MC('Carbs', '${user.dailyCarbTarget.round()}g', Icons.grain, const Color(0xFFFFD700)),
          const SizedBox(width: 10),
          _MC('Fat', '${user.dailyFatTarget.round()}g', Icons.water_drop_outlined, const Color(0xFF64B5F6)),
        ]),
        const SizedBox(height: 14),

        // Stats
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(18)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Your Stats', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            Row(children: [
              _SI('BMI', user.bmi.toStringAsFixed(1), user.bmiCategory),
              _SI('BMR', '${user.bmr.round()} kcal', 'Basal rate'),
              _SI('TDEE', '${user.tdee.round()} kcal', 'With activity'),
              _SI('Weight', '${user.weight.toStringAsFixed(1)} kg', 'Current'),
            ]),
          ]),
        ),
        const SizedBox(height: 14),

        // Today food preview
        if (todayLog.isNotEmpty) ...[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Today's Meals",
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            Text('${todayLog.length} items', style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ]),
          const SizedBox(height: 10),
          ...todayLog.take(3).map((e) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              const Icon(Icons.restaurant, color: Color(0xFF1DB954), size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text(e.foodName, style: const TextStyle(color: Colors.white, fontSize: 13))),
              Text('${e.calories.round()} kcal', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(width: 8),
              Text(e.time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ]),
          )),
          if (todayLog.length > 3)
            Padding(padding: const EdgeInsets.only(top: 4),
              child: Text('+${todayLog.length - 3} more in Scan tab',
                  style: const TextStyle(color: Colors.grey, fontSize: 12))),
          const SizedBox(height: 14),
        ],

        // Tip
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1DB954).withOpacity(0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF1DB954).withOpacity(0.3)),
          ),
          child: Row(children: [
            const Text('💡', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(child: Text(
              user.goal == 'lose_fat'
                  ? 'Stay in a 500 kcal deficit daily to lose ~0.5kg/week. Log meals to stay accurate.'
                  : 'Eat ${user.dailyCalorieTarget.round()} kcal daily. Hit your protein target to maximize muscle growth.',
              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
            )),
          ]),
        ),
        const SizedBox(height: 20),
      ]),
    );
  }
}

class _CI extends StatelessWidget {
  final String l, v; final Color c;
  const _CI(this.l, this.v, this.c);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(v, style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 14)),
    Text(l, style: const TextStyle(color: Colors.grey, fontSize: 11)),
  ]);
}

class _MC extends StatelessWidget {
  final String l, v; final IconData i; final Color c;
  const _MC(this.l, this.v, this.i, this.c);
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
    decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.withOpacity(0.3))),
    child: Column(children: [
      Icon(i, color: c, size: 20), const SizedBox(height: 5),
      Text(v, style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 15)),
      Text(l, style: const TextStyle(color: Colors.grey, fontSize: 11)),
    ]),
  ));
}

class _SI extends StatelessWidget {
  final String l, v, s;
  const _SI(this.l, this.v, this.s);
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [
    Text(l, style: const TextStyle(color: Colors.grey, fontSize: 10)),
    const SizedBox(height: 3),
    Text(v, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center),
    Text(s, style: const TextStyle(color: Colors.grey, fontSize: 9), textAlign: TextAlign.center),
  ]));
}
