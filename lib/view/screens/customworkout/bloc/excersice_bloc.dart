// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:work_out/common/api_response.dart';

import 'package:work_out/providers/api_client.dart';
import 'package:work_out/utils/endpoints.dart';
import 'package:work_out/utils/utils.dart';
import 'package:work_out/view/screens/customworkout/bloc/custom_workout_bloc.dart';
import 'package:work_out/view/screens/customworkout/customworkoutUI.dart';

part 'excersice_event.dart';
part 'excersice_state.dart';

@injectable
class ExcersiceBloc extends Bloc<ExcersiseEvent, ExcersiseState> {
  final ApiClient _apiClient;
  ExcersiceBloc(
    this._apiClient,
  ) : super(const ExcersiseState()) {
    on<CreateExcersise>(_createExcersise);
    on<CompleteUncompleteExcersise>(_completeExcersise);
    on<DeleteExcersie>(_deleteExcersie);
    on<GetExcersiseFromWorkout>(_getExcersise);
  }

  FutureOr<void> _getExcersise(
      GetExcersiseFromWorkout event, Emitter<ExcersiseState> emit) async {
    try {
      emit(state.copyWith(theStates: TheStates.loading));
      Map<String, dynamic> query = {"workoutId": event.workoutId};
      var apiResponse =
          await _apiClient.httpGet(Endpoints.exercises, param: query);
      var response = ApiResponseForList(
        status: Status.success,
        message: 'Successfully got workouts',
        data: (apiResponse as List<dynamic>)
            .map((data) => ExcersiseResponse.fromJson(data))
            .toList(),
      );
      emit(state.copyWith(
          theStates: TheStates.success, response: response.data));
    } catch (e) {
      try {
        e as ApiErrorResponse;
        displayToastMessage(e.details?[0].msg ?? 'Error getting data');
      } catch (e) {
        displayToastMessage('Error', backgroundColor: Colors.red);
      }
    }
  }

  FutureOr<void> _deleteExcersie(
      DeleteExcersie event, Emitter<ExcersiseState> emit) async {
    try {
      await _apiClient.httpDelete(Endpoints.excersiseWithId(event.excersiseId));
      emit(state.copyWith(theStates: TheStates.success, shouldReload: true));
    } catch (e) {
      try {
        e as ApiErrorResponse;
        displayToastMessage(e.details?[0].msg ?? 'Error getting data');
      } catch (e) {
        displayToastMessage('Error', backgroundColor: Colors.red);
      }
    }
  }

  FutureOr<void> _completeExcersise(
      CompleteUncompleteExcersise event, Emitter<ExcersiseState> emit) async {
    try {
      await _apiClient
          .httpPatch(Endpoints.excersiseWithId(event.excersieId), {});
      emit(state.copyWith(theStates: TheStates.success, shouldReload: true));
    } catch (e) {
      try {
        e as ApiErrorResponse;
        displayToastMessage(e.details?[0].msg ?? 'Error getting data');
      } catch (e) {
        displayToastMessage('Error', backgroundColor: Colors.red);
      }
    }
  }

  FutureOr<void> _createExcersise(
      CreateExcersise event, Emitter<ExcersiseState> emit) async {
    try {
      Map<String, dynamic> data = {
        "name": event.name,
        "weight": event.weight,
        "reps": event.reps,
        "sets": event.sets,
        "workout": {"id": event.workoutId}
      };
      await _apiClient.httpPost(Endpoints.exercises, data);
      emit(state.copyWith(shouldReload: true, theStates: TheStates.success));
    } catch (e) {
      try {
        e as ApiErrorResponse;
        displayToastMessage(e.details?[0].msg ?? 'Error getting data');
      } catch (e) {
        displayToastMessage('Error', backgroundColor: Colors.red);
      }
    }
  }
}

class ExcersiseResponse {
  String? id;
  String? name;
  int? weight;
  int? reps;
  int? sets;
  bool? isCompleted;
  String? date;
  Workout? workout;

  ExcersiseResponse(
      {this.id,
      this.name,
      this.weight,
      this.reps,
      this.sets,
      this.isCompleted,
      this.date,
      this.workout});

  ExcersiseResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    weight = json['weight'];
    reps = json['reps'];
    sets = json['sets'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    workout =
        json['workout'] != null ? new Workout.fromJson(json['workout']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['weight'] = this.weight;
    data['reps'] = this.reps;
    data['sets'] = this.sets;
    data['isCompleted'] = this.isCompleted;
    data['date'] = this.date;
    if (this.workout != null) {
      data['workout'] = this.workout!.toJson();
    }
    return data;
  }
}

class Workout {
  String? id;
  String? name;
  String? userKey;

  Workout({this.id, this.name, this.userKey});

  Workout.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userKey = json['userKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['userKey'] = this.userKey;
    return data;
  }
}
