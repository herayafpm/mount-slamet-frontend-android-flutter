part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginBlocEvent extends LoginEvent {
  final String userEmail;
  final String userPassword;

  LoginBlocEvent(this.userEmail, this.userPassword);
}

class LoginWithGoogleBlocEvent extends LoginEvent {
  final String userAuthKey;

  LoginWithGoogleBlocEvent(this.userAuthKey);
}
