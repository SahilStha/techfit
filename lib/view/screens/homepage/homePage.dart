// ignore_for_file: unused_import, prefer_const_constructors

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:work_out/config/Colors.dart';
import 'package:work_out/config/text.dart';
import 'package:work_out/config/workouts%20lists/workouts%20Lists.dart';
import 'package:work_out/view/screens/customworkout/customworkoutUI.dart';
import 'package:work_out/view/screens/dietscreen/dietscreen.dart';
import 'package:work_out/view/screens/user%20profile/userProfil.dart';

import '../../../controller/functionsController.dart';
import '../../../controller/tabs controllers/workOutTabController.dart';
import '../../../controller/userController/userController.dart';
import '../../../config/images sources.dart';
import '../../../helpers/string_methods.dart';
import '../../widgets/general_widgets/screen_background_image.dart';
import 'componenets/HomePageSearchBar.dart';
import 'componenets/ItemsSwitchTiles.dart';
import 'componenets/find_your_workout.dart';
import 'componenets/playButton.dart';
import 'componenets/tabBarViewSections.dart';
import 'componenets/usernameAndProfile.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  final String bgImg = ImgSrc().randomFromAssetsList();
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FunctionsController controller = Get.put(FunctionsController());

  final UserInformationController userInformationController =
      Get.put(UserInformationController());

  final CustomTabBarController _tabx = Get.put(CustomTabBarController());
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  int _selectedIndex = 0;
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    dietscreen(),
    customworkoutUI(),
    UserProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: Container(
        //   child: Padding(
        //     padding: const EdgeInsets.all(0),
        //     child: GNav(
        //       onTabChange: _navigateBottomBar,
        //       gap: 8,
        //       backgroundColor: Color.fromARGB(255, 72, 63, 111),
        //       color: Color.fromARGB(255, 92, 187, 91),
        //       activeColor: Color.fromARGB(255, 125, 194, 102),
        //       tabBackgroundColor: Colors.grey.shade700,
        //       padding: EdgeInsets.all(15),
        //       tabs: const [
        //         GButton(
        //           icon: Icons.home,
        //           text: 'Home',
        //         ),
        //         GButton(
        //           icon: Icons.fitness_center,
        //           text: 'Workout',
        //         ),
        //         GButton(
        //           icon: Icons.lunch_dining,
        //           text: 'Nutritions',
        //         ),
        //         GButton(
        //           icon: Icons.account_box,
        //           text: 'Profile',
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        body: Stack(
      children: [
        BackgroundImage(
          backgroundImage: widget.bgImg,
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
                    Container(
                      child: ElevatedButton(
                        child: Text('Create Workout'),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => customworkoutUI())),
                      ),
                    ),
                    Container(
                      child: ElevatedButton(
                        child: Text(' Diet plans'),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => dietscreen())),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
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
    ));
  }
}
