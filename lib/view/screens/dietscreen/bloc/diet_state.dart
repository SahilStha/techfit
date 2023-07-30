// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'diet_bloc.dart';

class DietState extends Equatable {
  final String? errorMessage;
  final TheStates theStates;
  final List<DieitsResponse>? response;
  const DietState({
    this.errorMessage,
    this.theStates = TheStates.initial,
    this.response,
  });
  @override
  List<Object?> get props => [errorMessage, theStates, response];

  DietState copyWith({
    String? errorMessage,
    TheStates? theStates,
    List<DieitsResponse>? response,
  }) {
    return DietState(
      errorMessage: errorMessage ?? this.errorMessage,
      theStates: theStates ?? this.theStates,
      response: response ?? this.response,
    );
  }
}
