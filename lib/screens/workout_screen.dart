import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/user_model.dart';
import '../services/workout_service.dart';

class WorkoutScreen extends StatefulWidget {
  final UserModel user;
  const WorkoutScreen({super.key, required this.user});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int _selectedDay = 0;

  @override
  Widget build(BuildContext context) {
    final isLoseFat = widget.user.goal == 'lose_fat';
    final plans = isLoseFat
        ? WorkoutService.getFatLossPlan()
        : WorkoutService.getMuscleGainPlan();
    final plan = plans[_selectedDay];
    final accentColor =
        isLoseFat ? const Color(0xFFFF6B35) : const Color(0xFF1DB954);

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isLoseFat ? '🔥 Fat Loss Plan' : '💪 Muscle Building Plan',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                '5 days/week · ${isLoseFat ? 'HIIT + Cardio' : 'Progressive Overload'}',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 14),
              // Day selector
              SizedBox(
                height: 42,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: plans.length,
                  itemBuilder: (context, i) {
                    final selected = i == _selectedDay;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDay = i),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? accentColor : const Color(0xFF1A2332),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Day ${i + 1}',
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.grey,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              // Day card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: accentColor.withOpacity(0.4)),
                ),
                child: Row(children: [
                  Icon(
                      isLoseFat
                          ? Icons.local_fire_department
                          : Icons.fitness_center,
                      color: accentColor,
                      size: 26),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(plan.day,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 11)),
                          Text(plan.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ]),
                  ),
                  Text('${plan.exercises.length} exercises',
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 12)),
                ]),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
        // Exercise list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            itemCount: plan.exercises.length,
            itemBuilder: (context, i) {
              return _ExerciseCard(
                exercise: plan.exercises[i],
                index: i + 1,
                accentColor: accentColor,
              );
            },
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Exercise card with video / image player
// ──────────────────────────────────────────────
class _ExerciseCard extends StatefulWidget {
  final WorkoutExercise exercise;
  final int index;
  final Color accentColor;

  const _ExerciseCard({
    required this.exercise,
    required this.index,
    required this.accentColor,
  });

  @override
  State<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<_ExerciseCard> {
  bool _expanded = false;
  VideoPlayerController? _videoCtrl;
  bool _videoReady = false;
  bool _videoError = false;

  @override
  void dispose() {
    _videoCtrl?.dispose();
    super.dispose();
  }

  Future<void> _initVideo() async {
    if (_videoCtrl != null) return;
    try {
      final ctrl = VideoPlayerController.asset(widget.exercise.mediaAsset);
      _videoCtrl = ctrl;
      await ctrl.initialize();
      ctrl.setLooping(true);
      ctrl.setVolume(0);
      ctrl.play();
      if (mounted) setState(() => _videoReady = true);
    } catch (_) {
      if (mounted) setState(() => _videoError = true);
    }
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded && widget.exercise.isVideo) {
      _initVideo();
    } else if (!_expanded) {
      _videoCtrl?.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.accentColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(16),
        border: _expanded
            ? Border.all(color: color.withOpacity(0.4))
            : Border.all(color: Colors.transparent),
      ),
      child: Column(
        children: [
          // ── Header row (always visible) ──
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                // Index circle
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.15), shape: BoxShape.circle),
                  child: Center(
                    child: Text('${widget.index}',
                        style: TextStyle(
                            color: color, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.exercise.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(widget.exercise.muscleGroup,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 11)),
                      ]),
                ),
                // Sets / reps chips
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  _chip('${widget.exercise.sets} sets', color),
                  const SizedBox(height: 4),
                  _chip(widget.exercise.reps, Colors.blue.shade300),
                ]),
                const SizedBox(width: 8),
                // Media type badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: widget.exercise.isVideo
                        ? Colors.red.withOpacity(0.15)
                        : Colors.purple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    widget.exercise.isVideo
                        ? Icons.play_circle_outline
                        : Icons.image_outlined,
                    color: widget.exercise.isVideo
                        ? Colors.red.shade300
                        : Colors.purple.shade200,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey),
              ]),
            ),
          ),

          // ── Expanded content ──
          if (_expanded) ...[
            const Divider(color: Color(0xFF263040), height: 1),

            // Media player area
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.zero),
              child: _buildMediaPlayer(color),
            ),

            // Instructions + stats
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rest time
                    Row(children: [
                      Icon(Icons.timer_outlined, color: color, size: 16),
                      const SizedBox(width: 6),
                      Text('Rest: ${widget.exercise.rest}',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13)),
                    ]),
                    const SizedBox(height: 10),
                    // Stats row
                    Row(children: [
                      _statBadge('Sets', widget.exercise.sets, color),
                      const SizedBox(width: 8),
                      _statBadge('Reps', widget.exercise.reps,
                          Colors.blue.shade300),
                      const SizedBox(width: 8),
                      _statBadge('Rest', widget.exercise.rest,
                          Colors.orange.shade300),
                    ]),
                    const SizedBox(height: 12),
                    // Instructions box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F1923),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: color.withOpacity(0.2)),
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline,
                                color: color, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.exercise.instructions,
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    height: 1.5),
                              ),
                            ),
                          ]),
                    ),
                  ]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMediaPlayer(Color color) {
    if (widget.exercise.isVideo) {
      // ── VIDEO ──
      if (_videoError) {
        return _mediaPlaceholder(
            color, Icons.error_outline, 'Could not load video');
      }
      if (!_videoReady) {
        return Container(
          height: 200,
          color: const Color(0xFF0F1923),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: color, strokeWidth: 2),
                const SizedBox(height: 12),
                const Text('Loading video...',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ]),
        );
      }
      // Video ready
      return Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _videoCtrl!.value.aspectRatio,
            child: VideoPlayer(_videoCtrl!),
          ),
          // Muted badge
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(children: [
                Icon(Icons.volume_off, color: Colors.white, size: 13),
                SizedBox(width: 4),
                Text('Looping',
                    style:
                        TextStyle(color: Colors.white, fontSize: 11)),
              ]),
            ),
          ),
          // Play/pause overlay tap
          GestureDetector(
            onTap: () {
              setState(() {
                _videoCtrl!.value.isPlaying
                    ? _videoCtrl!.pause()
                    : _videoCtrl!.play();
              });
            },
            child: AnimatedOpacity(
              opacity:
                  _videoCtrl!.value.isPlaying ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.85),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow,
                    color: Colors.white, size: 32),
              ),
            ),
          ),
        ],
      );
    } else {
      // ── IMAGE ──
      return ClipRect(
        child: Image.asset(
          widget.exercise.mediaAsset,
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _mediaPlaceholder(
              color, Icons.image_not_supported_outlined, 'Image unavailable'),
        ),
      );
    }
  }

  Widget _mediaPlaceholder(Color color, IconData icon, String msg) {
    return Container(
      height: 180,
      color: const Color(0xFF0F1923),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: Colors.grey, size: 36),
        const SizedBox(height: 8),
        Text(msg,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ]),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(6)),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _statBadge(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(children: [
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ]),
      ),
    );
  }
}
