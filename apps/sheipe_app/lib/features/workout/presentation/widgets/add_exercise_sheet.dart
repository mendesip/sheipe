import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../exercise/domain/entities/exercise.dart';
import '../../../exercise/presentation/viewmodels/exercise_state.dart';
import '../../../exercise/presentation/viewmodels/exercise_view_model.dart';

/// Lightweight bottom-sheet picker for adding an exercise to an active
/// workout. Returns the selected [Exercise] via Navigator.pop.
class AddExerciseSheet extends StatefulWidget {
  const AddExerciseSheet({super.key});

  @override
  State<AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends State<AddExerciseSheet> {
  final _query = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ExerciseViewModel>().loadExercises();
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _query,
                decoration: const InputDecoration(
                  hintText: 'Search exercises',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (q) => context.read<ExerciseViewModel>().loadExercises(query: q),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<ExerciseViewModel, ExerciseState>(
                  builder: (context, state) {
                    if (state is! ExerciseLoaded) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView(
                      children: [
                        for (final e in state.items)
                          ListTile(
                            title: Text(e.name),
                            subtitle: Text('${e.muscleGroup} · ${e.category}'),
                            onTap: () => Navigator.pop<Exercise>(context, e),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
