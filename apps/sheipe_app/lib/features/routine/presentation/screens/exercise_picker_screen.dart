import 'package:flutter/material.dart';
import '../../../exercise/presentation/screens/exercise_library_screen.dart';

/// Thin wrapper that pushes the [ExerciseLibraryScreen] in selection mode.
/// Returned via Navigator.pop with the selected `Exercise`.
class ExercisePickerScreen extends StatelessWidget {
  const ExercisePickerScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const ExerciseLibraryScreen(selectionMode: true);
}
