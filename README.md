# NutriTrack — AI-Powered Fitness & Nutrition App

A complete Flutter mobile app combining AI food recognition, personalized workout plans, and nutrition tracking based on the user's goal (Fat Loss or Muscle Building).

## Features

### Authentication
- Sign up with username & password (stored locally via SharedPreferences)
- Login persists across app restarts — no need to sign in again
- Logout from the top bar

### Onboarding (3-step signup)
1. Account — name, username, password
2. Personal Data — age, weight (kg), height (cm), gender, activity level
3. Goal Selection — Fat Loss or Muscle Building

### Home Dashboard
- Daily calorie ring (consumed vs target)
- Macro targets: protein, carbs, fat
- BMI, BMR, and TDEE calculated via Mifflin-St Jeor formula
- Personalized daily tip

### Workout Plans
- Fat Loss Plan: 5-day HIIT + cardio circuit program
- Muscle Building Plan: 5-day progressive overload program
- Each exercise shows sets, reps, rest time, muscle group, and instructions

### Nutrition Plan
- Full daily meal plan tailored to goal
- Fat loss: lean proteins, controlled carbs, calorie deficit
- Muscle gain: calorie surplus, high protein, pre/post-workout meals

### Food Scanner (AI)
- Capture food via camera or pick from gallery
- TFLite model identifies 101 food types (Food101 dataset)
- Looks up calories + macros per 100g
- Portion size slider (50g to 500g)
- Logs calories and shows remaining calories for the day

## Setup

### Prerequisites
- Flutter SDK 3.5+
- Android device or emulator (API 24+)

### Steps
```bash
cd nutrition_app
flutter pub get
flutter run
```

### Assets Required
Place these in assets/models/:
- food101_model.tflite
- grad_ai_model.txt (101 labels, one per line)

## Project Structure

```
lib/
├── main.dart                        App entry + auth router
├── ai_helper.dart                   TFLite inference
├── models/user_model.dart           User data + calorie math
├── services/
│   ├── auth_service.dart            Login/signup/persist
│   ├── nutrition_service.dart       101-food calorie database
│   ├── nutrition_plan_service.dart  Meal plans per goal
│   └── workout_service.dart         Workout plans per goal
└── screens/
    ├── login_screen.dart
    ├── signup_screen.dart
    ├── personal_data_screen.dart
    ├── goal_screen.dart
    ├── dashboard_screen.dart
    ├── home_tab.dart
    ├── workout_screen.dart
    ├── nutrition_plan_screen.dart
    └── food_scan_screen.dart
```

## Calorie Formula (Mifflin-St Jeor)
- Male BMR = 10*weight + 6.25*height - 5*age + 5
- Female BMR = 10*weight + 6.25*height - 5*age - 161
- TDEE = BMR * activity multiplier
- Fat Loss Target = TDEE - 500 kcal
- Muscle Gain Target = TDEE + 300 kcal
