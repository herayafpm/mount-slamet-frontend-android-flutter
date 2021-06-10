part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginStateLoading extends LoginState {}

class LoginStateSuccess extends LoginState {
  final Map<String, dynamic> data;

  LoginStateSuccess(this.data);
}

class LoginStateError extends LoginState {
  final Map<String, dynamic> errors;

  LoginStateError(this.errors);
}
