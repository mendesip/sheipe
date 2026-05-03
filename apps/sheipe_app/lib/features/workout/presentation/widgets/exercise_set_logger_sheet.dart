import 'package:flutter/material.dart';

class SetLoggerResult {
  const SetLoggerResult({this.weight, this.reps, this.rpe});
  final double? weight;
  final int? reps;
  final double? rpe;
}

class ExerciseSetLoggerSheet extends StatefulWidget {
  const ExerciseSetLoggerSheet({
    super.key,
    this.initialWeight,
    this.initialReps,
    this.initialRpe,
  });

  final double? initialWeight;
  final int? initialReps;
  final double? initialRpe;

  @override
  State<ExerciseSetLoggerSheet> createState() => _ExerciseSetLoggerSheetState();
}

class _ExerciseSetLoggerSheetState extends State<ExerciseSetLoggerSheet> {
  late final _weight = TextEditingController(text: widget.initialWeight?.toString() ?? '');
  late final _reps = TextEditingController(text: widget.initialReps?.toString() ?? '');
  late final _rpe = TextEditingController(text: widget.initialRpe?.toString() ?? '');

  @override
  void dispose() {
    _weight.dispose();
    _reps.dispose();
    _rpe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _weight,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
            ),
            TextField(
              controller: _reps,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Reps'),
            ),
            TextField(
              controller: _rpe,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'RPE (1–10)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  SetLoggerResult(
                    weight: double.tryParse(_weight.text),
                    reps: int.tryParse(_reps.text),
                    rpe: double.tryParse(_rpe.text),
                  ),
                );
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
