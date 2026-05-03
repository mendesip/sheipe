import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodels/routine_state.dart';
import '../viewmodels/routine_view_model.dart';

class RoutinesListScreen extends StatefulWidget {
  const RoutinesListScreen({super.key});

  @override
  State<RoutinesListScreen> createState() => _RoutinesListScreenState();
}

class _RoutinesListScreenState extends State<RoutinesListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RoutineViewModel>().loadRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Routines')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/routines/new'),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<RoutineViewModel, RoutineState>(
        builder: (context, state) {
          if (state is RoutineLoading || state is RoutineInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RoutineError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          final loaded = state as RoutineLoaded;
          if (loaded.items.isEmpty) {
            return const Center(child: Text('No routines yet'));
          }
          return ListView.separated(
            itemCount: loaded.items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final r = loaded.items[i];
              return ListTile(
                title: Text(r.name),
                subtitle: Text('${r.exercises.length} exercises'),
                onTap: () => Navigator.pushNamed(context, '/routines/${r.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
