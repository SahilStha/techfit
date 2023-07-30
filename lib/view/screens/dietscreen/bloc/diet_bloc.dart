import 'dart:async';

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

part 'diet_event.dart';
part 'diet_state.dart';

@injectable
class DietBloc extends Bloc<DietEvent, DietState> {
  final ApiClient _apiClient;
  DietBloc(this._apiClient) : super(const DietState()) {
    on<GetDiets>(_getDiets);
    on<DeleteDiet>(_deleteDiet);
    on<CheckUncheckDiet>(_checkUnchekDiet);
    on<CreateDiet>(_createDiet);
    on<ReturnInitialDiet>(_retunriintial);
  }

  FutureOr<void> _getDiets(GetDiets event, Emitter<DietState> emit) async {
    try {
      Map<String, dynamic> query = {"userKey": await getEmail()};
      var apiResponse = await _apiClient.httpGet(Endpoints.diets, param: query);
      var response = ApiResponseForList(
        status: Status.success,
        message: 'Successfully got diets',
        data: (apiResponse as List<dynamic>)
            .map((data) => DieitsResponse.fromJson(data))
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

  FutureOr<void> _deleteDiet(DeleteDiet event, Emitter<DietState> emit) async {
    try {
      await _apiClient.httpDelete(Endpoints.deleteDiet(event.dietId));
      add(GetDiets());
    } catch (e) {
      try {
        e as ApiErrorResponse;
        displayToastMessage(e.details?[0].msg ?? 'Error getting data');
      } catch (e) {
        displayToastMessage('Error', backgroundColor: Colors.red);
      }
    }
  }

  FutureOr<void> _checkUnchekDiet(
      CheckUncheckDiet event, Emitter<DietState> emit) async {
    try {
      Map<String, dynamic> data = {
        "name": event.dietName,
        "userKey": await getEmail()
      };

      await _apiClient.httpPatch(
          Endpoints.checkUncheckDiet(event.dietId), data);
      add(GetDiets());
    } catch (e) {
      try {
        e as ApiErrorResponse;
        displayToastMessage(e.details?[0].msg ?? 'Error getting data');
      } catch (e) {
        displayToastMessage('Error', backgroundColor: Colors.red);
      }
    }
  }

  FutureOr<void> _createDiet(CreateDiet event, Emitter<DietState> emit) async {
    try {
      Map<String, dynamic> data = {
        "name": event.dietName,
        "userKey": await getEmail()
      };
      await _apiClient.httpPost(Endpoints.diets, data);
      add(GetDiets());
    } catch (e) {
      try {
        e as ApiErrorResponse;
        displayToastMessage(e.details?[0].msg ?? 'Error getting data');
      } catch (e) {
        displayToastMessage('Error', backgroundColor: Colors.red);
      }
    }
  }

  FutureOr<void> _retunriintial(
      ReturnInitialDiet event, Emitter<DietState> emit) {
    emit(state.copyWith(theStates: TheStates.initial));
  }
}

class DieitsResponse {
  String? id;
  String? name;
  bool? isChecked;
  String? userKey;
  String? date;

  DieitsResponse({this.id, this.name, this.isChecked, this.userKey, this.date});

  DieitsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isChecked = json['isChecked'];
    userKey = json['userKey'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isChecked'] = this.isChecked;
    data['userKey'] = this.userKey;
    data['date'] = this.date;
    return data;
  }
}
