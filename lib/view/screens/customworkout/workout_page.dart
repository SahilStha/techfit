// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:work_out/config/Colors.dart';

import 'package:work_out/view/screens/customworkout/bloc/custom_workout_bloc.dart';
import 'package:work_out/view/screens/customworkout/bloc/excersice_bloc.dart';
import 'package:work_out/view/screens/customworkout/components/exercise_tile.dart';
import 'package:work_out/view/screens/customworkout/customworkoutUI.dart';

import 'workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutId;
  final String workoutName;
  const WorkoutPage({
    Key? key,
    required this.workoutId,
    required this.workoutName,
  }) : super(key: key);

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
        backgroundColor: AppColors.green,
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
    BlocProvider.of<ExcersiceBloc>(context).add(CreateExcersise(
        name: newExerciseName,
        workoutId: widget.workoutId,
        weight: num.tryParse(weight) ?? 0,
        reps: num.tryParse(reps) ?? 0,
        sets: num.tryParse(sets) ?? 0));

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
  void initState() {
    super.initState();
    BlocProvider.of<ExcersiceBloc>(context)
        .add(GetExcersiseFromWorkout(workoutId: widget.workoutId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExcersiceBloc, ExcersiseState>(
      listener: (context, state) async {
        if (state.shouldReload) {
          BlocProvider.of<ExcersiceBloc>(context)
              .add(GetExcersiseFromWorkout(workoutId: widget.workoutId));
        }
      },
      builder: (context, state) {
        return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(title: Text(widget.workoutName)),
            floatingActionButton: FloatingActionButton(
              onPressed: createNewExercise,
              child: Icon(Icons.add),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<ExcersiceBloc>(context)
                    .add(GetExcersiseFromWorkout(workoutId: widget.workoutId));
              },
              child: state.theStates == TheStates.success
                  ? ListView.builder(
                      padding: EdgeInsets.only(top: 20),
                      itemCount: state.response?.length ?? 0,
                      itemBuilder: (context, index) => ExerciseTile(
                            excerciseId: state.response?[index].id ?? '',
                            exerciseName: state.response?[index].name ?? '',
                            weight:
                                state.response?[index].weight.toString() ?? '',
                            reps: state.response?[index].reps.toString() ?? '',
                            sets: state.response?[index].sets.toString() ?? '',
                            isCompleted:
                                state.response?[index].isCompleted ?? false,
                            onCheckBoxChanged: (p0) {},
                          ))
                  : state.theStates == TheStates.failed
                      ? Center(
                          child: ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<ExcersiceBloc>(context).add(
                                    GetExcersiseFromWorkout(
                                        workoutId: widget.workoutId));
                              },
                              child: Text('Refresh')),
                        )
                      : state.theStates == TheStates.loading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : SizedBox.shrink(),
            ));
      },
    );
  }
}
