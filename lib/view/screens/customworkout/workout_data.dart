import 'package:flutter/cupertino.dart';
import 'package:work_out/Database/hive/hive_database.dart';
import 'package:work_out/datetime/date_time.dart';
import 'package:work_out/view/screens/customworkout/exercise.dart';
import 'package:work_out/view/screens/customworkout/workout.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();

  //Workout data structure

  List<Workout> workotList = [
    Workout(
      name: 'Upper Body',
      exercises: [
        Exercise(name: 'Biceps', weight: '7.5', reps: '12', sets: '3')
      ],
    ),
    Workout(
      name: 'Lower body',
      exercises: [Exercise(name: 'Calf', weight: '25', reps: '12', sets: '3')],
    )
  ];

  // if there are workouts already in database , then get that workout list,
  void initalizeWorkoutList() {
    if (db.previousDateExists()) {
      workotList = db.readFromDatabse();
    }
    // otherwise use defalut workout
    else {
      db.saveToDatabase(workotList);
    }

    // load heat map
    loadHeatMap();
  }

  //get the list of workouts
  List<Workout> getWorkoutList() {
    return workotList;
  }

  //get the length of a given workout
  int numberOfExerciseInWOrkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  // add a workout
  void addWorkout(String name) {
    workotList.add(Workout(name: name, exercises: []));

    notifyListeners();
    // save to database
    db.saveToDatabase(workotList);
  }

  // add an exercise to a workout
  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    // finding the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets),
    );

    notifyListeners();
    // save to database
    db.saveToDatabase(workotList);
  }

  // check off exercise
  void checkoffExercise(String workoutName, String exerciseName) {
    //find the relevant workout and relevant exercise in that workout
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    //check off boolean to show user complete the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    print('tapped');

    notifyListeners();

    // save to database
    db.saveToDatabase(workotList);

    // load heat map
    loadHeatMap();
  }

  //get length of a given workout

  //return relevant workout object, given a workout name + exercise name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workotList.firstWhere((workout) => workout.name == workoutName);
    return relevantWorkout;
  }

  //return relevant exercise object, given a workout name + exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    //find relevant workout first
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    //then find the relevant exercise in that workout
    Exercise relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);
    return relevantExercise;
  }

  // get start date
  String getStartDate() {
    return db.getStartDate();
  }

  Map<DateTime, int> heatMapDataSet = {};

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());

    // count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // go from startdate to today and add each completion status to the dataset
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd =
          convertDateTimeToYYYYMMDD(startDate.add(Duration(days: i)));

      // completion status = 0 or 1
      int completionStatus = db.getCompletionStatus(yyyymmdd);

      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): completionStatus
      };

      // add to the heat map dataset
      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
