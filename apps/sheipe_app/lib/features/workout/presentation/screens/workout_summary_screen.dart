import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodels/active_workout_state.dart';
import '../viewmodels/active_workout_view_model.dart';

class WorkoutSummaryScreen extends StatelessWidget {
  const WorkoutSummaryScreen({super.key, required this.workoutId});

  final String workoutId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout summary')),
      body: BlocBuilder<ActiveWorkoutViewModel, ActiveWorkoutState>(
        builder: (context, state) {
          if (state is! ActiveWorkoutFinished) {
            return const Center(child: CircularProgressIndicator());
          }
          final w = state.workout;
          final totalSets =
              w.exercises.fold<int>(0, (sum, we) => sum + we.sets.length);
          final volume = w.exercises.fold<double>(
            0,
            (sum, we) => sum +
                we.sets.fold<double>(
                  0,
                  (s, set) => s + ((set.weight ?? 0) * (set.reps ?? 0)),
                ),
          );
          final duration = w.finishedAt != null
              ? w.finishedAt!.difference(w.startedAt)
              : Duration.zero;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total sets: $totalSets', style: Theme.of(context).textTheme.titleMedium),
                Text('Total volume: ${volume.toStringAsFixed(1)} kg'),
                Text('Duration: ${_format(duration)}'),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.share),
                  label: const Text('Share (coming soon)'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                  child: const Text('Done'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _format(Duration d) {
    final mins = d.inMinutes;
    final secs = d.inSeconds % 60;
    return '${mins}m ${secs.toString().padLeft(2, '0')}s';
  }
}
