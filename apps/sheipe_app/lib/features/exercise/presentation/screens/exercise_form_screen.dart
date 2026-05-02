import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/exercise.dart';
import '../viewmodels/exercise_view_model.dart';

class ExerciseFormScreen extends StatefulWidget {
  const ExerciseFormScreen({super.key, this.existing});

  final Exercise? existing;

  @override
  State<ExerciseFormScreen> createState() => _ExerciseFormScreenState();
}

class _ExerciseFormScreenState extends State<ExerciseFormScreen> {
  late final TextEditingController _name;
  late final TextEditingController _description;
  String _muscleGroup = 'chest';
  String _category = 'strength';

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.existing?.name ?? '');
    _description = TextEditingController(text: widget.existing?.description ?? '');
    _muscleGroup = widget.existing?.muscleGroup ?? 'chest';
    _category = widget.existing?.category ?? 'strength';
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final vm = context.read<ExerciseViewModel>();
    final exercise = Exercise(
      id: widget.existing?.id ?? '',
      name: _name.text.trim(),
      muscleGroup: _muscleGroup,
      category: _category,
      description: _description.text.trim().isEmpty ? null : _description.text.trim(),
      isSystem: widget.existing?.isSystem ?? false,
      creatorId: widget.existing?.creatorId,
    );
    await vm.createExercise(exercise);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? 'New exercise' : 'Edit exercise')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _muscleGroup,
              items: const [
                'chest', 'back', 'shoulders', 'biceps', 'triceps',
                'legs', 'glutes', 'core', 'full_body',
              ].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              onChanged: (v) => setState(() => _muscleGroup = v ?? 'chest'),
              decoration: const InputDecoration(labelText: 'Muscle group'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              items: const ['strength', 'cardio', 'mobility']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v ?? 'strength'),
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _description,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
