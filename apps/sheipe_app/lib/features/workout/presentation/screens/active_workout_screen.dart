import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../exercise/domain/entities/exercise.dart';
import '../viewmodels/active_workout_state.dart';
import '../viewmodels/active_workout_view_model.dart';
import '../widgets/add_exercise_sheet.dart';
import '../widgets/exercise_set_logger_sheet.dart';
import '../widgets/rest_timer_overlay.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  const ActiveWorkoutScreen({super.key, required this.workoutId});

  final String workoutId;

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  @override
  void initState() {
    super.initState();
    final vm = context.read<ActiveWorkoutViewModel>();
    if (vm.state is! ActiveWorkoutInProgress) {
      vm.resume(widget.workoutId);
    }
  }

  Future<bool> _confirmDiscard() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard workout?'),
        content: const Text('This workout has not been finished. Discard it?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Discard')),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<void> _finish() async {
    final vm = context.read<ActiveWorkoutViewModel>();
    await vm.finishWorkout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/workouts/${widget.workoutId}/summary');
  }

  Future<void> _addExercise() async {
    final picked = await showModalBottomSheet<Exercise>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddExerciseSheet(),
    );
    if (picked == null || !mounted) return;
    await context.read<ActiveWorkoutViewModel>().addExercise(exerciseId: picked.id);
  }

  Future<void> _logSet(String workoutExerciseId, int nextSetNumber) async {
    final result = await showModalBottomSheet<SetLoggerResult>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ExerciseSetLoggerSheet(),
    );
    if (result == null || !mounted) return;
    await context.read<ActiveWorkoutViewModel>().logSet(
          workoutExerciseId: workoutExerciseId,
          setNumber: nextSetNumber,
          weight: result.weight,
          reps: result.reps,
          rpe: result.rpe,
        );
    if (!mounted) return;
    context.read<ActiveWorkoutViewModel>().startRestTimer(90);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final discard = await _confirmDiscard();
        if (!discard) return;
        if (!context.mounted) return;
        Navigator.of(context).pop();
      },
      child: BlocBuilder<ActiveWorkoutViewModel, ActiveWorkoutState>(
        builder: (context, state) {
          if (state is! ActiveWorkoutInProgress) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          final w = state.workout;
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: const Text('Active workout'),
                  actions: [
                    TextButton(onPressed: _finish, child: const Text('Finish')),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: _addExercise,
                  child: const Icon(Icons.add),
                ),
                body: w.exercises.isEmpty
                    ? const Center(child: Text('Tap + to add an exercise'))
                    : ListView.builder(
                        itemCount: w.exercises.length,
                        itemBuilder: (_, i) {
                          final we = w.exercises[i];
                          return ExpansionTile(
                            initiallyExpanded: true,
                            title: Text('Exercise ${we.position}'),
                            children: [
                              ...we.sets.map((s) => ListTile(
                                    dense: true,
                                    title: Text('Set ${s.setNumber}'),
                                    subtitle: Text(
                                      '${s.weight ?? '—'}kg · ${s.reps ?? '—'} reps · RPE ${s.rpe ?? '—'}',
                                    ),
                                    trailing: Icon(
                                      s.completed ? Icons.check_circle : Icons.radio_button_unchecked,
                                      color: s.completed ? Colors.green : null,
                                    ),
                                  )),
                              TextButton.icon(
                                onPressed: () => _logSet(we.id, we.sets.length + 1),
                                icon: const Icon(Icons.add),
                                label: const Text('Log set'),
                              ),
                            ],
                          );
                        },
                      ),
              ),
              if (state.currentRestSeconds > 0)
                RestTimerOverlay(
                  seconds: state.currentRestSeconds,
                  onComplete: () => context.read<ActiveWorkoutViewModel>().clearRestTimer(),
                  onSkip: () => context.read<ActiveWorkoutViewModel>().clearRestTimer(),
                ),
            ],
          );
        },
      ),
    );
  }
}
