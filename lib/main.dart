import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:work_out/Database/mongodb.dart';
import 'package:work_out/bindings/initial_binding.dart';
import 'package:work_out/config/Themes/mainThemeFile.dart';
import 'package:work_out/config/initial_main_methods/initial_main_methods.dart';
import 'package:work_out/core/injection/dependency_injection.dart';
import 'package:work_out/view/screens/customworkout/bloc/custom_workout_bloc.dart';
import 'package:work_out/view/screens/customworkout/bloc/excersice_bloc.dart';
import 'package:work_out/view/screens/customworkout/workout_data.dart';
import 'package:work_out/view/screens/dietscreen/bloc/diet_bloc.dart';
import 'config/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MainMethods.init();
  await MongoDatabase.connect();

  // initalize hive
  await Hive.initFlutter();

  // opening a hive box
  await Hive.openBox("workout_database1");
  await configureDependencies();

  runApp(
    const WorkoutApp(),
  );
}

class WorkoutApp extends StatelessWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => WorkoutData(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<CustomWorkoutBloc>(
                create: (context) => sl<CustomWorkoutBloc>()),
            BlocProvider<DietBloc>(create: (context) => sl<DietBloc>()),
            BlocProvider<ExcersiceBloc>(
                create: (context) => sl<ExcersiceBloc>()),
          ],
          child: GetMaterialApp(
            initialBinding: InitialBinding(),
            // defaultTransition: Transition.fade,
            theme: MainTheme(context).themeData,
            debugShowCheckedModeBanner: false,
            getPages: Routes.pages,
            initialRoute: "/",
          ),
        ));
  }
}
