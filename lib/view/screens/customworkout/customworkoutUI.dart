// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_out/Database/mongodb/dbhelper/insert.dart';
import 'package:work_out/Database/mongodb/mongodb.dart';
import 'package:work_out/config/Colors.dart';
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
  @override
  void initState() {
    super.initState();

    Provider.of<WorkoutData>(context, listen: false).initalizeWorkoutList();
  }

  // text controller
  final newWorkoutNameController = TextEditingController();
//  create a new workout
  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("create new workout"),
        content: TextField(
          controller: newWorkoutNameController,
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () {
              _save(newWorkoutNameController.text);
            },
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

  Future<void> _save(String newWorkoutName) async {
    var id = M.ObjectId();
    final data = InsertWorkout(id: id, newWorkoutName: newWorkoutName);
    var result = await MongoDatabase.insert(data);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Inserted ID${id.$oid}")));
    Navigator.pop(context);
    clear();
  }

  // goto workout page
  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutPage(
            workoutName: workoutName,
          ),
        ));
  }

  // save workout
  void save() {
    // get workout name from text controller
    String newWorkoutName = newWorkoutNameController.text;
    // add workout to workoutdata list
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

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
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Custom Workout'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            // Heat Map
            MyHeatMap(
                dataset: value.heatMapDataSet,
                startDateYYYYMMDD: value.getStartDate()),

            // Workout List
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getWorkoutList().length,
                itemBuilder: (context, index) => ListTile(
                      title: Text(value.getWorkoutList()[index].name),
                      trailing: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () =>
                            goToWorkoutPage(value.getWorkoutList()[index].name),
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}
