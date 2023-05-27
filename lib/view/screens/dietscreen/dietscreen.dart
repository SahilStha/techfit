// ignore_for_file: unused_import, unused_field, camel_case_types

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:work_out/view/screens/dietscreen/utilities/dialog_box.dart';
import 'package:work_out/view/screens/dietscreen/utilities/foodlist_tile.dart';

class dietscreen extends StatefulWidget {
  const dietscreen({super.key});

  @override
  State<dietscreen> createState() => _dietscreenState();
}

class _dietscreenState extends State<dietscreen> {
  // text controller
  final _controller = TextEditingController();

  //list of foodlist
  List foodlist = [
    ["Egg", false],
    ["Milk", false],
  ];

  // checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      foodlist[index][1] = !foodlist[index][1];
    });
  }

  // save new food
  void saveNewfood() {
    setState(() {
      foodlist.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  // add a new food
  void addfood() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewfood,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 129, 200, 188),
        title: const Text('Diets'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addfood,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: foodlist.length,
        itemBuilder: (context, index) {
          return Foodlist(
            foodName: foodlist[index][0],
            foodcompleted: foodlist[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
          );
        },
      ),
    );
  }
}
