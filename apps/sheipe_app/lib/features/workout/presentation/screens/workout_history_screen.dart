import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodels/workout_history_state.dart';
import '../viewmodels/workout_history_view_model.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkoutHistoryViewModel>().loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout history')),
      body: BlocBuilder<WorkoutHistoryViewModel, WorkoutHistoryState>(
        builder: (context, state) {
          if (state is WorkoutHistoryLoading || state is WorkoutHistoryInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WorkoutHistoryError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          final loaded = state as WorkoutHistoryLoaded;
          if (loaded.items.isEmpty) {
            return const Center(child: Text('No workouts yet'));
          }
          return ListView.separated(
            itemCount: loaded.items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final w = loaded.items[i];
              return ListTile(
                title: Text(_dateLabel(w.startedAt)),
                subtitle: Text(
                  '${w.exercises.length} exercises · ${w.isInProgress ? 'in progress' : 'finished'}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, '/workouts/${w.id}'),
              );
            },
          );
        },
      ),
    );
  }

  String _dateLabel(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
