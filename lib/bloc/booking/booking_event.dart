part of 'booking_bloc.dart';

@immutable
abstract class BookingEvent {}

class BookingHariIniBlocEvent extends BookingEvent {}

class BookingCekKetersediaanBlocEvent extends BookingEvent {
  final int jumlah;
  final String tglMasuk;
  final String tglKeluar;

  BookingCekKetersediaanBlocEvent(this.jumlah, this.tglMasuk, this.tglKeluar);
}

class BookingLaporanBlocEvent extends BookingEvent {
  final String tglMasuk;
  final String tglKeluar;

  BookingLaporanBlocEvent(this.tglMasuk, this.tglKeluar);
}

class BookingProsesEvent extends BookingEvent {
  final Map<String, dynamic> data;

  BookingProsesEvent(this.data);
}

class BookingBatalkanEvent extends BookingEvent {
  final String noOrder;

  BookingBatalkanEvent(this.noOrder);
}

class BookingKonfirmasiEvent extends BookingEvent {
  final String noOrder;

  BookingKonfirmasiEvent(this.noOrder);
}

class BookingGetListEvent extends BookingEvent {
  final bool refresh;

  BookingGetListEvent({this.refresh = false});
}

class BookingAdminGetListEvent extends BookingEvent {
  final bool refresh;
  final bool isAdmin;
  final int status;

  BookingAdminGetListEvent(
      {this.refresh = false, this.isAdmin = false, this.status = 0});
}
