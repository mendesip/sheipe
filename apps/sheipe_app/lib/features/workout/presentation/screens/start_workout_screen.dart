import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/viewmodels/auth_state.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';
import '../../../routine/presentation/viewmodels/routine_state.dart';
import '../../../routine/presentation/viewmodels/routine_view_model.dart';
import '../viewmodels/active_workout_view_model.dart';

class StartWorkoutScreen extends StatefulWidget {
  const StartWorkoutScreen({super.key});

  @override
  State<StartWorkoutScreen> createState() => _StartWorkoutScreenState();
}

class _StartWorkoutScreenState extends State<StartWorkoutScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RoutineViewModel>().loadRoutines();
  }

  Future<void> _start({String? routineId}) async {
    final auth = context.read<AuthViewModel>().state;
    if (auth is! AuthAuthenticated) return;
    final vm = context.read<ActiveWorkoutViewModel>();
    await vm.startWorkout(userId: auth.user.id, routineId: routineId);
    if (!mounted) return;
    final id = (vm.state as dynamic).workout?.id as String?;
    if (id != null) {
      Navigator.pushNamed(context, '/workouts/$id/active');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start workout')),
      body: BlocBuilder<RoutineViewModel, RoutineState>(
        builder: (context, state) {
          final routines = state is RoutineLoaded ? state.items : const [];
          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.bolt),
                title: const Text('Start free workout'),
                onTap: () => _start(),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text('Or pick a routine', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              for (final r in routines)
                ListTile(
                  title: Text(r.name),
                  subtitle: Text('${r.exercises.length} exercises'),
                  onTap: () => _start(routineId: r.id),
                ),
            ],
          );
        },
      ),
    );
  }
}
