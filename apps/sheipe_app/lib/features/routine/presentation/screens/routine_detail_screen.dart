import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/routine.dart';
import '../viewmodels/routine_state.dart';
import '../viewmodels/routine_view_model.dart';

class RoutineDetailScreen extends StatefulWidget {
  const RoutineDetailScreen({super.key, required this.routineId});

  final String routineId;

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RoutineViewModel>().loadRoutines();
  }

  Routine? _findRoutine(RoutineState state) {
    if (state is! RoutineLoaded) return null;
    final matches = state.items.where((r) => r.id == widget.routineId);
    return matches.isEmpty ? null : matches.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routine'),
        actions: [
          Builder(
            builder: (innerCtx) => IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await innerCtx.read<RoutineViewModel>().deleteRoutine(widget.routineId);
                if (innerCtx.mounted) Navigator.of(innerCtx).pop();
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<RoutineViewModel, RoutineState>(
        builder: (context, state) {
          if (state is RoutineLoading || state is RoutineInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          final routine = _findRoutine(state);
          if (routine == null) {
            return const Center(child: Text('Routine not found'));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(routine.name, style: Theme.of(context).textTheme.headlineSmall),
              ),
              if (routine.description != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(routine.description!),
                ),
              const Divider(),
              Expanded(
                child: routine.exercises.isEmpty
                    ? const Center(child: Text('No exercises in this routine'))
                    : ListView.builder(
                        itemCount: routine.exercises.length,
                        itemBuilder: (_, i) {
                          final re = routine.exercises[i];
                          return ExpansionTile(
                            title: Text('Exercise ${re.position}'),
                            subtitle: Text('${re.sets.length} sets'),
                            children: re.sets
                                .map((s) => ListTile(
                                      dense: true,
                                      title: Text('Set ${s.setNumber}'),
                                      subtitle: Text(
                                        [
                                          if (s.weight != null) '${s.weight}kg',
                                          if (s.reps != null) '${s.reps} reps',
                                          s.setType,
                                        ].join(' · '),
                                      ),
                                    ))
                                .toList(),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
