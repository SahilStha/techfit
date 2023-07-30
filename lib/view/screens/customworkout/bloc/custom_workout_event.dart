// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'custom_workout_bloc.dart';

abstract class CustomWorkoutEvent {
  const CustomWorkoutEvent();
}

class GetCustomWorkouts extends CustomWorkoutEvent {
  final String email;
  GetCustomWorkouts({
    required this.email,
  });
}

class GetHeatLevels extends CustomWorkoutEvent {
  final String email;
  GetHeatLevels({
    required this.email,
  });
}

class GetExcercise extends CustomWorkoutEvent {
  final String id;
  final String email;
  GetExcercise({
    required this.id,
    required this.email,
  });
}

class DeleteWorkout extends CustomWorkoutEvent {
  final String workoutId;

  DeleteWorkout({required this.workoutId});
}

class CreateCustomWorkout extends CustomWorkoutEvent {
  final String userKey;
  final String workoutName;
  CreateCustomWorkout({
    required this.userKey,
    required this.workoutName,
  });
}

class GetVideos extends CustomWorkoutEvent {}
