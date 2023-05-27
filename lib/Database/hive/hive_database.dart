// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:hive/hive.dart';
import 'package:work_out/datetime/date_time.dart';
import 'package:work_out/view/screens/customworkout/exercise.dart';
import '../../view/screens/customworkout/workout.dart';

class HiveDatabase {
// refrence our hive box
  final _myBox = Hive.box("workout_database1");
// check if there is already data stored, if not, record the start date
  bool previousDateExists() {
    if (_myBox.isEmpty) {
      print('previous data does not exist');
      _myBox.put("Start_Date", todaysDateYYYYMMDD());
      return false;
    } else {
      print('previous data exists');
      return true;
    }
  }

// return start date as yyyymmdd
  String getStartDate() {
    return _myBox.get("Start_Date");
  }

// write data
  void saveToDatabase(List<Workout> workouts) {
    // convert workout objects into lists of strings so that we an save in hive
    final WorkoutsList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETIION_STATUS" + todaysDateYYYYMMDD(), 1);
    } else {
      _myBox.put("COMPLETIION_STATUS" + todaysDateYYYYMMDD(), 0);
    }

    // save into hive
    _myBox.put("Workouts", WorkoutsList);
    _myBox.put("Exercises", exerciseList);
  }

// read data, and return a list of workouts
  List<Workout> readFromDatabse() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("Workouts");
    final exerciseDetails = _myBox.get("Exercises");

    // create workout objects
    for (int i = 0; i < workoutNames.length; i++) {
      // each workout can have multiple exercises
      List<Exercise> exerciseINEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        // so add each exercise into a list
        exerciseINEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
          ),
        );
      }
      // create individual workout
      Workout workout =
          Workout(name: workoutNames[i], exercises: exerciseINEachWorkout);
      // add individual wokout to overall list
      mySavedWorkouts.add(workout);
    }
    return mySavedWorkouts;
  }

// check if any exercises have been done
  bool exerciseCompleted(List<Workout> workouts) {
    // go throuch each workout
    for (var workout in workouts) {
      // go through each exercise in workout
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

// return completion status of a given date yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    // returns 0 or 1, if null then return 0
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }
}

// convert workout objects into a list
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [
    // eg: [upperbody, lower body]
  ];

  for (int i = 0; i < workouts.length; i++) {
    // in each workout, add the name, followed by list of exercise
    workoutList.add(
      workouts[i].name,
    );
  }
  return workoutList;
}

// converts exercises in a workout object into a list of strings
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];

  // go through each workout
  for (int i = 0; i < workouts.length; i++) {
    // get exercises from each workout
    List<Exercise> exerciseInWorkout = workouts[i].exercises;

    List<List<String>> individualWorkout = [
      // upper body
      // [biceps, kg, reps, sets]
    ];

    // go through each exercise in exercise list
    for (int j = 0; j < exerciseInWorkout.length; j++) {
      List<String> individualExercise = [];

      individualExercise.addAll(
        [
          exerciseInWorkout[j].name,
          exerciseInWorkout[j].weight,
          exerciseInWorkout[j].reps,
          exerciseInWorkout[j].sets,
          exerciseInWorkout[j].isCompleted.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }

    exerciseList.add(individualWorkout);
  }

  return exerciseList;
}
