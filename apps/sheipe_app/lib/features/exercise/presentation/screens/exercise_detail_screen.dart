import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/exercise.dart';
import '../viewmodels/exercise_view_model.dart';

class ExerciseDetailScreen extends StatefulWidget {
  const ExerciseDetailScreen({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  Exercise? _exercise;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // Read once from local repo (no live stream needed for detail)
    final repo = context.read<ExerciseViewModel>();
    // The view model exposes only collection ops; reach into the repository
    // would couple this widget too tightly. Instead we re-trigger a load and
    // pluck from state below.
    await repo.loadExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise')),
      body: BlocBuilder<ExerciseViewModel, dynamic>(
        builder: (context, state) {
          // Find from current state for now.
          final dynamic dyn = state;
          final List<Exercise> items =
              (dyn.items is List<Exercise>) ? dyn.items as List<Exercise> : const [];
          _exercise = items.where((e) => e.id == widget.exerciseId).firstOrNull;
          final ex = _exercise;
          if (ex == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ex.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('${ex.muscleGroup} · ${ex.category}'),
                const SizedBox(height: 16),
                if (ex.description != null) Text(ex.description!),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _exercise?.isSystem == false
          ? FloatingActionButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/exercises/${widget.exerciseId}/edit'),
              child: const Icon(Icons.edit),
            )
          : null,
    );
  }
}

extension on Iterable<Exercise> {
  Exercise? get firstOrNull => isEmpty ? null : first;
}
