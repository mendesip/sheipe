import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/workout.dart';
import '../viewmodels/workout_history_state.dart';
import '../viewmodels/workout_history_view_model.dart';

class WorkoutDetailScreen extends StatefulWidget {
  const WorkoutDetailScreen({super.key, required this.workoutId});

  final String workoutId;

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkoutHistoryViewModel>().loadHistory();
  }

  Workout? _findWorkout(WorkoutHistoryState state) {
    if (state is! WorkoutHistoryLoaded) return null;
    final matches = state.items.where((w) => w.id == widget.workoutId);
    return matches.isEmpty ? null : matches.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout')),
      body: BlocBuilder<WorkoutHistoryViewModel, WorkoutHistoryState>(
        builder: (context, state) {
          final w = _findWorkout(state);
          if (w == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: [
              ListTile(
                title: Text('Started: ${w.startedAt}'),
                subtitle: w.finishedAt != null ? Text('Finished: ${w.finishedAt}') : null,
              ),
              const Divider(),
              for (final we in w.exercises)
                ExpansionTile(
                  title: Text('Exercise ${we.position}'),
                  subtitle: Text('${we.sets.length} sets'),
                  children: [
                    for (final s in we.sets)
                      ListTile(
                        dense: true,
                        title: Text('Set ${s.setNumber}'),
                        subtitle: Text(
                          '${s.weight ?? '—'}kg · ${s.reps ?? '—'} reps · RPE ${s.rpe ?? '—'}',
                        ),
                      ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
