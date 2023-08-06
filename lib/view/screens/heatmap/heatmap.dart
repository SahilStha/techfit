import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:work_out/datetime/date_time.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int>? dataset;
  final String startDateYYYYMMDD;

  const MyHeatMap({
    super.key,
    required this.dataset,
    required this.startDateYYYYMMDD,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: HeatMap(
        startDate: createDateTimeObject(startDateYYYYMMDD),
        endDate: DateTime.now().add(const Duration(days: 0)),
        datasets: dataset,
        colorMode: ColorMode.color,
        defaultColor: Colors.deepOrangeAccent.shade100,
        textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
          1: Color.fromARGB(255, 198, 226, 255), // Light Blue
          2: Color.fromARGB(255, 164, 221, 229), // Powder Blue
          3: Color.fromARGB(255, 110, 186, 216), // Sky Blue
          4: Color.fromARGB(255, 70, 130, 180), // Steel Blue
          5: Color.fromARGB(255, 30, 144, 255), // Dodger Blue
          6: Color.fromARGB(255, 2, 118, 180), // Deep Sky Blue
          7: Color.fromARGB(255, 2, 86, 170), // Blue
          8: Color.fromARGB(255, 0, 0, 255), // Medium Blue
          9: Color.fromARGB(255, 0, 0, 139), // Dark Blue
          10: Color.fromARGB(255, 3, 169, 19),
        },
      ),
    );
  }
}
