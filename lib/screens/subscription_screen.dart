import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class SubscriptionScreen extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onUserUpdated;
  const SubscriptionScreen(
      {super.key, required this.user, required this.onUserUpdated});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _loading = false;

  Future<void> _subscribePro() async {
    if (widget.user.isPro) {
      _showSnack('You already have an active Pro plan!', isError: false);
      return;
    }
    if (widget.user.walletBalance < UserModel.proMonthlyCost) {
      _showSnack(
          'Insufficient balance. You need ${UserModel.proMonthlyCost} coins.',
          isError: true);
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A2332),
        title: const Text('Confirm Subscription',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Subscribe to Pro for ${UserModel.proMonthlyCost} coins?\n\n'
          'Your balance: ${widget.user.walletBalance.round()} coins\n'
          'After payment: ${(widget.user.walletBalance - UserModel.proMonthlyCost).round()} coins',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.grey))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirm',
                  style: TextStyle(color: Color(0xFF1DB954)))),
        ],
      ),
    );

    if (confirm != true) return;
    setState(() => _loading = true);

    widget.user.walletBalance -= UserModel.proMonthlyCost;
    widget.user.planType = 'pro';
    // Set expiry to 30 days from now
    final expiry = DateTime.now().add(const Duration(days: 30));
    widget.user.proExpiryDate =
        '${expiry.year}-${expiry.month.toString().padLeft(2, '0')}-${expiry.day.toString().padLeft(2, '0')}';

    await AuthService.updateUser(widget.user);
    widget.onUserUpdated(widget.user);
    setState(() => _loading = false);

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A2332),
        title: const Text('🎉 Welcome to Pro!',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Your Pro plan is active until ${widget.user.proExpiryDisplay}.\n\nEnjoy full access to all features!',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Let\'s Go!',
                  style: TextStyle(color: Color(0xFF1DB954)))),
        ],
      ),
    );
  }

  Future<void> _cancelPro() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A2332),
        title: const Text('Cancel Pro Plan',
            style: TextStyle(color: Colors.white)),
        content: const Text(
            'Are you sure you want to cancel your Pro plan? You will lose access to Pro features.',
            style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Keep Pro',
                  style: TextStyle(color: Color(0xFF1DB954)))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Cancel Plan',
                  style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm != true) return;
    widget.user.planType = 'free';
    widget.user.proExpiryDate = '';
    await AuthService.updateUser(widget.user);
    widget.onUserUpdated(widget.user);
    setState(() {});
    _showSnack('Pro plan cancelled. You are now on the Free plan.');
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor:
          isError ? Colors.red.shade700 : const Color(0xFF1DB954),
      behavior: SnackBarBehavior.floating,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isPro = widget.user.isPro;
    final balance = widget.user.walletBalance.round();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        const Text('Subscription Plans',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Choose the plan that fits your goals',
            style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 20),

        // Current status banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isPro
                ? const Color(0xFFFFD700).withOpacity(0.1)
                : const Color(0xFF1DB954).withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: isPro
                    ? const Color(0xFFFFD700).withOpacity(0.4)
                    : const Color(0xFF1DB954).withOpacity(0.3)),
          ),
          child: Row(children: [
            Text(isPro ? '👑' : '🆓',
                style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              Text(
                isPro ? 'Pro Plan Active' : 'Free Plan',
                style: TextStyle(
                    color:
                        isPro ? const Color(0xFFFFD700) : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                isPro
                    ? 'Expires: ${widget.user.proExpiryDisplay}'
                    : 'Upgrade to unlock all features',
                style:
                    const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const Text('Balance',
                  style: TextStyle(color: Colors.grey, fontSize: 10)),
              Row(children: [
                const Text('🪙',
                    style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text('$balance',
                    style: const TextStyle(
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ]),
            ]),
          ]),
        ),
        const SizedBox(height: 20),

        // Plan cards
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // FREE
          Expanded(
            child: _PlanCard(
              title: 'Free',
              price: '0',
              color: const Color(0xFF1DB954),
              icon: '🆓',
              isActive: !isPro,
              features: const [
                _Feature('Home dashboard', true),
                _Feature('Calorie tracker', true),
                _Feature('BMI / BMR stats', true),
                _Feature('Basic nutrition info', true),
                _Feature('Workout plans', false),
                _Feature('Meal plans', false),
                _Feature('Food AI Scanner', false),
                _Feature('AI Chatbot', false),
                _Feature('Profile & weight log', false),
                _Feature('Settings', false),
              ],
              onTap: isPro ? _cancelPro : null,
              buttonLabel: isPro ? 'Downgrade' : 'Current Plan',
              buttonColor:
                  isPro ? Colors.red.shade400 : const Color(0xFF1DB954),
            ),
          ),
          const SizedBox(width: 12),
          // PRO
          Expanded(
            child: _PlanCard(
              title: 'Pro',
              price: '200',
              color: const Color(0xFFFFD700),
              icon: '👑',
              isActive: isPro,
              features: const [
                _Feature('Home dashboard', true),
                _Feature('Calorie tracker', true),
                _Feature('BMI / BMR stats', true),
                _Feature('Basic nutrition info', true),
                _Feature('Workout plans', true),
                _Feature('Meal plans', true),
                _Feature('Food AI Scanner', true),
                _Feature('AI Chatbot', true),
                _Feature('Profile & weight log', true),
                _Feature('Settings', true),
              ],
              onTap: isPro ? null : _subscribePro,
              buttonLabel: isPro ? 'Active ✓' : 'Subscribe',
              buttonColor: const Color(0xFFFFD700),
              loading: _loading,
            ),
          ),
        ]),
        const SizedBox(height: 24),

        // Coins note
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: const Color(0xFF1A2332),
              borderRadius: BorderRadius.circular(14)),
          child: const Row(children: [
            Text('ℹ️', style: TextStyle(fontSize: 18)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Pro plan costs 200 coins/month. Recharge your wallet in the Wallet tab to get coins.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 20),
      ]),
    );
  }
}

class _Feature {
  final String label;
  final bool included;
  const _Feature(this.label, this.included);
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final Color color;
  final String icon;
  final bool isActive;
  final List<_Feature> features;
  final VoidCallback? onTap;
  final String buttonLabel;
  final Color buttonColor;
  final bool loading;

  const _PlanCard({
    required this.title, required this.price, required this.color,
    required this.icon, required this.isActive, required this.features,
    required this.onTap, required this.buttonLabel, required this.buttonColor,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive
            ? color.withOpacity(0.08)
            : const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: isActive ? color : const Color(0xFF263040),
            width: isActive ? 2 : 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 6),
          Text(title,
              style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 6),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(price,
              style: TextStyle(
                  color: color,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(price == '0' ? 'coins' : ' coins/mo',
                style:
                    const TextStyle(color: Colors.grey, fontSize: 11)),
          ),
        ]),
        const SizedBox(height: 14),
        const Divider(color: Color(0xFF263040)),
        const SizedBox(height: 10),
        ...features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Icon(
                    f.included ? Icons.check_circle : Icons.cancel,
                    color:
                        f.included ? color : Colors.grey.shade700,
                    size: 15),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(f.label,
                      style: TextStyle(
                          color: f.included
                              ? Colors.white70
                              : Colors.grey.shade700,
                          fontSize: 11)),
                ),
              ]),
            )),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  onTap == null ? Colors.grey.shade800 : buttonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : Text(buttonLabel,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ),
      ]),
    );
  }
}
