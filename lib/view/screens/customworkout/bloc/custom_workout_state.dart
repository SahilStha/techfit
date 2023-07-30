// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'custom_workout_bloc.dart';

class CustomWorkoutState extends Equatable {
  const CustomWorkoutState(
      {this.theStates = TheStates.initial,
      this.errorMessage,
      this.response,
      this.videos,
      this.heatlevels});

  @override
  List<Object?> get props => [theStates, errorMessage, response, heatlevels];
  final TheStates theStates;
  final String? errorMessage;
  final List<CustomWorkoutResponse>? response;
  final List<VideoResponse>? videos;
  final HeatLevelResponse? heatlevels;

  CustomWorkoutState copyWith(
      {TheStates? theStates,
      String? errorMessage,
      List<CustomWorkoutResponse>? response,
      List<VideoResponse>? videos,
      HeatLevelResponse? heatlevels}) {
    return CustomWorkoutState(
        theStates: theStates ?? this.theStates,
        errorMessage: errorMessage ?? this.errorMessage,
        response: response ?? this.response,
        videos: videos ?? this.videos,
        heatlevels: heatlevels ?? this.heatlevels);
  }
}

enum TheStates { initial, loading, success, failed }

class CustomWorkoutResponse {
  String? id;
  String? name;
  String? userKey;

  CustomWorkoutResponse({this.id, this.name, this.userKey});

  CustomWorkoutResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userKey = json['userKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['userKey'] = userKey;
    return data;
  }
}

class HeatLevelResponse {
  int? todayHeatLevel;
  List<PastHeatLevel>? pastHeatLevel;

  HeatLevelResponse({this.todayHeatLevel, this.pastHeatLevel});

  HeatLevelResponse.fromJson(Map<String, dynamic> json) {
    todayHeatLevel = json['todayHeatLevel'];
    if (json['pastHeatLevel'] != null) {
      pastHeatLevel = <PastHeatLevel>[];
      json['pastHeatLevel'].forEach((v) {
        pastHeatLevel!.add(new PastHeatLevel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['todayHeatLevel'] = this.todayHeatLevel;
    if (this.pastHeatLevel != null) {
      data['pastHeatLevel'] =
          this.pastHeatLevel!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PastHeatLevel {
  String? id;
  String? date;
  int? level;
  String? userKey;

  PastHeatLevel({this.id, this.date, this.level, this.userKey});

  PastHeatLevel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    level = json['level'];
    userKey = json['userKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['level'] = this.level;
    data['userKey'] = this.userKey;
    return data;
  }
}

class VideoResponse {
  String? id;
  String? title;
  String? description;
  String? url;
  String? userKey;

  VideoResponse(
      {this.id, this.title, this.description, this.url, this.userKey});

  VideoResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    userKey = json['userKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['userKey'] = this.userKey;
    return data;
  }
}
