// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'excersice_bloc.dart';

abstract class ExcersiseEvent {}

class GetExcersiseFromWorkout extends ExcersiseEvent {
  final String workoutId;
  GetExcersiseFromWorkout({
    required this.workoutId,
  });
}

class DeleteExcersie extends ExcersiseEvent {
  final String excersiseId;
  DeleteExcersie({
    required this.excersiseId,
  });
}

class CompleteUncompleteExcersise extends ExcersiseEvent {
  final String excersieId;
  CompleteUncompleteExcersise({
    required this.excersieId,
  });
}

class CreateExcersise extends ExcersiseEvent {
  final String name;
  final String workoutId;
  final num weight;
  final num reps;
  final num sets;
  CreateExcersise({
    required this.name,
    required this.workoutId,
    required this.weight,
    required this.reps,
    required this.sets,
  });
}
