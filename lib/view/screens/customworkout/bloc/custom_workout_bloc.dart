// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:work_out/common/api_response.dart';

import 'package:work_out/providers/api_client.dart';
import 'package:work_out/utils/endpoints.dart';
import 'package:work_out/utils/utils.dart';
import 'package:work_out/view/screens/customworkout/customworkoutUI.dart';

part 'custom_workout_event.dart';
part 'custom_workout_state.dart';

@injectable
class CustomWorkoutBloc extends Bloc<CustomWorkoutEvent, CustomWorkoutState> {
  final ApiClient _apiClient;
  CustomWorkoutBloc(
    this._apiClient,
  ) : super(const CustomWorkoutState()) {
    on<CreateCustomWorkout>(_createWorkout);
    on<GetCustomWorkouts>(_getCustomWorkouts);
    on<DeleteWorkout>(_deleteWorkout);
    on<GetHeatLevels>(_getHeatLevels);
    on<GetVideos>(_getVideos);
    on<ReturnInitialCustom>(_returnInitail);
  }

  FutureOr<void> _createWorkout(
      CreateCustomWorkout event, Emitter<CustomWorkoutState> emit) async {
    try {
      Map<String, dynamic> data = {
        "name": event.workoutName,
        "userKey": event.userKey
      };
      await _apiClient.httpPost(Endpoints.workouts, data);
      add(GetCustomWorkouts(email: event.userKey));
    } catch (e) {
      try {
        e as ApiErrorResponse;
        displayToastMessage(e.details?[0].msg ?? 'Error getting data');
      } catch (e) {
        displayToastMessage('Error', backgroundColor: Colors.red);
      }
    }
  }

  FutureOr<void> _getCustomWorkouts(
      GetCustomWorkouts event, Emitter<CustomWorkoutState> emit) async {
    try {
      add(GetHeatLevels(email: event.email));
      Map<String, dynamic> query = {"userKey": event.email};
      var apiResponse =
          await _apiClient.httpGet(Endpoints.workouts, param: query);

      var response = ApiResponseForList(
        status: Status.success,
        message: 'Successfully got workouts',
        data: (apiResponse as List<dynamic>)
            .map((data) => CustomWorkoutResponse.fromJson(data))
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

  FutureOr<void> _deleteWorkout(
      DeleteWorkout event, Emitter<CustomWorkoutState> emit) async {
    try {
      await _apiClient.httpDelete(Endpoints.deteleWorkout(event.workoutId));
      add(GetCustomWorkouts(email: await getEmail()));
    } catch (e) {
      try {
        e as ApiErrorResponse;
        displayToastMessage(e.details?[0].msg ?? 'Error getting data');
      } catch (e) {
        displayToastMessage('Error', backgroundColor: Colors.red);
      }
    }
  }

  FutureOr<void> _getHeatLevels(
      GetHeatLevels event, Emitter<CustomWorkoutState> emit) async {
    try {
      Map<String, dynamic> query = {"userKey": event.email};
      var apiResponse =
          await _apiClient.httpGet(Endpoints.heatLevel, param: query);

      var response = ApiResponse(
          status: Status.success,
          message: 'Successfully got workouts',
          data: HeatLevelResponse.fromJson(apiResponse));
      emit(state.copyWith(
          theStates: TheStates.success, heatlevels: response.data));
    } catch (e) {
      try {
        e as ApiErrorResponse;
        displayToastMessage(e.details?[0].msg ?? 'Error getting data');
      } catch (e) {
        displayToastMessage('Error', backgroundColor: Colors.red);
      }
    }
  }

  FutureOr<void> _getVideos(
      GetVideos event, Emitter<CustomWorkoutState> emit) async {
    try {
      var apiResponse = await _apiClient.httpGet(Endpoints.getVideos);

      var response = ApiResponseForList(
        status: Status.success,
        message: 'Successfully got workouts',
        data: (apiResponse as List<dynamic>)
            .map((data) => VideoResponse.fromJson(data))
            .toList(),
      );
      emit(state.copyWith(theStates: TheStates.success, videos: response.data));
    } catch (e) {
      try {
        e as ApiErrorResponse;
        displayToastMessage(e.details?[0].msg ?? 'Error getting data');
      } catch (e) {
        displayToastMessage('Error', backgroundColor: Colors.red);
      }
    }
  }

  FutureOr<void> _returnInitail(
      ReturnInitialCustom event, Emitter<CustomWorkoutState> emit) {
    emit(state.copyWith(theStates: TheStates.initial));
  }
}
