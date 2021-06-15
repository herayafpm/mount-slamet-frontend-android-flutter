part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class ProfileUbahEvent extends ProfileEvent {
  final Map<String, dynamic> user;

  ProfileUbahEvent(this.user);
}

class ProfileUbahPasswordEvent extends ProfileEvent {
  final String password;

  ProfileUbahPasswordEvent(this.password);
}
