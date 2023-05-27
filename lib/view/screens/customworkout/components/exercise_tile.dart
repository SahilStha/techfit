import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;

  ExerciseTile({
    super.key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckBoxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 138, 227, 150),
      child: ListTile(
        title: Text(
          exerciseName,
        ),
        subtitle: Row(
          children: [
            //weight
            Chip(
              backgroundColor: Colors.blueAccent,
              label: Text(
                "${weight}Kg",
              ),
            ),

            // reps
            Chip(
              backgroundColor: Colors.blueAccent,
              label: Text(
                "$reps reps",
              ),
            ),
            // sets
            Chip(
              backgroundColor: Colors.blueAccent,
              label: Text(
                "$sets sets",
              ),
            ),
          ],
        ),
        trailing: Checkbox(
          checkColor: Colors.black,
          value: isCompleted,
          onChanged: (value) => onCheckBoxChanged!(value),
        ),
      ),
    );
  }
}
