import 'package:flutter/material.dart';
import 'goal_screen.dart';

class PersonalDataScreen extends StatefulWidget {
  final String name;
  final String username;
  final String password;

  const PersonalDataScreen({
    super.key,
    required this.name,
    required this.username,
    required this.password,
  });

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  final _ageCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  String _gender = 'male';
  String _activity = 'moderate';
  String? _error;

  final Map<String, String> _activityLabels = {
    'sedentary': 'Sedentary (desk job, no exercise)',
    'light': 'Light (1–2 days/week)',
    'moderate': 'Moderate (3–4 days/week)',
    'active': 'Active (5–6 days/week)',
    'very_active': 'Very Active (athlete / daily)',
  };

  void _next() {
    final ageText = _ageCtrl.text.trim();
    final weightText = _weightCtrl.text.trim();
    final heightText = _heightCtrl.text.trim();

    if (ageText.isEmpty || weightText.isEmpty || heightText.isEmpty) {
      setState(() => _error = 'Please fill in all fields.');
      return;
    }
    final age = int.tryParse(ageText);
    final weight = double.tryParse(weightText);
    final height = double.tryParse(heightText);

    if (age == null || age < 10 || age > 100) {
      setState(() => _error = 'Enter a valid age (10–100).');
      return;
    }
    if (weight == null || weight < 30 || weight > 300) {
      setState(() => _error = 'Enter a valid weight (30–300 kg).');
      return;
    }
    if (height == null || height < 100 || height > 250) {
      setState(() => _error = 'Enter a valid height (100–250 cm).');
      return;
    }
    setState(() => _error = null);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GoalScreen(
          name: widget.name,
          username: widget.username,
          password: widget.password,
          age: age,
          weight: weight,
          height: height,
          gender: _gender,
          activityLevel: _activity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Personal Info', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StepIndicator(current: 2, total: 3),
              const SizedBox(height: 28),
              const Text('About You', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const Text('We use this to calculate your calorie needs', style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 32),

              // Age / Weight / Height row
              Row(children: [
                Expanded(child: _buildNumField(_ageCtrl, 'Age', 'yrs')),
                const SizedBox(width: 12),
                Expanded(child: _buildNumField(_weightCtrl, 'Weight', 'kg')),
                const SizedBox(width: 12),
                Expanded(child: _buildNumField(_heightCtrl, 'Height', 'cm')),
              ]),
              const SizedBox(height: 24),

              // Gender
              const Text('Gender', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 10),
              Row(children: [
                _GenderButton(label: 'Male', icon: Icons.male, selected: _gender == 'male', onTap: () => setState(() => _gender = 'male')),
                const SizedBox(width: 12),
                _GenderButton(label: 'Female', icon: Icons.female, selected: _gender == 'female', onTap: () => setState(() => _gender = 'female')),
              ]),
              const SizedBox(height: 24),

              // Activity level
              const Text('Activity Level', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2332),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: _activityLabels.entries.map((e) {
                    final selected = _activity == e.key;
                    return InkWell(
                      onTap: () => setState(() => _activity = e.key),
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(children: [
                          Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                              color: selected ? const Color(0xFF1DB954) : Colors.grey, size: 20),
                          const SizedBox(width: 12),
                          Expanded(child: Text(e.value, style: TextStyle(color: selected ? Colors.white : Colors.grey, fontSize: 14))),
                        ]),
                      ),
                    );
                  }).toList(),
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13))),
                  ]),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1DB954),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Next', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumField(TextEditingController ctrl, String label, String unit) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        suffixText: unit,
        suffixStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        filled: true,
        fillColor: const Color(0xFF1A2332),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF1DB954))),
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _GenderButton({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF1DB954).withOpacity(0.15) : const Color(0xFF1A2332),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? const Color(0xFF1DB954) : Colors.transparent, width: 2),
          ),
          child: Column(children: [
            Icon(icon, color: selected ? const Color(0xFF1DB954) : Colors.grey, size: 28),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: selected ? const Color(0xFF1DB954) : Colors.grey, fontWeight: FontWeight.w600)),
          ]),
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
