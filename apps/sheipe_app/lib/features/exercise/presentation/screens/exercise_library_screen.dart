import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/exercise.dart';
import '../viewmodels/exercise_state.dart';
import '../viewmodels/exercise_view_model.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key, this.selectionMode = false, this.onSelected});

  /// When true, tapping a row returns the exercise via [onSelected].
  final bool selectionMode;
  final void Function(Exercise exercise)? onSelected;

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  final _searchController = TextEditingController();
  String? _muscleGroup;
  String? _category;

  @override
  void initState() {
    super.initState();
    context.read<ExerciseViewModel>().loadExercises();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    context.read<ExerciseViewModel>().loadExercises(
          muscleGroup: _muscleGroup,
          category: _category,
          query: _searchController.text.isEmpty ? null : _searchController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectionMode ? 'Pick an exercise' : 'Exercises'),
      ),
      floatingActionButton: widget.selectionMode
          ? null
          : FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/exercises/new'),
              child: const Icon(Icons.add),
            ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search exercises',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _applyFilters(),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                ..._muscleChips(),
                const SizedBox(width: 8),
                ..._categoryChips(),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ExerciseViewModel, ExerciseState>(
              builder: (context, state) {
                if (state is ExerciseLoading || state is ExerciseInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ExerciseError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                final loaded = state as ExerciseLoaded;
                if (loaded.items.isEmpty) {
                  return const Center(child: Text('No exercises'));
                }
                return ListView.separated(
                  itemCount: loaded.items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, i) => _row(loaded.items[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Iterable<Widget> _muscleChips() => const [
        'chest', 'back', 'shoulders', 'biceps', 'triceps', 'legs', 'glutes', 'core', 'full_body',
      ].map((m) {
        final selected = _muscleGroup == m;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(m),
            selected: selected,
            onSelected: (s) {
              setState(() => _muscleGroup = s ? m : null);
              _applyFilters();
            },
          ),
        );
      });

  Iterable<Widget> _categoryChips() => const ['strength', 'cardio', 'mobility'].map((c) {
        final selected = _category == c;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(c),
            selected: selected,
            onSelected: (s) {
              setState(() => _category = s ? c : null);
              _applyFilters();
            },
          ),
        );
      });

  Widget _row(Exercise e) {
    return ListTile(
      title: Text(e.name),
      subtitle: Text('${e.muscleGroup} · ${e.category}'),
      trailing: e.isSystem ? const Icon(Icons.verified, size: 16) : null,
      onTap: () {
        if (widget.selectionMode) {
          widget.onSelected?.call(e);
          Navigator.pop(context, e);
        } else {
          Navigator.pushNamed(context, '/exercises/${e.id}');
        }
      },
    );
  }
}
