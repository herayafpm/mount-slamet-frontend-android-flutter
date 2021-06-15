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

class BookingCekKetersediaanStateSuccess extends BookingState {
  final Map<String, dynamic> data;

  BookingCekKetersediaanStateSuccess(this.data);
}

class BookingLaporanStateSuccess extends BookingState {
  final Map<String, dynamic> data;

  BookingLaporanStateSuccess(this.data);
}

class BookingStateError extends BookingState {
  final Map<String, dynamic> errors;

  BookingStateError(this.errors);
}

class BookingListLoaded extends BookingState {
  List<BookingModel> booking;
  bool hasReachMax;

  BookingListLoaded({this.booking, this.hasReachMax});
  BookingListLoaded copyWith({List<BookingModel> booking, bool hasReachMax}) {
    return BookingListLoaded(
        booking: booking ?? this.booking,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }
}
