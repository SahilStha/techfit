import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_out/view/screens/dietscreen/bloc/diet_bloc.dart';

class Foodlist extends StatefulWidget {
  final String foodName;
  bool foodcompleted;
  final String dietId;

  Foodlist({
    super.key,
    required this.foodName,
    required this.foodcompleted,
    required this.dietId,
  });

  @override
  State<Foodlist> createState() => _FoodlistState();
}

class _FoodlistState extends State<Foodlist> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 125, 194, 102),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          // mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Row(
                children: [
                  Checkbox(
                    value: widget.foodcompleted,
                    onChanged: (value) {
                      widget.foodcompleted = value ?? false;
                      setState(() {});
                      BlocProvider.of<DietBloc>(context).add(CheckUncheckDiet(
                          dietName: widget.foodName,
                          isChecked: value ?? false,
                          dietId: widget.dietId));
                    },
                    checkColor: Colors.black,
                    activeColor: Color.fromARGB(255, 125, 194, 102),
                  ),

                  // food name
                  Text(
                    widget.foodName,
                    style: TextStyle(
                      decoration: widget.foodcompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            // checkbox

            Row(
              children: [
                IconButton(
                    onPressed: () {
                      BlocProvider.of<DietBloc>(context)
                          .add(DeleteDiet(dietId: widget.dietId));
                    },
                    icon: const Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.red,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
