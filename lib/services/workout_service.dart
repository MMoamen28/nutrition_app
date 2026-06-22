class WorkoutPlan {
  final String name;
  final String day;
  final List<WorkoutExercise> exercises;
  WorkoutPlan({required this.name, required this.day, required this.exercises});
}

class WorkoutExercise {
  final String name;
  final String sets;
  final String reps;
  final String rest;
  final String instructions;
  final String muscleGroup;
  final String mediaAsset;   // path to mp4 or jpg/jpeg in assets/exercises/
  final bool isVideo;        // true = mp4, false = image

  WorkoutExercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.rest,
    required this.instructions,
    required this.muscleGroup,
    required this.mediaAsset,
    required this.isVideo,
  });
}

class WorkoutService {
  static List<WorkoutPlan> getFatLossPlan() {
    return [
      WorkoutPlan(
        name: 'Full Body HIIT',
        day: 'Day 1 — Monday',
        exercises: [
          WorkoutExercise(
            name: 'Jumping Jacks',
            sets: '3', reps: '60 sec', rest: '30 sec',
            muscleGroup: 'Full Body / Cardio',
            instructions: 'Jump feet out while raising arms overhead. Keep core tight and land softly on balls of feet.',
            mediaAsset: 'assets/exercises/jumping_jacks.mp4',
            isVideo: true,
          ),
          WorkoutExercise(
            name: 'Burpees',
            sets: '3', reps: '12', rest: '45 sec',
            muscleGroup: 'Full Body',
            instructions: 'From standing, drop to a push-up position, perform a push-up, hop feet forward, then jump up with arms overhead.',
            mediaAsset: 'assets/exercises/burpees.jpeg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Bodyweight Squats',
            sets: '4', reps: '15', rest: '45 sec',
            muscleGroup: 'Legs / Glutes',
            instructions: 'Feet shoulder-width apart, toes slightly out. Squat until thighs are parallel to floor. Drive through heels to stand.',
            mediaAsset: 'assets/exercises/bodyweight_squats.mp4',
            isVideo: true,
          ),
          WorkoutExercise(
            name: 'Mountain Climbers',
            sets: '3', reps: '30 sec', rest: '30 sec',
            muscleGroup: 'Core / Cardio',
            instructions: 'Start in plank position. Alternate driving knees to chest as fast as possible. Keep hips level.',
            mediaAsset: 'assets/exercises/mountain_climbers.mp4',
            isVideo: true,
          ),
          WorkoutExercise(
            name: 'Push-Ups',
            sets: '3', reps: '12', rest: '45 sec',
            muscleGroup: 'Chest / Triceps',
            instructions: 'Keep body in a straight line from head to heels. Lower chest to floor then push back up. Do not let hips sag.',
            mediaAsset: 'assets/exercises/push_ups.jpg',
            isVideo: false,
          ),
        ],
      ),
      WorkoutPlan(
        name: 'Lower Body Burn',
        day: 'Day 2 — Tuesday',
        exercises: [
          WorkoutExercise(
            name: 'Treadmill / Brisk Walk',
            sets: '1', reps: '10 min warm-up', rest: '—',
            muscleGroup: 'Cardio',
            instructions: 'Walk at a moderate to brisk pace to warm up joints and raise heart rate before the main workout.',
            mediaAsset: 'assets/exercises/brisk_walk.mp4',
            isVideo: true,
          ),
          WorkoutExercise(
            name: 'Lunges',
            sets: '4', reps: '12 each leg', rest: '45 sec',
            muscleGroup: 'Quads / Glutes',
            instructions: 'Step forward and lower your back knee toward the floor. Keep front knee directly over ankle. Push back to start.',
            mediaAsset: 'assets/exercises/lunges.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Glute Bridges',
            sets: '3', reps: '15', rest: '30 sec',
            muscleGroup: 'Glutes / Hamstrings',
            instructions: 'Lie on your back with knees bent. Push hips up by squeezing glutes hard at the top. Hold 1 second then lower.',
            mediaAsset: 'assets/exercises/glute_bridges.mp4',
            isVideo: true,
          ),
          WorkoutExercise(
            name: 'Step-Ups',
            sets: '3', reps: '12 each leg', rest: '45 sec',
            muscleGroup: 'Quads / Glutes',
            instructions: 'Step onto a bench or sturdy stair. Drive through the heel of the raised leg to stand fully. Step back down slowly.',
            mediaAsset: 'assets/exercises/step_ups.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Jumping Rope',
            sets: '3', reps: '60 sec', rest: '45 sec',
            muscleGroup: 'Cardio',
            instructions: 'Keep elbows close to sides, rotate wrists not arms. Jump lightly on balls of feet. Stay rhythmic and consistent.',
            mediaAsset: 'assets/exercises/jumping_rope.jpg',
            isVideo: false,
          ),
        ],
      ),
      WorkoutPlan(
        name: 'Active Recovery',
        day: 'Day 3 — Wednesday',
        exercises: [
          WorkoutExercise(
            name: 'Light Jogging / Walking',
            sets: '1', reps: '30 min', rest: '—',
            muscleGroup: 'Cardio',
            instructions: 'Keep heart rate low (conversational pace). This is a recovery day — do not push hard. Focus on staying loose.',
            mediaAsset: 'assets/exercises/brisk_walk.mp4',
            isVideo: true,
          ),
          WorkoutExercise(
            name: 'Full Body Stretching',
            sets: '1', reps: '15 min', rest: '—',
            muscleGroup: 'Flexibility',
            instructions: 'Hold each stretch for 30 seconds without bouncing. Focus on hips, chest, hamstrings, back, and shoulders.',
            mediaAsset: 'assets/exercises/full_body_stretching.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Plank Hold',
            sets: '3', reps: '45 sec', rest: '30 sec',
            muscleGroup: 'Core',
            instructions: 'Keep hips level with shoulders and ankles. Engage your core and glutes. Breathe steadily throughout.',
            mediaAsset: 'assets/exercises/plank_hold.jpg',
            isVideo: false,
          ),
        ],
      ),
      WorkoutPlan(
        name: 'Upper Body + Cardio',
        day: 'Day 4 — Thursday',
        exercises: [
          WorkoutExercise(
            name: 'Jump Rope Warm-Up',
            sets: '1', reps: '5 min', rest: '—',
            muscleGroup: 'Cardio',
            instructions: 'Light pace to get heart rate up and warm up shoulders and wrists for the upper body work ahead.',
            mediaAsset: 'assets/exercises/jumping_rope.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Dumbbell Rows',
            sets: '3', reps: '12', rest: '45 sec',
            muscleGroup: 'Back / Biceps',
            instructions: 'Hinge at hips with flat back. Pull dumbbell up to hip. Squeeze your back at the top. Lower slowly.',
            mediaAsset: 'assets/exercises/dumbbell_rows.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Dumbbell Shoulder Press',
            sets: '3', reps: '12', rest: '45 sec',
            muscleGroup: 'Shoulders',
            instructions: 'Press dumbbells overhead from shoulder height. Lock out at top without arching your lower back. Lower with control.',
            mediaAsset: 'assets/exercises/dumbbell_shoulder_press.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Tricep Dips',
            sets: '3', reps: '12', rest: '45 sec',
            muscleGroup: 'Triceps',
            instructions: 'Use a sturdy chair or bench behind you. Lower until elbows reach 90 degrees. Push back up through your palms.',
            mediaAsset: 'assets/exercises/tricep_dips.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Bicycle Crunches',
            sets: '3', reps: '20', rest: '30 sec',
            muscleGroup: 'Core',
            instructions: 'Hands behind head, alternate bringing elbow to opposite knee while extending the other leg. Do not pull your neck.',
            mediaAsset: 'assets/exercises/bicycle_crunches.jpg',
            isVideo: false,
          ),
        ],
      ),
      WorkoutPlan(
        name: 'HIIT Circuit Finisher',
        day: 'Day 5 — Friday',
        exercises: [
          WorkoutExercise(
            name: 'High Knees',
            sets: '4', reps: '45 sec', rest: '15 sec',
            muscleGroup: 'Cardio',
            instructions: 'Run in place driving knees as high as possible. Pump arms in sync. Stay on balls of feet.',
            mediaAsset: 'assets/exercises/high_knees.mp4',
            isVideo: true,
          ),
          WorkoutExercise(
            name: 'Jump Squats',
            sets: '3', reps: '10', rest: '45 sec',
            muscleGroup: 'Legs / Power',
            instructions: 'Squat down to parallel then explode upward. Land softly with knees slightly bent to absorb impact.',
            mediaAsset: 'assets/exercises/jump_squats.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Push-Up to Shoulder Tap',
            sets: '3', reps: '10', rest: '45 sec',
            muscleGroup: 'Chest / Core',
            instructions: 'Perform a push-up, then at the top tap each shoulder alternately. Keep hips as still as possible.',
            mediaAsset: 'assets/exercises/push_up_shoulder_tap.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Russian Twists',
            sets: '3', reps: '20', rest: '30 sec',
            muscleGroup: 'Core',
            instructions: 'Sit at 45 degrees with feet off ground. Rotate torso left and right. Hold a weight for extra challenge.',
            mediaAsset: 'assets/exercises/russian_twists.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Cool Down Jog',
            sets: '1', reps: '10 min', rest: '—',
            muscleGroup: 'Cardio',
            instructions: 'Slow jog then walk to bring heart rate down gradually. Follow with stretching.',
            mediaAsset: 'assets/exercises/brisk_walk.mp4',
            isVideo: true,
          ),
        ],
      ),
    ];
  }

  static List<WorkoutPlan> getMuscleGainPlan() {
    return [
      WorkoutPlan(
        name: 'Chest & Triceps',
        day: 'Day 1 — Monday',
        exercises: [
          WorkoutExercise(
            name: 'Barbell Bench Press',
            sets: '4', reps: '8–10', rest: '90 sec',
            muscleGroup: 'Chest',
            instructions: 'Grip slightly wider than shoulders. Unrack, lower bar to mid-chest with control, then press explosively back up.',
            mediaAsset: 'assets/exercises/barbell_bench_press.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Incline Dumbbell Press',
            sets: '3', reps: '10–12', rest: '75 sec',
            muscleGroup: 'Upper Chest',
            instructions: 'Set bench to 30–45 degrees. Press from chest level upward. Squeeze upper chest hard at the top of each rep.',
            mediaAsset: 'assets/exercises/incline_dumbbell_press.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Cable Flyes',
            sets: '3', reps: '12–15', rest: '60 sec',
            muscleGroup: 'Chest',
            instructions: 'Wide arc motion bringing hands together at center. Squeeze chest hard at the peak. Keep slight bend in elbows throughout.',
            mediaAsset: 'assets/exercises/cable_flyes.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Close-Grip Bench Press',
            sets: '3', reps: '10', rest: '75 sec',
            muscleGroup: 'Triceps',
            instructions: 'Use a shoulder-width grip. Keep elbows tucked. Focus on squeezing triceps hard at full lockout.',
            mediaAsset: 'assets/exercises/close_grip_bench_press.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Overhead Tricep Extension',
            sets: '3', reps: '12', rest: '60 sec',
            muscleGroup: 'Triceps',
            instructions: 'Hold one dumbbell overhead with both hands. Lower behind head keeping elbows pointing forward. Extend fully.',
            mediaAsset: 'assets/exercises/overhead_tricep_extension.jpg',
            isVideo: false,
          ),
        ],
      ),
      WorkoutPlan(
        name: 'Back & Biceps',
        day: 'Day 2 — Tuesday',
        exercises: [
          WorkoutExercise(
            name: 'Pull-Ups / Lat Pulldown',
            sets: '4', reps: '8–10', rest: '90 sec',
            muscleGroup: 'Lats / Back',
            instructions: 'Full range of motion from dead hang to chin over bar. Squeeze lats at the bottom. Lower with full control.',
            mediaAsset: 'assets/exercises/pull_ups.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Barbell Rows',
            sets: '4', reps: '8–10', rest: '90 sec',
            muscleGroup: 'Back',
            instructions: 'Hinge at hips with slight arch in lower back. Pull bar to lower chest. Drive elbows back and squeeze shoulder blades.',
            mediaAsset: 'assets/exercises/barbell_rows.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Seated Cable Row',
            sets: '3', reps: '12', rest: '60 sec',
            muscleGroup: 'Back / Rear Delts',
            instructions: 'Pull handle to your abdomen. Squeeze shoulder blades together hard at the end. Control the return slowly.',
            mediaAsset: 'assets/exercises/seated_cable_row.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Barbell Curls',
            sets: '3', reps: '10–12', rest: '60 sec',
            muscleGroup: 'Biceps',
            instructions: 'Keep elbows fixed at sides throughout. Curl all the way up, squeeze at top, lower slowly. No swinging.',
            mediaAsset: 'assets/exercises/barbell_curls.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Hammer Curls',
            sets: '3', reps: '12', rest: '60 sec',
            muscleGroup: 'Biceps / Forearms',
            instructions: 'Neutral grip (thumbs facing up). Curl up keeping wrists straight. Targets brachialis and brachioradialis.',
            mediaAsset: 'assets/exercises/hammer_curls.jpg',
            isVideo: false,
          ),
        ],
      ),
      WorkoutPlan(
        name: 'Rest / Active Recovery',
        day: 'Day 3 — Wednesday',
        exercises: [
          WorkoutExercise(
            name: 'Light Cardio',
            sets: '1', reps: '20–30 min', rest: '—',
            muscleGroup: 'Cardio',
            instructions: 'Walk, cycle, or swim at low intensity. Keep it comfortable. This is not a hard training day.',
            mediaAsset: 'assets/exercises/brisk_walk.mp4',
            isVideo: true,
          ),
          WorkoutExercise(
            name: 'Foam Rolling',
            sets: '1', reps: '10 min', rest: '—',
            muscleGroup: 'Recovery',
            instructions: 'Roll slowly over quads, hamstrings, lats, and calves. Pause on tight spots for 20–30 seconds to release tension.',
            mediaAsset: 'assets/exercises/full_body_stretching.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Static Stretching',
            sets: '1', reps: '10 min', rest: '—',
            muscleGroup: 'Flexibility',
            instructions: 'Hold each stretch for 30 seconds. Focus on muscles worked in the last two days — chest, back, biceps, triceps.',
            mediaAsset: 'assets/exercises/full_body_stretching.jpg',
            isVideo: false,
          ),
        ],
      ),
      WorkoutPlan(
        name: 'Legs & Glutes',
        day: 'Day 4 — Thursday',
        exercises: [
          WorkoutExercise(
            name: 'Barbell Back Squat',
            sets: '4', reps: '8–10', rest: '120 sec',
            muscleGroup: 'Quads / Glutes',
            instructions: 'Bar rests on upper traps. Squat to parallel or below. Keep chest up and drive through heels to stand.',
            mediaAsset: 'assets/exercises/barbell_back_squat.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Romanian Deadlift',
            sets: '4', reps: '10', rest: '90 sec',
            muscleGroup: 'Hamstrings / Glutes',
            instructions: 'Hinge at hips keeping bar close to shins. Feel a strong hamstring stretch at bottom. Drive hips forward to stand.',
            mediaAsset: 'assets/exercises/romanian_deadlift.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Leg Press',
            sets: '3', reps: '12–15', rest: '90 sec',
            muscleGroup: 'Quads',
            instructions: 'Wide stance targets glutes, narrow targets quads. Do not lock knees fully at top. Lower with control.',
            mediaAsset: 'assets/exercises/leg_press.jpeg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Leg Curl',
            sets: '3', reps: '12', rest: '60 sec',
            muscleGroup: 'Hamstrings',
            instructions: 'Full range of motion. Curl up and squeeze hamstrings hard at the top. Lower slowly over 2–3 seconds.',
            mediaAsset: 'assets/exercises/leg_curl.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Calf Raises',
            sets: '4', reps: '15–20', rest: '45 sec',
            muscleGroup: 'Calves',
            instructions: 'Full extension and plantar flexion at top. Slow 3-second negative on the way down for maximum stretch.',
            mediaAsset: 'assets/exercises/calf_raises.jpg',
            isVideo: false,
          ),
        ],
      ),
      WorkoutPlan(
        name: 'Shoulders & Abs',
        day: 'Day 5 — Friday',
        exercises: [
          WorkoutExercise(
            name: 'Overhead Press',
            sets: '4', reps: '8–10', rest: '90 sec',
            muscleGroup: 'Shoulders',
            instructions: 'Press bar or dumbbells overhead from chin height. Full lockout at top. Do not lean back excessively.',
            mediaAsset: 'assets/exercises/overhead_press.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Lateral Raises',
            sets: '4', reps: '12–15', rest: '60 sec',
            muscleGroup: 'Side Delts',
            instructions: 'Slight bend in elbows. Raise dumbbells to shoulder level — no higher. Lead with your elbows, not your wrists.',
            mediaAsset: 'assets/exercises/lateral_raises.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Face Pulls',
            sets: '3', reps: '15', rest: '60 sec',
            muscleGroup: 'Rear Delts / Rotator Cuff',
            instructions: 'Pull rope to forehead level with elbows flared high. Excellent for shoulder health and posture.',
            mediaAsset: 'assets/exercises/face_pulls.jpg',
            isVideo: false,
          ),
          WorkoutExercise(
            name: 'Hanging Leg Raises',
            sets: '3', reps: '12', rest: '60 sec',
            muscleGroup: 'Core',
            instructions: 'Hang from a pull-up bar. Raise legs to 90 degrees with control. Avoid swinging. Lower slowly.',
            mediaAsset: 'assets/exercises/hanging_leg_raises.mp4',
            isVideo: true,
          ),
          WorkoutExercise(
            name: 'Cable Crunches',
            sets: '3', reps: '15', rest: '45 sec',
            muscleGroup: 'Abs',
            instructions: 'Kneel at cable machine. Crunch downward bringing elbows toward knees. Feel your abs contract. Do not use hip flexors.',
            mediaAsset: 'assets/exercises/cable_crunches.mp4',
            isVideo: true,
          ),
        ],
      ),
    ];
  }
}
