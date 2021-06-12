part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class RegisterBlocEvent extends RegisterEvent {
  final Map<String, dynamic> user;

  RegisterBlocEvent(this.user);
}
