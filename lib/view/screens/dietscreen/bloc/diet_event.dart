part of 'diet_bloc.dart';

abstract class DietEvent {}

class GetDiets extends DietEvent {
  GetDiets();
}

class CreateDiet extends DietEvent {
  final String dietName;

  CreateDiet({required this.dietName});
}

class CheckUncheckDiet extends DietEvent {
  final bool isChecked;
  final String dietId;
  final String dietName;

  CheckUncheckDiet(
      {required this.dietName, required this.isChecked, required this.dietId});
}

class DeleteDiet extends DietEvent {
  final String dietId;

  DeleteDiet({required this.dietId});
}
