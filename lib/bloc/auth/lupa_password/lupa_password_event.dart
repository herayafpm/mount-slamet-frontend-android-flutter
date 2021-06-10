part of 'lupa_password_bloc.dart';

@immutable
abstract class LupaPasswordEvent {}

class LupaPasswordBlocEvent extends LupaPasswordEvent {
  final String userEmail;

  LupaPasswordBlocEvent(this.userEmail);
}

class CekKodeEvent extends LupaPasswordEvent {
  final String userEmail;
  final int kodeOtp;

  CekKodeEvent(this.userEmail, this.kodeOtp);
}

class UbahPasswordEvent extends LupaPasswordEvent {
  final String userEmail;
  final int kodeOtp;
  final String userPassword;

  UbahPasswordEvent(this.userEmail, this.kodeOtp, this.userPassword);
}
