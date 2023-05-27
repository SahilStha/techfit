// To parse this JSON data, do
//
//     final insertWorkout = insertWorkoutFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

InsertWorkout insertWorkoutFromJson(String str) =>
    InsertWorkout.fromJson(json.decode(str));

String insertWorkoutToJson(InsertWorkout data) => json.encode(data.toJson());

class InsertWorkout {
  InsertWorkout({
    required this.id,
    required this.newWorkoutName,
  });

  ObjectId id;
  String newWorkoutName;

  factory InsertWorkout.fromJson(Map<String, dynamic> json) => InsertWorkout(
        id: json["id"],
        newWorkoutName: json["newWorkoutName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "newWorkoutName": newWorkoutName,
      };
}
