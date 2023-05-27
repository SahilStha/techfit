import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:work_out/Database/dbhelper/insert.dart';
import 'constant.dart';

class MongoDatabase {
  static var db, userCollection;
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection(USER_COLLECTION);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final arrData = await userCollection.find().toList();
    return arrData;
  }

  static Future<String> insert(InsertWorkout data) async {
    try {
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess) {
        return "Workout is created";
      } else {
        return "Workout cannot be created";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
