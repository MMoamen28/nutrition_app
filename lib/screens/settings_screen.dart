import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onUserUpdated;
  const SettingsScreen({super.key, required this.user, required this.onUserUpdated});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _wCtrl;
  late String _goal;
  late String _activity;
  bool _saving = false;

  final Map<String, String> _actLabels = {
    'sedentary': 'Sedentary (desk job, no exercise)',
    'light': 'Light (1–2 days/week)',
    'moderate': 'Moderate (3–4 days/week)',
    'active': 'Active (5–6 days/week)',
    'very_active': 'Very Active (athlete / daily)',
  };

  @override
  void initState() {
    super.initState();
    _wCtrl = TextEditingController(text: widget.user.weight.toStringAsFixed(1));
    _goal = widget.user.goal;
    _activity = widget.user.activityLevel;
  }

  @override
  void dispose() { _wCtrl.dispose(); super.dispose(); }

  String _todayStr() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  Future<void> _save() async {
    final newW = double.tryParse(_wCtrl.text.trim());
    if (newW == null || newW < 30 || newW > 300) {
      _snack('Enter a valid weight (30–300 kg)', err: true); return;
    }
    setState(() => _saving = true);
    final u = widget.user;
    final wChanged = newW != u.weight;
    u.weight = newW; u.goal = _goal; u.activityLevel = _activity;
    if (wChanged) {
      final today = _todayStr();
      u.weightLog.removeWhere((e) => e.date == today);
      u.weightLog.add(WeightEntry(weight: newW, date: today));
      if (u.weightLog.length > 60) u.weightLog.removeAt(0);
    }
    u.caloriesConsumedToday = 0;
    await AuthService.updateUser(u);
    widget.onUserUpdated(u);
    setState(() => _saving = false);
    _snack('Settings saved! Targets recalculated.');
  }

  Future<void> _resetCals() async {
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFF1A2332),
      title: const Text('Reset Daily Calories', style: TextStyle(color: Colors.white)),
      content: const Text('Reset today\'s calories and food log to zero?', style: TextStyle(color: Colors.grey)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Reset', style: TextStyle(color: Colors.red))),
      ],
    ));
    if (ok != true) return;
    final today = _todayStr();
    widget.user.caloriesConsumedToday = 0;
    widget.user.foodLog.removeWhere((e) => e.date == today);
    await AuthService.updateUser(widget.user);
    widget.onUserUpdated(widget.user);
    _snack('Daily calories reset to 0');
  }

  void _snack(String msg, {bool err = false}) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: err ? Colors.red.shade700 : const Color(0xFF1DB954),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ));

  @override
  Widget build(BuildContext context) {
    final preview = UserModel(
      username: widget.user.username, password: '', name: '', age: widget.user.age,
      weight: double.tryParse(_wCtrl.text) ?? widget.user.weight,
      height: widget.user.height, gender: widget.user.gender,
      activityLevel: _activity, goal: _goal,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('⚙️ Settings', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const Text('Update your profile to recalculate targets', style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 24),

        // Weight
        _hdr('Current Weight', Icons.monitor_weight_outlined, const Color(0xFF1DB954)),
        const SizedBox(height: 10),
        TextField(
          controller: _wCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            suffixText: 'kg', suffixStyle: const TextStyle(color: Colors.grey),
            filled: true, fillColor: const Color(0xFF1A2332),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF1DB954))),
          ),
        ),
        const SizedBox(height: 6),
        Text('Previous: ${widget.user.weight.toStringAsFixed(1)} kg', style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 20),

        // Goal
        _hdr('Goal', Icons.flag_outlined, const Color(0xFFFF6B35)),
        const SizedBox(height: 10),
        Row(children: [
          _GoalBtn(label: '🔥  Lose Fat', sel: _goal == 'lose_fat', color: const Color(0xFFFF6B35), onTap: () => setState(() => _goal = 'lose_fat')),
          const SizedBox(width: 12),
          _GoalBtn(label: '💪  Build Muscle', sel: _goal == 'build_muscle', color: const Color(0xFF1DB954), onTap: () => setState(() => _goal = 'build_muscle')),
        ]),
        const SizedBox(height: 20),

        // Activity
        _hdr('Activity Level', Icons.directions_run, const Color(0xFF64B5F6)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(14)),
          child: Column(children: _actLabels.entries.map((e) {
            final sel = _activity == e.key;
            return InkWell(
              onTap: () => setState(() => _activity = e.key),
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                child: Row(children: [
                  Icon(sel ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: sel ? const Color(0xFF1DB954) : Colors.grey, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(e.value, style: TextStyle(color: sel ? Colors.white : Colors.grey, fontSize: 13))),
                ]),
              ),
            );
          }).toList()),
        ),
        const SizedBox(height: 20),

        // Live preview
        _hdr('New Targets Preview', Icons.calculate_outlined, const Color(0xFFFFD700)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1DB954).withOpacity(0.06), borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF1DB954).withOpacity(0.25)),
          ),
          child: Column(children: [
            _prev('Calories', '${preview.dailyCalorieTarget.round()} kcal', const Color(0xFF1DB954)),
            const SizedBox(height: 8),
            _prev('Protein', '${preview.dailyProteinTarget.round()} g', const Color(0xFFFF6B35)),
            const SizedBox(height: 8),
            _prev('Carbs', '${preview.dailyCarbTarget.round()} g', const Color(0xFFFFD700)),
            const SizedBox(height: 8),
            _prev('Fat', '${preview.dailyFatTarget.round()} g', const Color(0xFF64B5F6)),
            const SizedBox(height: 8),
            _prev('TDEE', '${preview.tdee.round()} kcal', Colors.white54),
          ]),
        ),
        const SizedBox(height: 8),
        const Text('⚠️ Saving resets today\'s calorie counter so new targets apply immediately.',
            style: TextStyle(color: Colors.orange, fontSize: 12)),
        const SizedBox(height: 20),

        // Save
        SizedBox(width: double.infinity, height: 52,
          child: ElevatedButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.save_outlined, color: Colors.white),
            label: Text(_saving ? 'Saving...' : 'Save Changes',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1DB954),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(width: double.infinity, height: 52,
          child: OutlinedButton.icon(
            onPressed: _resetCals,
            icon: const Icon(Icons.refresh, color: Colors.orange),
            label: const Text('Reset Daily Calories', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.orange),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          ),
        ),
        const SizedBox(height: 30),
      ]),
    );
  }

  Widget _hdr(String t, IconData i, Color c) => Row(children: [
    Icon(i, color: c, size: 18), const SizedBox(width: 8),
    Text(t, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
  ]);

  Widget _prev(String l, String v, Color c) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(l, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      Text(v, style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w600)),
    ],
  );
}

class _GoalBtn extends StatelessWidget {
  final String label; final bool sel; final Color color; final VoidCallback onTap;
  const _GoalBtn({required this.label, required this.sel, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => Expanded(child: GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: sel ? color.withOpacity(0.15) : const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: sel ? color : Colors.transparent, width: 2),
      ),
      child: Text(label, textAlign: TextAlign.center,
          style: TextStyle(color: sel ? color : Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
    ),
  ));
}
