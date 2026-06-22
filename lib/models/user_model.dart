class WeightEntry {
  final double weight;
  final String date;
  WeightEntry({required this.weight, required this.date});
  Map<String, dynamic> toMap() => {'weight': weight, 'date': date};
  factory WeightEntry.fromMap(Map<String, dynamic> m) =>
      WeightEntry(weight: (m['weight'] as num).toDouble(), date: m['date']);
}

class FoodLogEntry {
  final String foodName;
  final double grams;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String time;
  final String date;
  FoodLogEntry({
    required this.foodName, required this.grams, required this.calories,
    required this.protein, required this.carbs, required this.fat,
    required this.time, required this.date,
  });
  Map<String, dynamic> toMap() => {
    'foodName': foodName, 'grams': grams, 'calories': calories,
    'protein': protein, 'carbs': carbs, 'fat': fat,
    'time': time, 'date': date,
  };
  factory FoodLogEntry.fromMap(Map<String, dynamic> m) => FoodLogEntry(
    foodName: m['foodName'], grams: (m['grams'] as num).toDouble(),
    calories: (m['calories'] as num).toDouble(), protein: (m['protein'] as num).toDouble(),
    carbs: (m['carbs'] as num).toDouble(), fat: (m['fat'] as num).toDouble(),
    time: m['time'], date: m['date'],
  );
}

class UserModel {
  final String username;
  final String password;
  final String name;
  final int age;
  double weight;
  final double height;
  final String gender;
  String activityLevel;
  String goal;
  double caloriesConsumedToday;
  String lastActiveDate;
  List<WeightEntry> weightLog;
  List<FoodLogEntry> foodLog;

  // ── Subscription & Wallet ──────────────────────────────────
  double walletBalance;       // coin balance
  String planType;            // 'free' or 'pro'
  String proExpiryDate;       // yyyy-MM-dd or ''

  UserModel({
    required this.username, required this.password, required this.name,
    required this.age, required this.weight, required this.height,
    required this.gender, required this.activityLevel, required this.goal,
    this.caloriesConsumedToday = 0, this.lastActiveDate = '',
    List<WeightEntry>? weightLog, List<FoodLogEntry>? foodLog,
    this.walletBalance = 0, this.planType = 'free', this.proExpiryDate = '',
  })  : weightLog = weightLog ?? [],
        foodLog = foodLog ?? [];

  // ── Calorie science ───────────────────────────────────────
  double get bmr => gender == 'male'
      ? 10 * weight + 6.25 * height - 5 * age + 5
      : 10 * weight + 6.25 * height - 5 * age - 161;

  double get activityMultiplier {
    switch (activityLevel) {
      case 'sedentary':   return 1.2;
      case 'light':       return 1.375;
      case 'moderate':    return 1.55;
      case 'active':      return 1.725;
      case 'very_active': return 1.9;
      default:            return 1.375;
    }
  }

  double get tdee => bmr * activityMultiplier;
  double get dailyCalorieTarget => goal == 'lose_fat' ? tdee - 500 : tdee + 300;
  double get dailyProteinTarget => goal == 'build_muscle' ? weight * 1.6 : weight * 2.0;
  double get dailyCarbTarget {
    final p = dailyProteinTarget * 4;
    final f = dailyFatTarget * 9;
    return (dailyCalorieTarget - p - f) / 4;
  }
  double get dailyFatTarget => (dailyCalorieTarget * 0.25) / 9;
  double get remainingCalories => dailyCalorieTarget - caloriesConsumedToday;
  double get bmi => weight / ((height / 100) * (height / 100));
  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25)   return 'Normal';
    if (bmi < 30)   return 'Overweight';
    return 'Obese';
  }

  // ── Subscription helpers ──────────────────────────────────
  bool get isPro {
    if (planType != 'pro') return false;
    if (proExpiryDate.isEmpty) return false;
    try {
      final expiry = DateTime.parse(proExpiryDate);
      return expiry.isAfter(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  String get proExpiryDisplay {
    if (!isPro) return '';
    try {
      final d = DateTime.parse(proExpiryDate);
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return '';
    }
  }

  static const int proMonthlyCost = 200; // coins

  List<FoodLogEntry> get todayFoodLog {
    final today = _todayStr();
    return foodLog.where((e) => e.date == today).toList();
  }

  static String _todayStr() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  // ── Serialisation ─────────────────────────────────────────
  Map<String, dynamic> toMap() => {
    'username': username, 'password': password, 'name': name,
    'age': age, 'weight': weight, 'height': height,
    'gender': gender, 'activityLevel': activityLevel, 'goal': goal,
    'caloriesConsumedToday': caloriesConsumedToday,
    'lastActiveDate': lastActiveDate,
    'weightLog': weightLog.map((e) => e.toMap()).toList(),
    'foodLog': foodLog.map((e) => e.toMap()).toList(),
    'walletBalance': walletBalance,
    'planType': planType,
    'proExpiryDate': proExpiryDate,
  };

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
    username: m['username'], password: m['password'], name: m['name'],
    age: m['age'], weight: (m['weight'] as num).toDouble(),
    height: (m['height'] as num).toDouble(), gender: m['gender'],
    activityLevel: m['activityLevel'], goal: m['goal'],
    caloriesConsumedToday: (m['caloriesConsumedToday'] as num?)?.toDouble() ?? 0,
    lastActiveDate: m['lastActiveDate'] ?? '',
    weightLog: (m['weightLog'] as List<dynamic>?)
        ?.map((e) => WeightEntry.fromMap(e)).toList() ?? [],
    foodLog: (m['foodLog'] as List<dynamic>?)
        ?.map((e) => FoodLogEntry.fromMap(e)).toList() ?? [],
    walletBalance: (m['walletBalance'] as num?)?.toDouble() ?? 0,
    planType: m['planType'] ?? 'free',
    proExpiryDate: m['proExpiryDate'] ?? '',
  );
}
