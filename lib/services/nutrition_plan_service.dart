import '../models/user_model.dart';

class MealPlan {
  final String mealName;
  final String time;
  final List<MealItem> items;
  MealPlan({required this.mealName, required this.time, required this.items});
}

class MealItem {
  final String name;
  final String portion;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  MealItem({
    required this.name,
    required this.portion,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}

class NutritionPlanService {
  static List<MealPlan> getPlan(UserModel user) {
    if (user.goal == 'lose_fat') {
      return _fatLossPlan(user);
    } else {
      return _musclePlan(user);
    }
  }

  static List<MealPlan> _fatLossPlan(UserModel user) {
    return [
      MealPlan(
        mealName: 'Breakfast',
        time: '7:00 – 8:00 AM',
        items: [
          MealItem(name: 'Oatmeal with berries', portion: '1 cup oats + ½ cup berries', calories: 280, protein: 9, carbs: 52, fat: 4),
          MealItem(name: 'Boiled eggs', portion: '2 large eggs', calories: 140, protein: 12, carbs: 1, fat: 10),
          MealItem(name: 'Black coffee / green tea', portion: '1 cup', calories: 5, protein: 0, carbs: 0, fat: 0),
        ],
      ),
      MealPlan(
        mealName: 'Mid-Morning Snack',
        time: '10:00 – 10:30 AM',
        items: [
          MealItem(name: 'Greek yogurt (low-fat)', portion: '150g', calories: 95, protein: 13, carbs: 8, fat: 1),
          MealItem(name: 'Apple', portion: '1 medium', calories: 80, protein: 0, carbs: 21, fat: 0),
        ],
      ),
      MealPlan(
        mealName: 'Lunch',
        time: '1:00 – 2:00 PM',
        items: [
          MealItem(name: 'Grilled chicken breast', portion: '150g', calories: 248, protein: 47, carbs: 0, fat: 5),
          MealItem(name: 'Brown rice', portion: '½ cup cooked', calories: 110, protein: 2, carbs: 23, fat: 1),
          MealItem(name: 'Mixed greens salad', portion: 'Large bowl', calories: 40, protein: 3, carbs: 6, fat: 1),
          MealItem(name: 'Olive oil & lemon dressing', portion: '1 tbsp oil', calories: 120, protein: 0, carbs: 1, fat: 14),
        ],
      ),
      MealPlan(
        mealName: 'Afternoon Snack',
        time: '4:00 PM',
        items: [
          MealItem(name: 'Almonds', portion: '20g (about 15 almonds)', calories: 116, protein: 4, carbs: 4, fat: 10),
          MealItem(name: 'Cucumber slices', portion: '1 cup', calories: 16, protein: 1, carbs: 3, fat: 0),
        ],
      ),
      MealPlan(
        mealName: 'Dinner',
        time: '7:00 – 8:00 PM',
        items: [
          MealItem(name: 'Baked salmon or tuna', portion: '150g', calories: 250, protein: 34, carbs: 0, fat: 12),
          MealItem(name: 'Steamed broccoli & carrots', portion: '2 cups', calories: 60, protein: 4, carbs: 13, fat: 0),
          MealItem(name: 'Sweet potato', portion: '100g', calories: 86, protein: 2, carbs: 20, fat: 0),
        ],
      ),
    ];
  }

  static List<MealPlan> _musclePlan(UserModel user) {
    return [
      MealPlan(
        mealName: 'Breakfast',
        time: '7:00 – 8:00 AM',
        items: [
          MealItem(name: 'Whole eggs + egg whites', portion: '3 whole + 3 whites', calories: 310, protein: 30, carbs: 2, fat: 15),
          MealItem(name: 'Oatmeal', portion: '1.5 cups cooked', calories: 220, protein: 8, carbs: 40, fat: 4),
          MealItem(name: 'Banana', portion: '1 large', calories: 105, protein: 1, carbs: 27, fat: 0),
          MealItem(name: 'Whole milk', portion: '1 cup', calories: 149, protein: 8, carbs: 12, fat: 8),
        ],
      ),
      MealPlan(
        mealName: 'Mid-Morning Snack',
        time: '10:00 – 10:30 AM',
        items: [
          MealItem(name: 'Whey protein shake', portion: '1 scoop (30g)', calories: 120, protein: 25, carbs: 3, fat: 2),
          MealItem(name: 'Peanut butter on whole wheat', portion: '2 tbsp PB + 2 slices bread', calories: 380, protein: 14, carbs: 36, fat: 18),
        ],
      ),
      MealPlan(
        mealName: 'Lunch',
        time: '1:00 – 2:00 PM',
        items: [
          MealItem(name: 'Grilled chicken or beef', portion: '200g', calories: 340, protein: 50, carbs: 0, fat: 14),
          MealItem(name: 'White rice', portion: '1 cup cooked', calories: 200, protein: 4, carbs: 45, fat: 0),
          MealItem(name: 'Mixed vegetables (stir-fried)', portion: '1.5 cups', calories: 80, protein: 4, carbs: 14, fat: 2),
          MealItem(name: 'Avocado', portion: '½ avocado', calories: 120, protein: 1, carbs: 6, fat: 11),
        ],
      ),
      MealPlan(
        mealName: 'Pre-Workout Snack',
        time: '4:00 – 4:30 PM',
        items: [
          MealItem(name: 'Rice cakes', portion: '4 cakes', calories: 140, protein: 3, carbs: 28, fat: 1),
          MealItem(name: 'Cottage cheese', portion: '100g', calories: 98, protein: 11, carbs: 3, fat: 4),
        ],
      ),
      MealPlan(
        mealName: 'Post-Workout / Dinner',
        time: '7:00 – 8:30 PM',
        items: [
          MealItem(name: 'Whey protein shake', portion: '1 scoop in milk', calories: 270, protein: 33, carbs: 15, fat: 8),
          MealItem(name: 'Grilled steak or chicken', portion: '200g', calories: 350, protein: 48, carbs: 0, fat: 16),
          MealItem(name: 'Pasta or sweet potato', portion: '150g cooked', calories: 175, protein: 6, carbs: 36, fat: 1),
          MealItem(name: 'Side salad', portion: 'Medium bowl', calories: 40, protein: 2, carbs: 6, fat: 1),
        ],
      ),
      MealPlan(
        mealName: 'Before Bed Snack',
        time: '10:00 PM',
        items: [
          MealItem(name: 'Casein protein or cottage cheese', portion: '150g', calories: 170, protein: 20, carbs: 8, fat: 5),
          MealItem(name: 'Mixed nuts', portion: '20g', calories: 130, protein: 4, carbs: 5, fat: 12),
        ],
      ),
    ];
  }
}
