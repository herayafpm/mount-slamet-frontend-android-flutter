part of 'register_bloc.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterStateLoading extends RegisterState {}

class RegisterStateSuccess extends RegisterState {
  final Map<String, dynamic> data;

  RegisterStateSuccess(this.data);
}

class RegisterStateError extends RegisterState {
  final Map<String, dynamic> errors;

  RegisterStateError(this.errors);
}
