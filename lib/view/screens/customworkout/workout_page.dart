// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_out/view/screens/customworkout/components/exercise_tile.dart';

import 'workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  // Checkbox was tapped
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkoffExercise(workoutName, exerciseName);
  }

  // text controllers
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  // create a new exercise
  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 141, 234, 146),
        title: Text('Add new exercise'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // exercise name
              TextField(
                decoration: InputDecoration(
                    labelText: 'Exercise',
                    labelStyle: TextStyle(color: Colors.blueAccent)),
                controller: exerciseNameController,
              ),

              // weight
              TextField(
                decoration: InputDecoration(
                    labelText: 'weight',
                    labelStyle: TextStyle(color: Colors.blueAccent)),
                controller: weightController,
              ),

              // reps
              TextField(
                decoration: InputDecoration(
                    labelText: 'reps',
                    labelStyle: TextStyle(color: Colors.blueAccent)),
                controller: repsController,
              ),

              // sets
              TextField(
                decoration: InputDecoration(
                    labelText: 'sets',
                    labelStyle: TextStyle(color: Colors.blueAccent)),
                controller: setsController,
              ),
            ],
          ),
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: save,
            child: Text("save"),
          ),

          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text("cancel"),
          )
        ],
      ),
    );
  }

  // save workout
  void save() {
    // get exercise name from text controller
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;
    // add exercise to workoutdata list
    Provider.of<WorkoutData>(context, listen: false)
        .addExercise(widget.workoutName, newExerciseName, weight, reps, sets);

    // pop dialog
    Navigator.pop(context);
    clear();
  }

  // cancel workout
  void cancel() {
    // pop dialog
    Navigator.pop(context);
    clear();
  }

  // clear controller
  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    setsController.clear();
    repsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: Text(widget.workoutName)),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: value.numberOfExerciseInWOrkout(widget.workoutName),
            itemBuilder: (context, index) => ExerciseTile(
                  exerciseName: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .name,
                  weight: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .weight,
                  reps: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .reps,
                  sets: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .sets,
                  isCompleted: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .isCompleted,
                  onCheckBoxChanged: (val) => onCheckBoxChanged(
                    widget.workoutName,
                    value
                        .getRelevantWorkout(widget.workoutName)
                        .exercises[index]
                        .name,
                  ),
                )),
      ),
    );
  }
}
