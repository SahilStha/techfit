// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:work_out/Database/mongodb/dbhelper/insert.dart';
import 'package:work_out/Database/mongodb/mongodb.dart';
import 'package:work_out/config/Colors.dart';
import 'package:work_out/core/injection/dependency_injection.dart';
import 'package:work_out/preferences.dart';
import 'package:work_out/providers/api_client.dart';
import 'package:work_out/utils/utils.dart';
import 'package:work_out/view/screens/customworkout/bloc/custom_workout_bloc.dart';
import 'package:work_out/view/screens/customworkout/workout_data.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:work_out/view/screens/heatmap/heatmap.dart';

import 'workout_page.dart';

class customworkoutUI extends StatefulWidget {
  const customworkoutUI({super.key});

  @override
  State<customworkoutUI> createState() => customworkout_UI();
}

class customworkout_UI extends State<customworkoutUI> {
  Map<DateTime, int> getHeatLevelMap(HeatLevelResponse data) {
    Map<DateTime, int> heatLevelMap = {};
    for (var item in data.pastHeatLevel ?? []) {
      DateTime date = DateTime.parse(item.date ?? '');
      int level = item.level ?? 0;
      // Create a new DateTime object with only the year, month, and day parts
      DateTime dateOnly = DateTime(date.year, date.month, date.day);
      heatLevelMap[dateOnly] = level;
    }

    // Add today's heat level to the map
    DateTime todayDate = DateTime.now();
    // Create a new DateTime object with only the year, month, and day parts
    DateTime todayDateOnly =
        DateTime(todayDate.year, todayDate.month, todayDate.day);
    heatLevelMap[todayDateOnly] = data.todayHeatLevel ?? 0;

    return heatLevelMap;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<WorkoutData>(context, listen: false).initalizeWorkoutList();
      BlocProvider.of<CustomWorkoutBloc>(context)
          .add(GetCustomWorkouts(email: await getEmail(), isFirstLoad: true));
    });

    // Provider.of<WorkoutData>(context, listen: false).initalizeWorkoutList();
  }

  // text controller
  final newWorkoutNameController = TextEditingController();
//  create a new workout
  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 125, 194, 102),
        title: Text("create new workout"),
        content: TextFormField(
          decoration: InputDecoration(
              label: Text(
            'Excercise name',
            style: TextStyle(color: Colors.black),
          )),
          controller: newWorkoutNameController,
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          // save button

          MaterialButton(
            color: Colors.blueGrey,
            onPressed: () async {
              BlocProvider.of<CustomWorkoutBloc>(context).add(
                  CreateCustomWorkout(
                      userKey: await getEmail(),
                      workoutName: newWorkoutNameController.text));
              clear();
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(fontSize: 16),
            ),
          ),

          // cancel button
          MaterialButton(
            color: Colors.blueGrey,
            onPressed: cancel,
            child: Text(
              "Cancel",
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  // Future<void> _save(String newWorkoutName) async {
  //   var id = M.ObjectId();
  //   final data = InsertWorkout(id: id, newWorkoutName: newWorkoutName);
  //   var result = await MongoDatabase.insert(data);
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(SnackBar(content: Text("Inserted ID${id.$oid}")));
  //   Navigator.pop(context);
  //   clear();
  // }

  // goto workout page
  void goToWorkoutPage(String workoutId, String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              WorkoutPage(workoutId: workoutId, workoutName: workoutName),
        ));
  }

  // save workout
  // void save() {
  //   // get workout name from text controller
  //   String newWorkoutName = newWorkoutNameController.text;
  //   // add workout to workoutdata list
  //   Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

  //   // pop dialog
  //   Navigator.pop(context);
  //   clear();
  // }

  // cancel workout
  void cancel() {
    // pop dialog
    Navigator.pop(context);
    clear();
  }

  // clear controller
  void clear() {
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomWorkoutBloc, CustomWorkoutState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.8),
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 125, 194, 102),
              title: const Text('Custom Workout'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: createNewWorkout,
              child: const Icon(Icons.add),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<CustomWorkoutBloc>(context)
                    .add(GetCustomWorkouts(email: await getEmail()));
              },
              child: state.theStates == TheStates.success
                  ? ListView(
                      children: [
                        MyHeatMap(
                            dataset: getHeatLevelMap(
                                state.heatlevels ?? HeatLevelResponse()),
                            startDateYYYYMMDD: '20230713'),

                        // Workout List
                        ListView.separated(
                            padding: EdgeInsets.only(top: 20),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.response?.length ?? 0,
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 26,
                                ),
                            itemBuilder: (context, index) => ListTile(
                                  tileColor: Color.fromARGB(255, 125, 194, 102),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 12),
                                  onTap: () {
                                    goToWorkoutPage(
                                        state.response?[index].id ?? '',
                                        state.response?[index].name ?? '');
                                  },
                                  // goToWorkoutPage(value.getWorkoutList()[index].name)
                                  title: Text(
                                    state.response?[index].name ?? '',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),

                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          goToWorkoutPage(
                                              state.response?[index].id ?? '',
                                              state.response?[index].name ??
                                                  '');
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_forever,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          BlocProvider.of<CustomWorkoutBloc>(
                                                  context)
                                              .add(DeleteWorkout(
                                                  workoutId: state
                                                          .response?[index]
                                                          .id ??
                                                      ''));
                                        },
                                      ),
                                    ],
                                  ),
                                )),
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ));
      },
    );
  }
}

Future<String> getEmail() async {
  Preferences preferences = Preferences();
  String? email = await preferences.getString(Preference.userID);
  if (email == null) {
    displayToastMessage('No email', backgroundColor: Colors.red);
    return '';
  }
  return email;
}
