// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_out/config/Colors.dart';
import 'package:work_out/view/screens/customworkout/bloc/excersice_bloc.dart';

class ExerciseTile extends StatefulWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final String excerciseId;
  bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;

  ExerciseTile({
    Key? key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.excerciseId,
    required this.isCompleted,
    required this.onCheckBoxChanged,
  }) : super(key: key);

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 138, 227, 150),
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          widget.exerciseName,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        subtitle: Row(
          children: [
            //weight
            Chip(
              backgroundColor: Colors.white,
              label: Text(
                "${widget.weight}Kg",
              ),
            ),
            SizedBox(
              width: 12,
            ),

            // reps
            Chip(
              backgroundColor: Colors.white,
              label: Text(
                "${widget.reps} reps",
              ),
            ),
            SizedBox(
              width: 12,
            ),
            // sets
            Chip(
              backgroundColor: Colors.white,
              label: Text(
                "${widget.sets} sets",
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              checkColor: Colors.black,
              value: widget.isCompleted,
              onChanged: (value) {
                widget.isCompleted = value ?? false;
                setState(() {});
                BlocProvider.of<ExcersiceBloc>(context).add(
                    CompleteUncompleteExcersise(
                        excersieId: widget.excerciseId));
              },
            ),
            InkWell(
              onTap: () {
                BlocProvider.of<ExcersiceBloc>(context)
                    .add(DeleteExcersie(excersiseId: widget.excerciseId));
              },
              child: Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
