/// Nutrition data for all 101 Food101 classes (per 100g unless noted)
/// Values are approximate averages from USDA / nutritionix
class NutritionService {
  static const Map<String, Map<String, double>> _nutritionData = {
    'apple_pie': {'calories': 237, 'protein': 2.3, 'carbs': 34, 'fat': 11},
    'baby_back_ribs': {'calories': 290, 'protein': 24, 'carbs': 0, 'fat': 21},
    'baklava': {'calories': 428, 'protein': 7, 'carbs': 52, 'fat': 22},
    'beef_carpaccio': {'calories': 180, 'protein': 22, 'carbs': 0, 'fat': 10},
    'beef_tartare': {'calories': 196, 'protein': 20, 'carbs': 1, 'fat': 12},
    'beet_salad': {'calories': 75, 'protein': 2, 'carbs': 14, 'fat': 2},
    'beignets': {'calories': 390, 'protein': 6, 'carbs': 55, 'fat': 17},
    'bibimbap': {'calories': 130, 'protein': 7, 'carbs': 20, 'fat': 3},
    'bread_pudding': {'calories': 250, 'protein': 7, 'carbs': 38, 'fat': 8},
    'breakfast_burrito': {'calories': 210, 'protein': 10, 'carbs': 25, 'fat': 8},
    'bruschetta': {'calories': 190, 'protein': 5, 'carbs': 28, 'fat': 7},
    'caesar_salad': {'calories': 160, 'protein': 4, 'carbs': 6, 'fat': 14},
    'cannoli': {'calories': 320, 'protein': 8, 'carbs': 38, 'fat': 16},
    'caprese_salad': {'calories': 145, 'protein': 8, 'carbs': 4, 'fat': 11},
    'carrot_cake': {'calories': 415, 'protein': 5, 'carbs': 56, 'fat': 20},
    'ceviche': {'calories': 130, 'protein': 18, 'carbs': 8, 'fat': 3},
    'cheesecake': {'calories': 321, 'protein': 6, 'carbs': 31, 'fat': 20},
    'cheese_plate': {'calories': 380, 'protein': 22, 'carbs': 2, 'fat': 32},
    'chicken_curry': {'calories': 195, 'protein': 17, 'carbs': 8, 'fat': 11},
    'chicken_quesadilla': {'calories': 215, 'protein': 14, 'carbs': 20, 'fat': 9},
    'chicken_wings': {'calories': 290, 'protein': 27, 'carbs': 0, 'fat': 20},
    'chocolate_cake': {'calories': 371, 'protein': 5, 'carbs': 51, 'fat': 18},
    'chocolate_mousse': {'calories': 280, 'protein': 5, 'carbs': 28, 'fat': 18},
    'churros': {'calories': 371, 'protein': 6, 'carbs': 44, 'fat': 19},
    'clam_chowder': {'calories': 90, 'protein': 6, 'carbs': 10, 'fat': 3},
    'club_sandwich': {'calories': 310, 'protein': 20, 'carbs': 28, 'fat': 13},
    'crab_cakes': {'calories': 190, 'protein': 15, 'carbs': 11, 'fat': 9},
    'creme_brulee': {'calories': 245, 'protein': 4, 'carbs': 26, 'fat': 15},
    'croque_madame': {'calories': 320, 'protein': 17, 'carbs': 22, 'fat': 19},
    'cup_cakes': {'calories': 380, 'protein': 4, 'carbs': 58, 'fat': 15},
    'deviled_eggs': {'calories': 155, 'protein': 9, 'carbs': 2, 'fat': 13},
    'donuts': {'calories': 452, 'protein': 5, 'carbs': 51, 'fat': 26},
    'dumplings': {'calories': 180, 'protein': 8, 'carbs': 24, 'fat': 6},
    'edamame': {'calories': 122, 'protein': 11, 'carbs': 10, 'fat': 5},
    'eggs_benedict': {'calories': 282, 'protein': 15, 'carbs': 20, 'fat': 16},
    'escargots': {'calories': 90, 'protein': 16, 'carbs': 2, 'fat': 1},
    'falafel': {'calories': 333, 'protein': 13, 'carbs': 32, 'fat': 18},
    'filet_mignon': {'calories': 227, 'protein': 26, 'carbs': 0, 'fat': 14},
    'fish_and_chips': {'calories': 265, 'protein': 12, 'carbs': 28, 'fat': 12},
    'foie_gras': {'calories': 462, 'protein': 11, 'carbs': 5, 'fat': 44},
    'french_fries': {'calories': 312, 'protein': 3, 'carbs': 41, 'fat': 15},
    'french_onion_soup': {'calories': 80, 'protein': 4, 'carbs': 12, 'fat': 2},
    'french_toast': {'calories': 229, 'protein': 9, 'carbs': 27, 'fat': 9},
    'fried_calamari': {'calories': 175, 'protein': 15, 'carbs': 8, 'fat': 9},
    'fried_rice': {'calories': 163, 'protein': 4, 'carbs': 28, 'fat': 4},
    'frozen_yogurt': {'calories': 127, 'protein': 3, 'carbs': 26, 'fat': 1},
    'garlic_bread': {'calories': 350, 'protein': 8, 'carbs': 45, 'fat': 16},
    'gnocchi': {'calories': 130, 'protein': 3, 'carbs': 28, 'fat': 1},
    'greek_salad': {'calories': 115, 'protein': 3, 'carbs': 8, 'fat': 8},
    'grilled_cheese_sandwich': {'calories': 300, 'protein': 13, 'carbs': 28, 'fat': 16},
    'grilled_salmon': {'calories': 208, 'protein': 28, 'carbs': 0, 'fat': 10},
    'guacamole': {'calories': 157, 'protein': 2, 'carbs': 9, 'fat': 15},
    'gyoza': {'calories': 192, 'protein': 8, 'carbs': 22, 'fat': 8},
    'hamburger': {'calories': 295, 'protein': 17, 'carbs': 24, 'fat': 14},
    'hot_and_sour_soup': {'calories': 50, 'protein': 3, 'carbs': 7, 'fat': 1},
    'hot_dog': {'calories': 290, 'protein': 11, 'carbs': 23, 'fat': 17},
    'huevos_rancheros': {'calories': 196, 'protein': 10, 'carbs': 18, 'fat': 10},
    'hummus': {'calories': 166, 'protein': 8, 'carbs': 14, 'fat': 10},
    'ice_cream': {'calories': 207, 'protein': 3, 'carbs': 24, 'fat': 11},
    'lasagna': {'calories': 166, 'protein': 10, 'carbs': 17, 'fat': 6},
    'lobster_bisque': {'calories': 112, 'protein': 7, 'carbs': 10, 'fat': 5},
    'lobster_roll_sandwich': {'calories': 268, 'protein': 14, 'carbs': 28, 'fat': 11},
    'macaroni_and_cheese': {'calories': 164, 'protein': 7, 'carbs': 22, 'fat': 6},
    'macarons': {'calories': 389, 'protein': 7, 'carbs': 64, 'fat': 14},
    'miso_soup': {'calories': 40, 'protein': 3, 'carbs': 5, 'fat': 1},
    'mussels': {'calories': 172, 'protein': 24, 'carbs': 7, 'fat': 5},
    'nachos': {'calories': 346, 'protein': 9, 'carbs': 36, 'fat': 19},
    'omelette': {'calories': 154, 'protein': 11, 'carbs': 1, 'fat': 12},
    'onion_rings': {'calories': 411, 'protein': 5, 'carbs': 43, 'fat': 25},
    'oysters': {'calories': 69, 'protein': 8, 'carbs': 4, 'fat': 2},
    'pad_thai': {'calories': 181, 'protein': 8, 'carbs': 27, 'fat': 5},
    'paella': {'calories': 190, 'protein': 14, 'carbs': 21, 'fat': 5},
    'pancakes': {'calories': 227, 'protein': 6, 'carbs': 38, 'fat': 7},
    'panna_cotta': {'calories': 196, 'protein': 3, 'carbs': 22, 'fat': 11},
    'peking_duck': {'calories': 337, 'protein': 19, 'carbs': 4, 'fat': 28},
    'pho': {'calories': 60, 'protein': 5, 'carbs': 7, 'fat': 1},
    'pizza': {'calories': 266, 'protein': 11, 'carbs': 33, 'fat': 10},
    'pork_chop': {'calories': 231, 'protein': 28, 'carbs': 0, 'fat': 13},
    'poutine': {'calories': 260, 'protein': 8, 'carbs': 30, 'fat': 13},
    'prime_rib': {'calories': 338, 'protein': 24, 'carbs': 0, 'fat': 26},
    'pulled_pork_sandwich': {'calories': 297, 'protein': 18, 'carbs': 27, 'fat': 12},
    'ramen': {'calories': 436, 'protein': 18, 'carbs': 59, 'fat': 14},
    'ravioli': {'calories': 220, 'protein': 11, 'carbs': 27, 'fat': 8},
    'red_velvet_cake': {'calories': 370, 'protein': 4, 'carbs': 50, 'fat': 18},
    'risotto': {'calories': 164, 'protein': 4, 'carbs': 26, 'fat': 5},
    'samosa': {'calories': 308, 'protein': 6, 'carbs': 30, 'fat': 18},
    'sashimi': {'calories': 127, 'protein': 24, 'carbs': 0, 'fat': 3},
    'scallops': {'calories': 111, 'protein': 20, 'carbs': 5, 'fat': 1},
    'seaweed_salad': {'calories': 70, 'protein': 2, 'carbs': 11, 'fat': 2},
    'shrimp_and_grits': {'calories': 210, 'protein': 15, 'carbs': 20, 'fat': 8},
    'spaghetti_bolognese': {'calories': 175, 'protein': 10, 'carbs': 22, 'fat': 5},
    'spaghetti_carbonara': {'calories': 220, 'protein': 11, 'carbs': 25, 'fat': 9},
    'spring_rolls': {'calories': 153, 'protein': 5, 'carbs': 19, 'fat': 6},
    'steak': {'calories': 242, 'protein': 26, 'carbs': 0, 'fat': 15},
    'strawberry_shortcake': {'calories': 322, 'protein': 5, 'carbs': 44, 'fat': 15},
    'sushi': {'calories': 143, 'protein': 6, 'carbs': 20, 'fat': 4},
    'tacos': {'calories': 226, 'protein': 12, 'carbs': 21, 'fat': 11},
    'takoyaki': {'calories': 182, 'protein': 7, 'carbs': 22, 'fat': 8},
    'tiramisu': {'calories': 240, 'protein': 5, 'carbs': 30, 'fat': 12},
    'tuna_tartare': {'calories': 115, 'protein': 22, 'carbs': 2, 'fat': 2},
    'waffles': {'calories': 291, 'protein': 8, 'carbs': 37, 'fat': 13},
  };

  /// Returns nutrition info for a food (per 100g), or null if not found.
  static Map<String, double>? getNutrition(String foodName) {
    final key = foodName.toLowerCase().replaceAll(' ', '_');
    return _nutritionData[key];
  }

  /// Calculates calories for a given gram amount
  static double calculateCalories(String foodName, double grams) {
    final data = getNutrition(foodName);
    if (data == null) return 0;
    return (data['calories']! * grams) / 100;
  }

  /// Returns a nice display string with full macros
  static String getNutritionSummary(String foodName, double grams) {
    final data = getNutrition(foodName);
    if (data == null) return 'Nutrition data not available';
    final factor = grams / 100;
    final cal = (data['calories']! * factor).round();
    final pro = (data['protein']! * factor).toStringAsFixed(1);
    final carb = (data['carbs']! * factor).toStringAsFixed(1);
    final fat = (data['fat']! * factor).toStringAsFixed(1);
    return '🔥 $cal kcal | 💪 ${pro}g protein | 🍞 ${carb}g carbs | 🥑 ${fat}g fat';
  }
}
