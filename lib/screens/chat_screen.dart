import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  final UserModel user;
  const ChatScreen({super.key, required this.user});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final List<ChatMessage> _msgs = [];
  bool _loading = false;

  static const _apiKey = 'AQ.Ab8RN6LD0dOFfnypJYXtuC0bre2ATwDwdoi7XI-ASI0XzwEvoQ';
  static const _model = 'gemini-2.5-flash';
  static const _base = 'https://generativelanguage.googleapis.com/v1/models';

  final _suggestions = const [
    {'t': 'What should I eat before workout?', 'i': '🏋️'},
    {'t': 'How much water daily?', 'i': '💧'},
    {'t': 'Best high protein snacks?', 'i': '🥚'},
    {'t': 'Best post-workout meal?', 'i': '🍗'},
    {'t': 'Can I build muscle losing fat?', 'i': '💪'},
    {'t': 'How to track calories accurately?', 'i': '📊'},
  ];

  @override
  void initState() {
    super.initState();
    _msgs.add(ChatMessage(
      text: 'Hi ${widget.user.name.split(' ').first}! 👋 I\'m your AI nutrition assistant.\n\n'
          'Goal: ${widget.user.goal == 'lose_fat' ? 'Lose Fat 🔥' : 'Build Muscle 💪'} | '
          'Target: ${widget.user.dailyCalorieTarget.round()} kcal/day\n\n'
          'Ask me anything about nutrition or fitness!',
      isUser: false,
    ));
  }

  String _systemPrompt() =>
      'You are a professional nutrition and fitness assistant in NutriTrack app.\n'
      'User: ${widget.user.name}, Age: ${widget.user.age}, Weight: ${widget.user.weight}kg, '
      'Height: ${widget.user.height}cm, Gender: ${widget.user.gender}\n'
      'Goal: ${widget.user.goal == 'lose_fat' ? 'Lose Fat' : 'Build Muscle'}, '
      'Activity: ${widget.user.activityLevel}\n'
      'Daily targets: ${widget.user.dailyCalorieTarget.round()} kcal, '
      '${widget.user.dailyProteinTarget.round()}g protein, '
      '${widget.user.dailyCarbTarget.round()}g carbs, ${widget.user.dailyFatTarget.round()}g fat\n'
      'Calories today: ${widget.user.caloriesConsumedToday.round()} / Remaining: ${widget.user.remainingCalories.round()}\n\n'
      'Give concise practical personalized advice. Keep under 200 words. Be encouraging.';

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;
    _ctrl.clear();
    setState(() { _msgs.add(ChatMessage(text: text, isUser: true)); _loading = true; });
    _scrollDown();

    try {
      final res = await http.post(
        Uri.parse('$_base/$_model:generateContent?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'system_instruction': {'parts': [{'text': _systemPrompt()}]},
          'contents': [{'role': 'user', 'parts': [{'text': text}]}],
          'generationConfig': {'temperature': 0.7, 'maxOutputTokens': 512},
        }),
      ).timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final d = json.decode(res.body);
        final reply = d['candidates'][0]['content']['parts'][0]['text'] as String;
        if (mounted) setState(() { _msgs.add(ChatMessage(text: reply.trim(), isUser: false)); _loading = false; });
      } else {
        final err = json.decode(res.body);
        _addErr('API Error ${res.statusCode}: ${err['error']?['message'] ?? 'Unknown'}');
      }
    } catch (e) {
      _addErr(e.toString().contains('Timeout')
          ? 'Request timed out. Check your internet.'
          : 'Connection error. Check your internet.');
    }
    _scrollDown();
  }

  void _addErr(String m) {
    if (mounted) setState(() { _msgs.add(ChatMessage(text: '⚠️ $m', isUser: false)); _loading = false; });
  }

  void _scrollDown() => Future.delayed(const Duration(milliseconds: 150), () {
    if (_scroll.hasClients) _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  });

  @override
  void dispose() { _ctrl.dispose(); _scroll.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Column(children: [
    // Header
    Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      decoration: const BoxDecoration(color: Color(0xFF0F1923), border: Border(bottom: BorderSide(color: Color(0xFF1A2332)))),
      child: Row(children: [
        Container(width: 40, height: 40,
          decoration: BoxDecoration(color: const Color(0xFF1DB954).withOpacity(0.12), shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF1DB954).withOpacity(0.4))),
          child: const Icon(Icons.smart_toy_outlined, color: Color(0xFF1DB954), size: 22)),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('AI Nutrition Assistant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          Row(children: [
            Container(width: 7, height: 7, margin: const EdgeInsets.only(right: 5),
                decoration: const BoxDecoration(color: Color(0xFF1DB954), shape: BoxShape.circle)),
            const Text('Online · Gemini AI', style: TextStyle(color: Colors.grey, fontSize: 11)),
          ]),
        ]),
      ]),
    ),
    // Messages
    Expanded(child: ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _msgs.length + (_loading ? 1 : 0),
      itemBuilder: (ctx, i) {
        if (i == _msgs.length) return const _TypingDots();
        final m = _msgs[i];
        final isUser = m.isUser;
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) Container(width: 30, height: 30, margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(color: const Color(0xFF1DB954).withOpacity(0.12), shape: BoxShape.circle),
                child: const Icon(Icons.smart_toy_outlined, color: Color(0xFF1DB954), size: 16)),
              Flexible(child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: isUser ? const Color(0xFF1DB954) : const Color(0xFF1A2332),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18), topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isUser ? 18 : 4), bottomRight: Radius.circular(isUser ? 4 : 18),
                  ),
                ),
                child: Text(m.text, style: TextStyle(color: isUser ? Colors.white : Colors.white70, fontSize: 14, height: 1.5)),
              )),
              if (isUser) Container(width: 30, height: 30, margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(color: const Color(0xFF1DB954).withOpacity(0.15), shape: BoxShape.circle),
                child: const Icon(Icons.person_outline, color: Color(0xFF1DB954), size: 16)),
            ],
          ),
        );
      },
    )),
    // Suggestions
    if (_msgs.length <= 2) SizedBox(height: 44, child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _suggestions.length,
      itemBuilder: (_, i) => GestureDetector(
        onTap: () => _send(_suggestions[i]['t']!),
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF1DB954).withOpacity(0.35))),
          child: Text('${_suggestions[i]['i']}  ${_suggestions[i]['t']}',
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ),
      ),
    )),
    const SizedBox(height: 8),
    // Input
    Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      decoration: const BoxDecoration(color: Color(0xFF0F1923), border: Border(top: BorderSide(color: Color(0xFF1A2332)))),
      child: Row(children: [
        Expanded(child: Container(
          decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF263040))),
          child: TextField(
            controller: _ctrl,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Ask about nutrition or fitness...', hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
              border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onSubmitted: _send,
          ),
        )),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => _send(_ctrl.text),
          child: Container(width: 46, height: 46,
              decoration: const BoxDecoration(color: Color(0xFF1DB954), shape: BoxShape.circle),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 22)),
        ),
      ]),
    ),
  ]);
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}
class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true); }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Container(width: 30, height: 30, margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(color: const Color(0xFF1DB954).withOpacity(0.12), shape: BoxShape.circle),
          child: const Icon(Icons.smart_toy_outlined, color: Color(0xFF1DB954), size: 16)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(color: const Color(0xFF1A2332),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18), bottomRight: Radius.circular(18), bottomLeft: Radius.circular(4))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [0, 200, 400].map((d) => AnimatedBuilder(
          animation: _c,
          builder: (_, __) {
            final t = (_c.value + d / 900.0) % 1.0;
            final o = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.3, 1.0);
            return Opacity(opacity: o, child: Container(width: 7, height: 7, margin: const EdgeInsets.symmetric(horizontal: 2.5),
                decoration: const BoxDecoration(color: Color(0xFF1DB954), shape: BoxShape.circle)));
          },
        )).toList()),
      ),
    ]),
  );
}
