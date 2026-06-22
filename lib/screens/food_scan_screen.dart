import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../ai_helper.dart';
import '../services/nutrition_service.dart';

class FoodScanScreen extends StatefulWidget {
  final UserModel user;
  final Function(double, FoodLogEntry) onCaloriesLogged;
  const FoodScanScreen({super.key, required this.user, required this.onCaloriesLogged});
  @override
  State<FoodScanScreen> createState() => _FoodScanScreenState();
}

class _FoodScanScreenState extends State<FoodScanScreen> {
  final AIModelHelper _ai = AIModelHelper();
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  Map<String, dynamic>? _results;
  bool _analyzing = false;
  bool _modelLoading = true;
  double _grams = 100;
  bool _logged = false;

  @override
  void initState() { super.initState(); _initModel(); }

  Future<void> _initModel() async {
    setState(() => _modelLoading = true);
    await _ai.loadModel();
    if (mounted) setState(() => _modelLoading = false);
  }

  Future<void> _capture(ImageSource src) async {
    final f = await _picker.pickImage(source: src, imageQuality: 85);
    if (f == null) return;
    final bytes = await f.readAsBytes();
    setState(() { _imageBytes = bytes; _analyzing = true; _results = null; _logged = false; });
    try {
      final r = await _ai.analyzeFood(bytes);
      if (mounted) setState(() { _results = r; _analyzing = false; });
    } catch (e) {
      if (mounted) setState(() { _results = {'food_name': 'unknown', 'confidence': '0%', 'error': e.toString()}; _analyzing = false; });
    }
  }

  void _logFood() {
    if (_results == null) return;
    final fn = (_results!['food_name'] ?? '') as String;
    final n = NutritionService.getNutrition(fn);
    if (n == null) return;
    final f = _grams / 100;
    final now = DateTime.now();
    final entry = FoodLogEntry(
      foodName: _fmt(fn), grams: _grams,
      calories: n['calories']! * f, protein: n['protein']! * f,
      carbs: n['carbs']! * f, fat: n['fat']! * f,
      time: '${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}',
      date: '${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}',
    );
    widget.onCaloriesLogged(entry.calories, entry);
    setState(() => _logged = true);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('✅ Logged ${entry.calories.round()} kcal from ${entry.foodName}'),
      backgroundColor: const Color(0xFF1DB954), behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  String _fmt(String raw) => raw.replaceAll('_', ' ').split(' ')
      .map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : w).join(' ');

  @override
  Widget build(BuildContext context) {
    final remaining = widget.user.remainingCalories;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('🔍 Scan Your Food', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Take a photo to identify food and log calories', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        const SizedBox(height: 14),

        // Model status
        if (_modelLoading) _banner(Icons.hourglass_top, 'Loading AI model...', Colors.blue.shade300, Colors.blue.withOpacity(0.1)),
        if (!_modelLoading && !_ai.isLoaded) _banner(Icons.error_outline, 'Model failed: ${_ai.loadError}', Colors.red.shade300, Colors.red.withOpacity(0.1)),
        if (!_modelLoading && _ai.isLoaded) _banner(Icons.check_circle_outline, 'AI model ready — 101 food types', const Color(0xFF1DB954), const Color(0xFF1DB954).withOpacity(0.08)),
        const SizedBox(height: 10),

        // Remaining calories
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: remaining > 0 ? const Color(0xFF1DB954).withOpacity(0.12) : Colors.orange.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: remaining > 0 ? const Color(0xFF1DB954).withOpacity(0.4) : Colors.orange.withOpacity(0.4)),
          ),
          child: Row(children: [
            Icon(remaining > 0 ? Icons.local_fire_department : Icons.warning_amber_rounded,
                color: remaining > 0 ? const Color(0xFF1DB954) : Colors.orange),
            const SizedBox(width: 10),
            Expanded(child: Text(
              remaining > 0 ? 'You can still eat ${remaining.round()} kcal today'
                  : 'Exceeded target by ${remaining.abs().round()} kcal',
              style: TextStyle(color: remaining > 0 ? const Color(0xFF1DB954) : Colors.orange, fontWeight: FontWeight.w600, fontSize: 13),
            )),
          ]),
        ),
        const SizedBox(height: 14),

        // Photo area
        GestureDetector(
          onTap: _showModal,
          child: Container(
            width: double.infinity, height: 220,
            decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF263040), width: 2)),
            child: _imageBytes != null
                ? ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.memory(_imageBytes!, fit: BoxFit.cover))
                : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFF1DB954).withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Color(0xFF1DB954), size: 38)),
                    const SizedBox(height: 14),
                    const Text('Tap to capture food', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    const Text('Supports 101 food types', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ]),
          ),
        ),
        const SizedBox(height: 12),

        Row(children: [
          Expanded(child: _SBtn(icon: Icons.camera_alt, label: 'Camera', primary: true, onTap: () => _capture(ImageSource.camera))),
          const SizedBox(width: 12),
          Expanded(child: _SBtn(icon: Icons.photo_library, label: 'Gallery', primary: false, onTap: () => _capture(ImageSource.gallery))),
        ]),
        const SizedBox(height: 18),

        if (_analyzing)
          Container(padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(16)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const CircularProgressIndicator(color: Color(0xFF1DB954), strokeWidth: 3),
              const SizedBox(height: 14),
              const Text('Analyzing your food...', style: TextStyle(color: Colors.white, fontSize: 15)),
              Text('Running AI model on device', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ])),

        if (_results != null && !_analyzing) ...[
          if (_results!.containsKey('error'))
            _banner(Icons.error_outline, 'Could not analyze: ${_results!['error']}', Colors.red.shade300, Colors.red.withOpacity(0.1))
          else
            _buildResults(),
        ],

        if (widget.user.todayFoodLog.isNotEmpty) ...[
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Today's Food Log", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Text('${widget.user.todayFoodLog.fold(0.0, (s, e) => s + e.calories).round()} kcal total',
                style: const TextStyle(color: Color(0xFF1DB954), fontSize: 13, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 10),
          ...widget.user.todayFoodLog.map((e) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Container(width: 38, height: 38,
                decoration: BoxDecoration(color: const Color(0xFF1DB954).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.restaurant, color: Color(0xFF1DB954), size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(e.foodName, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                Text('${e.grams.round()}g · ${e.time}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('${e.calories.round()} kcal', style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                Text('P: ${e.protein.round()}g', style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 10)),
              ]),
            ]),
          )),
        ],
      ]),
    );
  }

  Widget _banner(IconData icon, String msg, Color ic, Color bg) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
    child: Row(children: [
      Icon(icon, color: ic, size: 18), const SizedBox(width: 10),
      Expanded(child: Text(msg, style: TextStyle(color: ic, fontSize: 12))),
    ]),
  );

  Widget _buildResults() {
    final fn = _results!['food_name'] ?? 'Unknown';
    final conf = _results!['confidence'] ?? '0%';
    final n = NutritionService.getNutrition(fn);
    final cals = NutritionService.calculateCalories(fn, _grams);
    final rem = widget.user.remainingCalories;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFF1DB954).withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.restaurant, color: Color(0xFF1DB954), size: 24)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_fmt(fn), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text('AI Confidence: $conf', style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ])),
        ]),
        if (n != null) ...[
          const SizedBox(height: 16),
          const Text('Per 100g', style: TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 8),
          Row(children: [
            _NB('${n['calories']!.round()} kcal', '🔥', const Color(0xFFFF6B35)),
            const SizedBox(width: 6),
            _NB('${n['protein']!.toStringAsFixed(1)}g P', '💪', const Color(0xFF1DB954)),
            const SizedBox(width: 6),
            _NB('${n['carbs']!.toStringAsFixed(1)}g C', '🍞', const Color(0xFFFFD700)),
            const SizedBox(width: 6),
            _NB('${n['fat']!.toStringAsFixed(1)}g F', '🥑', const Color(0xFF64B5F6)),
          ]),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Portion Size', style: TextStyle(color: Colors.grey, fontSize: 13)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFF1DB954).withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
              child: Text('${_grams.round()} g', style: const TextStyle(color: Color(0xFF1DB954), fontWeight: FontWeight.bold))),
          ]),
          Slider(value: _grams, min: 50, max: 500, divisions: 90,
              activeColor: const Color(0xFF1DB954), inactiveColor: const Color(0xFF263040),
              onChanged: (v) => setState(() { _grams = v; _logged = false; })),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFF0F1923), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('For ${_grams.round()}g:', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text('${cals.round()} kcal', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Text('After logging:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 2),
                Text('${(rem - cals).round()} kcal left',
                    style: TextStyle(color: rem - cals > 0 ? const Color(0xFF1DB954) : Colors.orange,
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ]),
            ]),
          ),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, height: 50,
            child: ElevatedButton.icon(
              onPressed: _logged ? null : _logFood,
              icon: Icon(_logged ? Icons.check_circle : Icons.add_circle_outline, color: Colors.white),
              label: Text(_logged ? 'Logged ✓' : 'Log This Meal',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _logged ? Colors.grey.shade700 : const Color(0xFF1DB954),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            )),
        ] else ...[
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              const Icon(Icons.info_outline, color: Colors.orange, size: 18), const SizedBox(width: 8),
              Expanded(child: Text('No nutrition data for "${_fmt(fn)}". Try scanning again.',
                  style: const TextStyle(color: Colors.orange, fontSize: 13))),
            ])),
        ],
      ]),
    );
  }

  void _showModal() => showModalBottomSheet(
    context: context, backgroundColor: const Color(0xFF1A2332),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('Select Image Source', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 24),
      Row(children: [
        Expanded(child: _SBtn(icon: Icons.camera_alt, label: 'Camera', primary: true, onTap: () { Navigator.pop(context); _capture(ImageSource.camera); })),
        const SizedBox(width: 12),
        Expanded(child: _SBtn(icon: Icons.photo_library, label: 'Gallery', primary: false, onTap: () { Navigator.pop(context); _capture(ImageSource.gallery); })),
      ]),
      const SizedBox(height: 16),
    ])),
  );
}

class _SBtn extends StatelessWidget {
  final IconData icon; final String label; final bool primary; final VoidCallback onTap;
  const _SBtn({required this.icon, required this.label, required this.primary, required this.onTap});
  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, color: primary ? Colors.white : const Color(0xFF1DB954)),
    label: Text(label, style: TextStyle(color: primary ? Colors.white : const Color(0xFF1DB954), fontWeight: FontWeight.bold)),
    style: ElevatedButton.styleFrom(
      backgroundColor: primary ? const Color(0xFF1DB954) : const Color(0xFF1A2332),
      side: primary ? null : const BorderSide(color: Color(0xFF1DB954)),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}

class _NB extends StatelessWidget {
  final String text, emoji; final Color color;
  const _NB(this.text, this.emoji, this.color);
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
    child: Column(children: [
      Text(emoji, style: const TextStyle(fontSize: 16)), const SizedBox(height: 2),
      Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    ]),
  ));
}
