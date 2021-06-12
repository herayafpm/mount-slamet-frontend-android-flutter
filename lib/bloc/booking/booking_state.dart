part of 'booking_bloc.dart';

@immutable
abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingStateLoading extends BookingState {}

class BookingStateSuccess extends BookingState {
  final Map<String, dynamic> data;

  BookingStateSuccess(this.data);
}

class BookingHariIniStateSuccess extends BookingState {
  final Map<String, dynamic> data;

  BookingHariIniStateSuccess(this.data);
}

class BookingStateError extends BookingState {
  final Map<String, dynamic> errors;

  BookingStateError(this.errors);
}
