import 'package:flutter/material.dart';

class PaywallScreen extends StatelessWidget {
  final String featureName;
  final String featureIcon;
  final VoidCallback onUpgrade;

  const PaywallScreen({
    super.key,
    required this.featureName,
    required this.featureIcon,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lock icon
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color(0xFFFFD700).withOpacity(0.4),
                    width: 2),
              ),
              child: const Icon(Icons.lock_outline,
                  color: Color(0xFFFFD700), size: 44),
            ),
            const SizedBox(height: 24),

            Text(featureIcon, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 12),

            Text(
              featureName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            const Text(
              'This feature is available on the Pro plan only.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // What you get with pro
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withOpacity(0.07),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFFFFD700).withOpacity(0.3)),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text('👑  Pro Plan includes:',
                    style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                const SizedBox(height: 12),
                ...[
                  '💪  Full workout plans',
                  '🥗  Personalized meal plans',
                  '📷  AI Food Scanner',
                  '🤖  AI Nutrition Chatbot',
                  '👤  Profile & weight tracking',
                  '⚙️  Settings & goal changes',
                ].map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(f,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13)),
                    )),
              ]),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: onUpgrade,
                icon: const Icon(Icons.workspace_premium,
                    color: Colors.black),
                label: const Text(
                  'Upgrade to Pro — 200 coins',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {},
              child: const Text('Continue with Free plan',
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}
