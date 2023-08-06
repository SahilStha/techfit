import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:work_out/controller/functionsController.dart';
import 'package:work_out/config/images%20sources.dart';
import 'package:work_out/view/screens/customworkout/bloc/custom_workout_bloc.dart';

import '../../../../config/text.dart';
import '../../../../helpers/string_methods.dart';
import '../../workoutsPages/AllWorkoutsPage.dart';
import 'WorkOutCard.dart';

class TabBarViewSection extends StatelessWidget {
  TabBarViewSection({
    Key? key,
    required this.title,
    required this.dataList,
    this.itemsToShow = 3,
    this.hasSeeAllButton = true,
  }) : super(key: key);
  String title;
  List dataList;
  bool hasSeeAllButton;
  int itemsToShow;
  final FunctionsController controller = Get.put(FunctionsController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(AllWorkoutsPage(), arguments: [title, dataList]);
              },
              child: Visibility(
                visible: hasSeeAllButton,
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(.1),
                  ),
                  child: Text(
                    capitalize(AppTexts.seeAll),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        BlocBuilder<CustomWorkoutBloc, CustomWorkoutState>(
          builder: (context, state) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Wrap(
                children: [
                  ...List.generate(
                    itemsToShow < dataList.length ? 3 : dataList.length,
                    (index) => WorkOutCard(
                        url: dataList[index]["url"] ??
                            "https://media.istockphoto.com/id/1353020339/video/muscular-athletic-young-man-training-for-body-building-at-home.mp4?s=mp4-640x640-is&k=20&c=bTRENfUm8eU7ycsizFByVr1GO6Cl17k3PG2cq83iNIQ=",
                        index: index,
                        listCollection: dataList,
                        title: capitalize(
                          dataList[index]["workOutTitle"] ??
                              AppTexts.somethingWrong,
                        ),
                        imagePath: dataList[index]["imagePath"] ??
                            ImgSrc.noImgAvailable),
                  )
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
