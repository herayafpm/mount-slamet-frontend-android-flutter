import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mount_slamet/repositories/booking_repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial());

  @override
  Stream<BookingState> mapEventToState(
    BookingEvent event,
  ) async* {
    if (event is BookingHariIniBlocEvent) {
      yield BookingStateLoading();
      Map<String, dynamic> res = await BookingRepository.bookingHariIni();
      if (res['statusCode'] == 400 || res['data']['status'] == false) {
        yield BookingStateError(res['data']);
      } else if (res['statusCode'] == 200) {
        yield BookingHariIniStateSuccess(res['data']);
      } else {
        yield BookingStateError(res['data']);
      }
    }
  }
}
