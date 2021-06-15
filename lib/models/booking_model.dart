import 'package:mount_slamet/utils/date_time_util.dart';

enum Status {
  Proses,
  Konfirmasi,
  Dibatalkan,
}

class BookingModel {
  String bookingNoOrder;
  String userNama;
  String userEmail;
  String userAlamat;
  String userNoTelp;
  String userNoTelpOt;
  String bookingNama;
  String bookingAlamat;
  String bookingNoTelp;
  int bookingJmlAnggota;
  DateTime bookingTglMasuk;
  DateTime bookingTglKeluar;
  Status bookingStatus;
  DateTime bookingCreated;
  BookingModel({
    this.bookingNoOrder = "",
    this.userNama = "",
    this.userEmail = "",
    this.userAlamat = "",
    this.userNoTelp = "",
    this.userNoTelpOt = "",
    this.bookingNama = "",
    this.bookingAlamat = "",
    this.bookingNoTelp = "",
    this.bookingJmlAnggota = 0,
    this.bookingTglMasuk,
    this.bookingTglKeluar,
    this.bookingStatus,
    this.bookingCreated,
  });
  factory BookingModel.createFromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingNoOrder: json['booking_no_order'] ?? "",
      userNama: json['user_nama'] ?? "",
      userEmail: json['user_email'] ?? "",
      userAlamat: json['user_alamat'] ?? "",
      userNoTelp: json['user_no_telp'] ?? "",
      userNoTelpOt: json['user_no_telp_ot'] ?? "",
      bookingNama: json['booking_nama'] ?? "",
      bookingAlamat: json['booking_alamat'] ?? "",
      bookingNoTelp: json['booking_no_telp'] ?? "",
      bookingJmlAnggota: int.parse(json['booking_jml_anggota']) ?? 0,
      bookingTglMasuk: DateTimeUtil.toDate(json['booking_tgl_masuk']),
      bookingTglKeluar: DateTimeUtil.toDate(json['booking_tgl_keluar']),
      bookingStatus: Status.values[int.parse(json['booking_status'])],
      bookingCreated: DateTimeUtil.toDate(json['booking_created']),
    );
  }

  bool bookingStatusIs(String status) {
    if (status == 'proses') return this.bookingStatus == Status.Proses;
    if (status == 'konfirmasi') return this.bookingStatus == Status.Konfirmasi;
    if (status == 'dibatalkan') return this.bookingStatus == Status.Dibatalkan;
    return false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_nama'] = this.bookingNama;
    data['booking_alamat'] = this.bookingAlamat;
    data['booking_no_telp'] = this.bookingNoTelp;
    data['booking_jml_anggota'] = this.bookingJmlAnggota;
    data['booking_tgl_masuk'] = this.bookingTglMasuk;
    data['booking_tgl_keluar'] = this.bookingTglKeluar;
    return data;
  }
}
