import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final activityLabels = {
      'sedentary': 'Sedentary', 'light': 'Light', 'moderate': 'Moderate',
      'active': 'Active', 'very_active': 'Very Active',
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Avatar
        Center(child: Column(children: [
          Container(
            width: 82, height: 82,
            decoration: BoxDecoration(
              color: const Color(0xFF1DB954).withOpacity(0.15), shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF1DB954).withOpacity(0.5), width: 2.5),
            ),
            child: Center(child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: const TextStyle(color: Color(0xFF1DB954), fontSize: 36, fontWeight: FontWeight.bold),
            )),
          ),
          const SizedBox(height: 12),
          Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('@${user.username}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 8),
          // Plan badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: user.isPro ? const Color(0xFFFFD700).withOpacity(0.12) : const Color(0xFF1DB954).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: user.isPro ? const Color(0xFFFFD700).withOpacity(0.5) : const Color(0xFF1DB954).withOpacity(0.4)),
            ),
            child: Text(
              user.isPro ? '👑 Pro Plan · Expires ${user.proExpiryDisplay}' : '🆓 Free Plan',
              style: TextStyle(color: user.isPro ? const Color(0xFFFFD700) : const Color(0xFF1DB954), fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1DB954).withOpacity(0.1), borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF1DB954).withOpacity(0.3)),
            ),
            child: Text(
              user.goal == 'lose_fat' ? '🔥 Fat Loss Program' : '💪 Muscle Building Program',
              style: const TextStyle(color: Color(0xFF1DB954), fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
        ])),
        const SizedBox(height: 24),

        // Stats grid
        _sec('Body Stats'),
        const SizedBox(height: 10),
        Row(children: [
          _StatCard('Age', '${user.age} yrs', Icons.cake_outlined, const Color(0xFF64B5F6)),
          const SizedBox(width: 10),
          _StatCard('Weight', '${user.weight.toStringAsFixed(1)} kg', Icons.monitor_weight_outlined, const Color(0xFF1DB954)),
          const SizedBox(width: 10),
          _StatCard('Height', '${user.height.round()} cm', Icons.straighten, const Color(0xFFFFD700)),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          _StatCard('BMI', user.bmi.toStringAsFixed(1), Icons.accessibility_new, const Color(0xFFFF6B35)),
          const SizedBox(width: 10),
          _StatCard(user.bmiCategory, '', Icons.info_outline, const Color(0xFF9C27B0)),
          const SizedBox(width: 10),
          _StatCard('Gender', user.gender[0].toUpperCase() + user.gender.substring(1), Icons.person_outline, const Color(0xFF26C6DA)),
        ]),
        const SizedBox(height: 20),

        // Daily targets
        _sec('Daily Targets'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(16)),
          child: Column(children: [
            _tRow('Calories', '${user.dailyCalorieTarget.round()} kcal', const Color(0xFF1DB954)),
            const Divider(color: Color(0xFF263040), height: 20),
            _tRow('Protein', '${user.dailyProteinTarget.round()} g', const Color(0xFFFF6B35)),
            const Divider(color: Color(0xFF263040), height: 20),
            _tRow('Carbs', '${user.dailyCarbTarget.round()} g', const Color(0xFFFFD700)),
            const Divider(color: Color(0xFF263040), height: 20),
            _tRow('Fat', '${user.dailyFatTarget.round()} g', const Color(0xFF64B5F6)),
            const Divider(color: Color(0xFF263040), height: 20),
            _tRow('BMR', '${user.bmr.round()} kcal', Colors.white54),
            const Divider(color: Color(0xFF263040), height: 20),
            _tRow('TDEE', '${user.tdee.round()} kcal', Colors.white54),
          ]),
        ),
        const SizedBox(height: 20),

        // Activity
        _sec('Activity Level'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            const Icon(Icons.directions_run, color: Color(0xFF1DB954), size: 22),
            const SizedBox(width: 12),
            Text(activityLabels[user.activityLevel] ?? user.activityLevel,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
            const Spacer(),
            Text('×${user.activityMultiplier.toStringAsFixed(3)}',
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 20),

        // Weight progress chart
        if (user.weightLog.length >= 2) ...[
          _sec('Weight Progress'),
          const SizedBox(height: 10),
          _WeightChart(entries: user.weightLog),
          const SizedBox(height: 20),
        ],

        // Recent meals
        if (user.foodLog.isNotEmpty) ...[
          _sec('Recent Meals'),
          const SizedBox(height: 10),
          ...user.foodLog.reversed.take(8).map((e) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Container(width: 34, height: 34,
                decoration: BoxDecoration(color: const Color(0xFF1DB954).withOpacity(0.1), borderRadius: BorderRadius.circular(9)),
                child: const Icon(Icons.restaurant, color: Color(0xFF1DB954), size: 18)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(e.foodName, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                Text('${e.grams.round()}g · ${e.date} ${e.time}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('${e.calories.round()} kcal', style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                Text('P: ${e.protein.round()}g', style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 10)),
              ]),
            ]),
          )),
          const SizedBox(height: 10),
        ],
      ]),
    );
  }

  Widget _sec(String t) => Text(t, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold));

  Widget _tRow(String l, String v, Color c) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(l, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      Text(v, style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w600)),
    ],
  );
}

class _WeightChart extends StatelessWidget {
  final List<WeightEntry> entries;
  const _WeightChart({required this.entries});
  @override
  Widget build(BuildContext context) {
    final spots = entries.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.weight)).toList();
    final minY = entries.map((e) => e.weight).reduce((a, b) => a < b ? a : b) - 2;
    final maxY = entries.map((e) => e.weight).reduce((a, b) => a > b ? a : b) + 2;
    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(0, 16, 16, 8),
      decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(16)),
      child: LineChart(LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(color: const Color(0xFF263040), strokeWidth: 1)),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 42,
              getTitlesWidget: (v, _) => Text('${v.round()}kg', style: const TextStyle(color: Colors.grey, fontSize: 10)))),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true,
              getTitlesWidget: (v, _) {
                final i = v.round();
                if (i < 0 || i >= entries.length) return const SizedBox();
                final parts = entries[i].date.split('-');
                if (parts.length < 3) return const SizedBox();
                return Text('${parts[2]}/${parts[1]}', style: const TextStyle(color: Colors.grey, fontSize: 9));
              })),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minY: minY, maxY: maxY,
        lineBarsData: [LineChartBarData(
          spots: spots, isCurved: true, color: const Color(0xFF1DB954), barWidth: 3,
          dotData: FlDotData(show: true, getDotPainter: (_, __, ___, ____) =>
              FlDotCirclePainter(radius: 4, color: const Color(0xFF1DB954), strokeWidth: 2, strokeColor: Colors.white)),
          belowBarData: BarAreaData(show: true, color: const Color(0xFF1DB954).withOpacity(0.1)),
        )],
      )),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatCard(this.label, this.value, this.icon, this.color);
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
    decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25))),
    child: Column(children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(height: 6),
      if (value.isNotEmpty) Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10), textAlign: TextAlign.center),
    ]),
  ));
}
