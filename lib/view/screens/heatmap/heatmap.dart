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
        defaultColor: Colors.black,
        textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
          1: Color.fromARGB(255, 141, 179, 243),
          2: Color.fromARGB(255, 110, 157, 239),
          3: Color.fromARGB(255, 57, 124, 240),
          4: Color.fromARGB(255, 13, 97, 242),
          5: Color.fromARGB(255, 54, 103, 188),
          6: Color.fromARGB(255, 26, 73, 153),
          7: Color.fromARGB(255, 17, 69, 161),
          8: Color.fromARGB(255, 2, 61, 163),
          9: Color.fromARGB(255, 2, 39, 103),
          10: Color.fromARGB(255, 1, 134, 15),
        },
      ),
    );
  }
}
