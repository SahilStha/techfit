// ignore_for_file: unused_import, unused_field, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:work_out/view/screens/customworkout/bloc/custom_workout_bloc.dart';
import 'package:work_out/view/screens/dietscreen/bloc/diet_bloc.dart';
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

  // checkbox was tapped

  // save new food

  // add a new food
  void addfood() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: () {
            BlocProvider.of<DietBloc>(context)
                .add(CreateDiet(dietName: _controller.text));
            _controller.clear();
            Navigator.pop(context);
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<DietBloc>(context).add(GetDiets());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DietBloc, DietState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.8),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 125, 194, 102),
            title: const Text('Diets'),
            elevation: 0,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: addfood,
            child: const Icon(Icons.add),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<DietBloc>(context).add(GetDiets());
            },
            child: state.theStates == TheStates.success
                ? ListView.builder(
                    itemCount: state.response?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Foodlist(
                        dietId: state.response?[index].id ?? '',
                        foodName: state.response?[index].name ?? '',
                        foodcompleted:
                            state.response?[index].isChecked ?? false,
                      );
                    },
                  )
                : state.theStates == TheStates.failed
                    ? ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<DietBloc>(context).add(GetDiets());
                        },
                        child: const Text('Refresh'))
                    : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
