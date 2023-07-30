// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'excersice_bloc.dart';

class ExcersiseState extends Equatable {
  final String? errorMessage;
  final TheStates theStates;
  final bool shouldReload;
  final List<ExcersiseResponse>? response;

  const ExcersiseState({
    this.shouldReload = false,
    this.errorMessage,
    this.theStates = TheStates.initial,
    this.response,
  });

  @override
  List<Object?> get props => [errorMessage, theStates, response, shouldReload];

  ExcersiseState copyWith({
    String? errorMessage,
    TheStates? theStates,
    bool? shouldReload,
    List<ExcersiseResponse>? response,
  }) {
    return ExcersiseState(
        errorMessage: errorMessage ?? this.errorMessage,
        theStates: theStates ?? this.theStates,
        response: response ?? this.response,
        shouldReload: shouldReload ?? false);
  }
}
