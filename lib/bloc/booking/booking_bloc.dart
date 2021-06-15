import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mount_slamet/models/booking_model.dart';
import 'package:mount_slamet/repositories/admin/booking_admin_repository.dart';
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
    } else if (event is BookingCekKetersediaanBlocEvent) {
      yield BookingStateLoading();
      Map<String, dynamic> cek = new Map<String, dynamic>();
      cek['booking_jml_anggota'] = event.jumlah;
      cek['booking_tgl_masuk'] = event.tglMasuk;
      cek['booking_tgl_keluar'] = event.tglKeluar;
      Map<String, dynamic> res =
          await BookingRepository.bookingCekKetersediaan(cek);
      if (res['statusCode'] == 400 || res['data']['status'] == false) {
        yield BookingStateError(res['data']);
      } else if (res['statusCode'] == 200) {
        yield BookingCekKetersediaanStateSuccess(res['data']);
      } else {
        yield BookingStateError(res['data']);
      }
    } else if (event is BookingProsesEvent) {
      yield BookingStateLoading();
      Map<String, dynamic> res = await BookingRepository.booking(event.data);
      if (res['statusCode'] == 400 || res['data']['status'] == false) {
        yield BookingStateError(res['data']);
      } else if (res['statusCode'] == 200) {
        yield BookingStateSuccess(res['data']);
      } else {
        yield BookingStateError(res['data']);
      }
    } else if (event is BookingGetListEvent) {
      List<BookingModel> booking = [];
      if (state is BookingInitial || event.refresh) {
        Map<String, dynamic> res =
            await BookingRepository.bookingAll(limit: 10, offset: 0);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          booking = jsonObject
              .map<BookingModel>((e) => BookingModel.createFromJson(e))
              .toList();
          yield BookingListLoaded(booking: booking, hasReachMax: false);
        } else if (res['statusCode'] == 400) {
          yield BookingStateError(res['data']);
        } else {
          yield BookingStateError(res['data']);
        }
      } else if (state is BookingListLoaded) {
        BookingListLoaded bookingListLoaded = state as BookingListLoaded;
        Map<String, dynamic> res = await BookingRepository.bookingAll(
            limit: 10, offset: bookingListLoaded.booking.length);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          if (jsonObject.length == 0) {
            yield bookingListLoaded.copyWith(hasReachMax: true);
          } else {
            booking = jsonObject
                .map<BookingModel>((e) => BookingModel.createFromJson(e))
                .toList();
            yield BookingListLoaded(
                booking: bookingListLoaded.booking + booking,
                hasReachMax: false);
          }
        } else if (res['statusCode'] == 400) {
          yield BookingStateError(res['data']);
        } else {
          yield BookingStateError(res['data']);
        }
      }
    } else if (event is BookingAdminGetListEvent) {
      List<BookingModel> booking = [];
      if (state is BookingInitial || event.refresh) {
        Map<String, dynamic> res = await BookingAdminRepository.bookingAll(
            limit: 10, offset: 0, bookingStatus: event.status);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          booking = jsonObject
              .map<BookingModel>((e) => BookingModel.createFromJson(e))
              .toList();
          yield BookingListLoaded(booking: booking, hasReachMax: false);
        } else if (res['statusCode'] == 400) {
          yield BookingStateError(res['data']);
        } else {
          yield BookingStateError(res['data']);
        }
      } else if (state is BookingListLoaded) {
        BookingListLoaded bookingListLoaded = state as BookingListLoaded;
        Map<String, dynamic> res = await BookingAdminRepository.bookingAll(
            limit: 10,
            offset: bookingListLoaded.booking.length,
            bookingStatus: event.status);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          if (jsonObject.length == 0) {
            yield bookingListLoaded.copyWith(hasReachMax: true);
          } else {
            booking = jsonObject
                .map<BookingModel>((e) => BookingModel.createFromJson(e))
                .toList();
            yield BookingListLoaded(
                booking: bookingListLoaded.booking + booking,
                hasReachMax: false);
          }
        } else if (res['statusCode'] == 400) {
          yield BookingStateError(res['data']);
        } else {
          yield BookingStateError(res['data']);
        }
      }
    } else if (event is BookingBatalkanEvent) {
      yield BookingStateLoading();
      Map<String, dynamic> res =
          await BookingRepository.bookingBatalkan(event.noOrder);
      if (res['statusCode'] == 400 || res['data']['status'] == false) {
        yield BookingStateError(res['data']);
      } else if (res['statusCode'] == 200) {
        yield BookingStateSuccess(res['data']);
      } else {
        yield BookingStateError(res['data']);
      }
    } else if (event is BookingKonfirmasiEvent) {
      yield BookingStateLoading();
      Map<String, dynamic> res =
          await BookingAdminRepository.bookingKonfirmasi(event.noOrder);
      if (res['statusCode'] == 400 || res['data']['status'] == false) {
        yield BookingStateError(res['data']);
      } else if (res['statusCode'] == 200) {
        yield BookingStateSuccess(res['data']);
      } else {
        yield BookingStateError(res['data']);
      }
    } else if (event is BookingLaporanBlocEvent) {
      yield BookingStateLoading();
      Map<String, dynamic> res = await BookingAdminRepository.bookingLaporan(
          event.tglMasuk, event.tglKeluar);
      if (res['statusCode'] == 400 || res['data']['status'] == false) {
        yield BookingStateError(res['data']);
      } else if (res['statusCode'] == 200) {
        yield BookingLaporanStateSuccess(res['data']);
      } else {
        yield BookingStateError(res['data']);
      }
    }
  }
}
