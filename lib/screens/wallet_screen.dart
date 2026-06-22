import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../widgets/payment_bottom_sheet.dart';

class WalletScreen extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onUserUpdated;
  const WalletScreen(
      {super.key, required this.user, required this.onUserUpdated});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _loading = false;

  final List<Map<String, dynamic>> _packages = [
    {'coins': 100, 'price': '\$0.99', 'bonus': '', 'popular': false, 'color': const Color(0xFF64B5F6)},
    {'coins': 250, 'price': '\$1.99', 'bonus': '+25 Bonus', 'popular': true, 'color': const Color(0xFF1DB954)},
    {'coins': 500, 'price': '\$3.99', 'bonus': '+100 Bonus', 'popular': false, 'color': const Color(0xFFFFD700)},
    {'coins': 1000, 'price': '\$6.99', 'bonus': '+250 Bonus', 'popular': false, 'color': const Color(0xFFFF6B35)},
  ];

  Future<void> _recharge(int coins) async {
    final pkg = _packages.firstWhere((p) => p['coins'] == coins);
    final total = coins + (pkg['bonus'] != ''
        ? int.parse((pkg['bonus'] as String).replaceAll(RegExp(r'[^0-9]'), ''))
        : 0);

    final confirm = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentBottomSheet(
        coins: coins,
        price: pkg['price'] as String,
        bonus: pkg['bonus'] as String,
      ),
    );

    if (confirm != true) return;
    setState(() => _loading = true);
    widget.user.walletBalance += total;
    await AuthService.updateUser(widget.user);
    widget.onUserUpdated(widget.user);
    setState(() => _loading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('🪙 $total coins added to your wallet!'),
      backgroundColor: const Color(0xFF1DB954),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final balance = widget.user.walletBalance.round();
    final isPro = widget.user.isPro;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('My Wallet',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        const Text('Recharge coins to subscribe to Pro',
            style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 20),

        // Balance card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A2332), Color(0xFF1E2D40)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: const Color(0xFFFFD700).withOpacity(0.3)),
          ),
          child: Column(children: [
            const Text('🪙', style: TextStyle(fontSize: 44)),
            const SizedBox(height: 8),
            Text('$balance',
                style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 48,
                    fontWeight: FontWeight.bold)),
            const Text('coins',
                style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 16),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isPro
                    ? const Color(0xFFFFD700).withOpacity(0.1)
                    : const Color(0xFF1DB954).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: isPro
                        ? const Color(0xFFFFD700).withOpacity(0.4)
                        : const Color(0xFF1DB954).withOpacity(0.4)),
              ),
              child: Text(
                isPro
                    ? '👑 Pro Plan • Expires ${widget.user.proExpiryDisplay}'
                    : '🆓 Free Plan • Upgrade for ${UserModel.proMonthlyCost} coins',
                style: TextStyle(
                    color: isPro
                        ? const Color(0xFFFFD700)
                        : const Color(0xFF1DB954),
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 24),

        // Recharge packages
        const Text('Recharge Coins',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Simulated payment — no real money charged',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 14),

        ..._packages.map((pkg) {
          final coins = pkg['coins'] as int;
          final bonus = pkg['bonus'] as String;
          final total = bonus.isNotEmpty
              ? coins +
                  int.parse(bonus.replaceAll(RegExp(r'[^0-9]'), ''))
              : coins;
          final color = pkg['color'] as Color;
          final isPopular = pkg['popular'] as bool;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Stack(
              children: [
                InkWell(
                  onTap: _loading ? null : () => _recharge(coins),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isPopular
                          ? color.withOpacity(0.1)
                          : const Color(0xFF1A2332),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: isPopular
                              ? color
                              : const Color(0xFF263040),
                          width: isPopular ? 2 : 1),
                    ),
                    child: Row(children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            shape: BoxShape.circle),
                        child: Center(
                          child: Text('🪙',
                              style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                          child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                            Text('$total coins',
                                style: TextStyle(
                                    color: color,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            if (bonus.isNotEmpty)
                              Text(bonus,
                                  style: const TextStyle(
                                      color: Color(0xFF1DB954),
                                      fontSize: 11)),
                          ])),
                      Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.end,
                          children: [
                        Text(pkg['price'] as String,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const Text('simulated',
                            style: TextStyle(
                                color: Colors.grey, fontSize: 10)),
                      ]),
                    ]),
                  ),
                ),
                if (isPopular)
                  Positioned(
                    top: 0,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8))),
                      child: const Text('POPULAR',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          );
        }),

        const SizedBox(height: 10),
        // Transaction note
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: const Color(0xFF1A2332),
              borderRadius: BorderRadius.circular(14)),
          child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text('Transaction History',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              'Pro subscription: 200 coins/month\nCoins never expire\nAll payments are simulated for demo purposes',
              style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.6),
            ),
          ]),
        ),
        const SizedBox(height: 20),
      ]),
    );
  }
}
