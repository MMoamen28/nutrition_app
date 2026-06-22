import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'NutriTrack',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1DB954), brightness: Brightness.dark),
      useMaterial3: true,
    ),
    home: const SplashRouter(),
  );
}

class SplashRouter extends StatefulWidget {
  const SplashRouter({super.key});
  @override
  State<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter> {
  @override
  void initState() { super.initState(); _check(); }

  Future<void> _check() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final user = await AuthService.getCurrentUser();
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (_) => user != null ? DashboardScreen(user: user) : const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF0F1923),
    body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 100, height: 100,
        decoration: BoxDecoration(color: const Color(0xFF1DB954), borderRadius: BorderRadius.circular(28)),
        child: const Icon(Icons.fitness_center, color: Colors.white, size: 56)),
      const SizedBox(height: 20),
      const Text('NutriTrack', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('Your AI Fitness Companion', style: TextStyle(color: Colors.grey, fontSize: 14)),
      const SizedBox(height: 40),
      const CircularProgressIndicator(color: Color(0xFF1DB954), strokeWidth: 2),
    ])),
  );
}
