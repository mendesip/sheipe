import '../../domain/entities/routine.dart';

sealed class RoutineState {
  const RoutineState();
}

final class RoutineInitial extends RoutineState {
  const RoutineInitial();
}

final class RoutineLoading extends RoutineState {
  const RoutineLoading();
}

final class RoutineLoaded extends RoutineState {
  const RoutineLoaded(this.items);
  final List<Routine> items;
}

final class RoutineError extends RoutineState {
  const RoutineError(this.message);
  final String message;
}
