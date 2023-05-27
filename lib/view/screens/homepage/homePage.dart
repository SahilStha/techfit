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
import 'package:work_out/view/screens/homepage/dash_screen.dart';
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
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
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
    pageController.jumpToPage(index);
  }

  final List<Widget> _pages = [
    Dashscreen(),
    customworkoutUI(),
    dietscreen(),
    UserProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: GNav(
              onTabChange: _navigateBottomBar,
              gap: 8,
              backgroundColor: Color.fromARGB(255, 72, 63, 111),
              color: Color.fromARGB(255, 92, 187, 91),
              activeColor: Color.fromARGB(255, 125, 194, 102),
              tabBackgroundColor: Colors.grey.shade700,
              padding: EdgeInsets.all(15),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.fitness_center,
                  text: 'Workout',
                ),
                GButton(
                  icon: Icons.lunch_dining,
                  text: 'Nutritions',
                ),
                GButton(
                  icon: Icons.account_box,
                  text: 'Profile',
                )
              ],
            ),
          ),
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: _pages,
        ));
  }
}
