import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart';

class GoalScreen extends StatefulWidget {
  final String name;
  final String username;
  final String password;
  final int age;
  final double weight;
  final double height;
  final String gender;
  final String activityLevel;

  const GoalScreen({
    super.key,
    required this.name,
    required this.username,
    required this.password,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.activityLevel,
  });

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  String _goal = 'lose_fat';
  bool _loading = false;
  String? _error;

  Future<void> _createAccount() async {
    setState(() { _loading = true; _error = null; });
    final user = UserModel(
      username: widget.username,
      password: widget.password,
      name: widget.name,
      age: widget.age,
      weight: widget.weight,
      height: widget.height,
      gender: widget.gender,
      activityLevel: widget.activityLevel,
      goal: _goal,
    );
    final err = await AuthService.register(user);
    setState(() => _loading = false);
    if (err != null) {
      setState(() => _error = err);
    } else {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen(user: user)),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Your Goal', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StepIndicator(current: 3, total: 3),
              const SizedBox(height: 28),
              const Text('What\'s Your Goal?', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const Text('This shapes your workout & nutrition plan', style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 40),

              _GoalCard(
                title: 'Lose Fat',
                subtitle: 'Burn calories and get lean through cardio-focused workouts and a calorie deficit diet.',
                icon: '🔥',
                color: const Color(0xFFFF6B35),
                selected: _goal == 'lose_fat',
                onTap: () => setState(() => _goal = 'lose_fat'),
                bullets: ['High-intensity cardio training', 'Calorie deficit nutrition plan', 'Lean protein focus'],
              ),
              const SizedBox(height: 20),
              _GoalCard(
                title: 'Build Muscle',
                subtitle: 'Gain strength and size with progressive overload training and a calorie surplus diet.',
                icon: '💪',
                color: const Color(0xFF1DB954),
                selected: _goal == 'build_muscle',
                onTap: () => setState(() => _goal = 'build_muscle'),
                bullets: ['Progressive overload lifting', 'Calorie surplus nutrition plan', 'High protein intake'],
              ),

              const Spacer(),
              if (_error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                ),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _createAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1DB954),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Create My Plan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  final List<String> bullets;

  const _GoalCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
    required this.bullets,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.12) : const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? color : Colors.transparent, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(icon, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Text(title, style: TextStyle(color: selected ? color : Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const Spacer(),
              Icon(selected ? Icons.check_circle : Icons.circle_outlined, color: selected ? color : Colors.grey),
            ]),
            const SizedBox(height: 10),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 14),
            ...bullets.map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(children: [
                Icon(Icons.check, color: color, size: 16),
                const SizedBox(width: 8),
                Text(b, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ]),
            )),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int current;
  final int total;
  const _StepIndicator({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final active = i + 1 <= current;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 6),
            height: 4,
            decoration: BoxDecoration(
              color: active ? const Color(0xFF1DB954) : const Color(0xFF1A2332),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
