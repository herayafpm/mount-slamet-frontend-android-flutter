part of 'lupa_password_bloc.dart';

@immutable
abstract class LupaPasswordState {}

class LupaPasswordInitial extends LupaPasswordState {}

class LupaPasswordStateLoading extends LupaPasswordState {}

class LupaPasswordCekTokenSuccess extends LupaPasswordState {
  final Map<String, dynamic> data;

  LupaPasswordCekTokenSuccess(this.data);
}

class LupaPasswordStateSuccess extends LupaPasswordState {
  final Map<String, dynamic> data;

  LupaPasswordStateSuccess(this.data);
}

class LupaPasswordStateError extends LupaPasswordState {
  final Map<String, dynamic> errors;

  LupaPasswordStateError(this.errors);
}
