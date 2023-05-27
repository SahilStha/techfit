import 'package:flutter/material.dart';

class Foodlist extends StatelessWidget {
  final String foodName;
  final bool foodcompleted;
  Function(bool?)? onChanged;

  Foodlist({
    super.key,
    required this.foodName,
    required this.foodcompleted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 129, 200, 188),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // checkbox
            Checkbox(
              value: foodcompleted,
              onChanged: onChanged,
              activeColor: Color.fromARGB(255, 75, 112, 232),
            ),

            // food name
            Text(
              foodName,
              style: TextStyle(
                decoration: foodcompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
