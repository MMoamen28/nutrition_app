import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'home_tab.dart';
import 'workout_screen.dart';
import 'nutrition_plan_screen.dart';
import 'food_scan_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'paywall_screen.dart';
import 'subscription_screen.dart';
import 'wallet_screen.dart';

class DashboardScreen extends StatefulWidget {
  final UserModel user;
  const DashboardScreen({super.key, required this.user});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _idx = 0;
  late UserModel _user;
  Timer? _timer;
  String _lastDate = '';

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _lastDate = _today();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _checkReset());
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  String _today() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2,'0')}-${n.day.toString().padLeft(2,'0')}';
  }

  Future<void> _checkReset() async {
    final today = _today();
    if (today != _lastDate) {
      _lastDate = today;
      _user.caloriesConsumedToday = 0;
      _user.lastActiveDate = today;
      _user.foodLog.removeWhere((e) => e.date != today);
      await AuthService.updateUser(_user);
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('🌅 New day! Daily calories reset.'),
          backgroundColor: const Color(0xFF1DB954), behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    }
  }

  void _onCaloriesLogged(double cals, FoodLogEntry entry) async {
    setState(() { _user.caloriesConsumedToday += cals; _user.foodLog.add(entry); });
    await AuthService.updateUser(_user);
  }

  void _onUserUpdated(UserModel u) => setState(() => _user = u);

  void _logout() async {
    _timer?.cancel();
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
  }

  // Pro-only tabs: 1=Workout, 2=Nutrition, 3=Scan, 4=Chat, 5=Profile, 6=Settings
  bool _isProTab(int i) => [1, 2, 3, 4, 5, 6].contains(i);

  Widget _tabContent(int i) {
    if (_isProTab(i) && !_user.isPro) {
      final names = ['', 'Workout Plans', 'Meal Plans', 'AI Food Scanner', 'AI Chatbot', 'Profile & Weight Log', 'Settings'];
      final icons = ['', '💪', '🥗', '📷', '🤖', '👤', '⚙️'];
      return PaywallScreen(
        featureName: names[i], featureIcon: icons[i],
        onUpgrade: () => setState(() => _idx = 8), // go to subscription tab
      );
    }
    switch (i) {
      case 0: return HomeTab(user: _user);
      case 1: return WorkoutScreen(user: _user);
      case 2: return NutritionPlanScreen(user: _user);
      case 3: return FoodScanScreen(user: _user, onCaloriesLogged: _onCaloriesLogged);
      case 4: return ChatScreen(user: _user);
      case 5: return ProfileScreen(user: _user);
      case 6: return SettingsScreen(user: _user, onUserUpdated: _onUserUpdated);
      case 7: return WalletScreen(user: _user, onUserUpdated: _onUserUpdated);
      case 8: return SubscriptionScreen(user: _user, onUserUpdated: _onUserUpdated);
      default: return HomeTab(user: _user);
    }
  }

  static const _titles = [
    'NutriTrack', 'Workout', 'Nutrition', 'Scan Food',
    'AI Assistant', 'My Profile', 'Settings', 'My Wallet', 'Subscription',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1923), elevation: 0,
        title: Row(children: [
          Container(width: 34, height: 34,
            decoration: BoxDecoration(color: const Color(0xFF1DB954), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.fitness_center, color: Colors.white, size: 18)),
          const SizedBox(width: 10),
          Text(_titles[_idx], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ]),
        actions: [
          // Wallet balance chip
          GestureDetector(
            onTap: () => setState(() => _idx = 7),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.4)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('🪙', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text('${_user.walletBalance.round()}',
                    style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 13)),
              ]),
            ),
          ),
          // Pro badge
          if (_user.isPro)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('👑 PRO', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: _logout),
        ],
      ),
      body: _tabContent(_idx),
      bottomNavigationBar: _BottomNav(current: _idx, isPro: _user.isPro, onTap: (i) => setState(() => _idx = i)),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int current;
  final bool isPro;
  final Function(int) onTap;
  const _BottomNav({required this.current, required this.isPro, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'i': Icons.home_outlined,            'a': Icons.home,            'l': 'Home',     'pro': false},
      {'i': Icons.fitness_center_outlined,  'a': Icons.fitness_center,  'l': 'Workout',  'pro': true},
      {'i': Icons.restaurant_menu_outlined, 'a': Icons.restaurant_menu, 'l': 'Nutrition','pro': true},
      {'i': Icons.camera_alt_outlined,      'a': Icons.camera_alt,      'l': 'Scan',     'pro': true},
      {'i': Icons.chat_bubble_outline,      'a': Icons.chat_bubble,     'l': 'AI Chat',  'pro': true},
      {'i': Icons.person_outline,           'a': Icons.person,          'l': 'Profile',  'pro': true},
      {'i': Icons.settings_outlined,        'a': Icons.settings,        'l': 'Settings', 'pro': true},
      {'i': Icons.account_balance_wallet_outlined, 'a': Icons.account_balance_wallet, 'l': 'Wallet', 'pro': false},
      {'i': Icons.workspace_premium_outlined,'a': Icons.workspace_premium,'l': 'Plans',  'pro': false},
    ];

    return Container(
      decoration: const BoxDecoration(color: Color(0xFF1A2332), border: Border(top: BorderSide(color: Color(0xFF263040), width: 1))),
      child: SafeArea(child: SizedBox(height: 62,
        child: Row(children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final sel = i == current;
          final needsPro = item['pro'] as bool;
          final locked = needsPro && !isPro;
          final color = sel ? const Color(0xFF1DB954) : (locked ? Colors.grey.shade700 : Colors.grey);
          return Expanded(child: GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Stack(clipBehavior: Clip.none, children: [
                Icon(sel ? item['a'] as IconData : item['i'] as IconData, color: color, size: 22),
                if (locked) Positioned(right: -4, top: -4,
                  child: Container(width: 10, height: 10,
                    decoration: const BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle),
                    child: const Icon(Icons.lock, size: 7, color: Colors.black))),
              ]),
              const SizedBox(height: 3),
              Text(item['l'] as String, style: TextStyle(color: color, fontSize: 9,
                  fontWeight: sel ? FontWeight.bold : FontWeight.normal)),
            ]),
          ));
        }).toList()),
      )),
    );
  }
}
