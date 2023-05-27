// ignore_for_file: unused_import, unused_field, camel_case_types

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hive/hive.dart';
import 'package:work_out/view/screens/dietscreen/dietscreen.dart';
import 'package:work_out/view/screens/dietscreen/utilities/dialog_box.dart';
import 'package:work_out/view/screens/dietscreen/utilities/foodlist_tile.dart';
import 'package:work_out/view/screens/homepage/componenets/usernameAndProfile.dart';

import '../../../config/Colors.dart';
import '../../../config/images sources.dart';
import '../../../config/workouts lists/workouts Lists.dart';
import '../../../controller/functionsController.dart';
import '../../../controller/tabs controllers/workOutTabController.dart';
import '../../../controller/userController/userController.dart';
import '../../../helpers/string_methods.dart';
import '../../widgets/general_widgets/screen_background_image.dart';
import '../customworkout/customworkoutUI.dart';
import '../user profile/userProfil.dart';
import 'componenets/find_your_workout.dart';
import 'componenets/tabBarViewSections.dart';

class Dashscreen extends StatefulWidget {
  const Dashscreen({super.key});

  @override
  State<Dashscreen> createState() => _DashscreenState();
}

class _DashscreenState extends State<Dashscreen> {
  final FunctionsController controller = Get.put(FunctionsController());

  final UserInformationController userInformationController =
      Get.put(UserInformationController());

  final CustomTabBarController _tabx = Get.put(CustomTabBarController());
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(
          backgroundImage: ImgSrc().randomFromAssetsList(),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: const [0.45, 1],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AppColors.darkBlue,
                AppColors.darkBlue.withOpacity(0.05),
              ],
            ),
          ),
          width: double.infinity,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Obx(
                      () => ProfileAndUsername(
                        onProfileImgTap: () {
                          Get.to(() => const UserProfile());
                        },
                        username: capitalize(
                          userInformationController.username.value,
                        ),
                        profileImg:
                            userInformationController.userProfileImg.value,
                      ),
                    ),
                    const SizedBox(
                      height: 55,
                    ),
                    // DelayedDisplay(
                    //   delay: Duration(milliseconds: delay + 100),
                    //   child: PlayButton(),
                    // ),
                    const SizedBox(
                      height: 55,
                    ),
                    DelayedDisplay(
                      delay: Duration(milliseconds: delay + 200),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const FindYourWorkout(),
                          GestureDetector(
                            onTap: (() {
                              controller.showFilterDialog(context);
                            }),
                            child: const Icon(
                              Icons.filter_alt_outlined,
                              color: Color.fromARGB(255, 100, 233, 79),
                              size: 26,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Container(
                    //   child: ElevatedButton(
                    //     child: Text('Create Workout'),
                    //     onPressed: () => Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => customworkoutUI())),
                    //   ),
                    // ),
                    // Container(
                    //   child: ElevatedButton(
                    //     child: Text(' Diet plans'),
                    //     onPressed: () => Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => dietscreen())),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 22,
                      child: DelayedDisplay(
                        delay: Duration(
                          milliseconds: delay + 400,
                        ),
                        child: TabBar(
                          labelColor: Color.fromARGB(255, 251, 250, 250),
                          isScrollable: true,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                          controller: _tabx.workOutTabController,
                          tabs: _tabx.workOutTabs,
                        ),
                      ),
                    ),
                    Expanded(
                      child: DelayedDisplay(
                        delay: Duration(milliseconds: delay + 600),
                        child: TabBarView(
                          controller: _tabx.workOutTabController,
                          children: [
                            Center(
                              child: TabBarViewSection(
                                title: capitalize(
                                  'All workouts',
                                ),
                                dataList: WorkoutsList.allWorkoutsList,
                              ),
                            ),
                            Center(
                              child: TabBarViewSection(
                                title: capitalize(
                                  'Popular',
                                ),
                                dataList: WorkoutsList.popularWorkoutsList,
                              ),
                            ),
                            Center(
                              child: TabBarViewSection(
                                  title: capitalize(
                                    'hard',
                                  ),
                                  dataList: WorkoutsList.hardWorkoutsList),
                            ),
                            Center(
                              child: TabBarViewSection(
                                  title: capitalize(
                                    'Full body',
                                  ),
                                  dataList: WorkoutsList.fullBodyWorkoutsList),
                            ),
                            Center(
                              child: TabBarViewSection(
                                  title: capitalize(
                                    'Crossfit',
                                  ),
                                  dataList: WorkoutsList.crossFit),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container()
      ],
    );
  }
}
