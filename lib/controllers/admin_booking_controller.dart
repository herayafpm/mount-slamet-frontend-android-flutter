import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/bloc/booking/booking_bloc.dart';
import 'package:mount_slamet/ui/components/my_input_comp.dart';
import 'package:mount_slamet/utils/date_time_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AdminBookingController extends GetxController {
  final tab = 0.obs;
  final tglMasuk =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  final tglKeluar =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  final title = "Hari Ini".obs;
  final bookingBloc = BookingBloc().obs;
  final cari = "".obs;
  final refreshController = RefreshController().obs;

  void updateDataDate(value) {
    var now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    title.value = value;
    tglMasuk.value = now;
    tglKeluar.value = now;
    String title_esc = title.value.toLowerCase().replaceAll(" ", "_");
    switch (title_esc) {
      case "hari_ini":
        tglMasuk.value = now;
        tglKeluar.value = now;
        if (refreshController.value.position != null) {
          refreshController.value.requestRefresh();
        }
        bookingBloc.value
          ..add(BookingAdminGetListEvent(
              refresh: true,
              isAdmin: true,
              status: tab.value,
              bookingTglMasuk: DateTimeUtil.onlyDate(tglMasuk.value),
              bookingTglKeluar: DateTimeUtil.onlyDate(tglKeluar.value),
              cari: cari.value));
        break;
      case "bulan_ini":
        tglMasuk.value = DateTime(DateTime.now().year, DateTime.now().month, 1);
        tglKeluar.value = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime(now.year, now.month - 1, 1)
                .subtract(Duration(days: 1))
                .day);
        if (refreshController.value.position != null) {
          refreshController.value.requestRefresh();
        }
        bookingBloc.value
          ..add(BookingAdminGetListEvent(
              refresh: true,
              isAdmin: true,
              status: tab.value,
              bookingTglMasuk: DateTimeUtil.onlyDate(tglMasuk.value),
              bookingTglKeluar: DateTimeUtil.onlyDate(tglKeluar.value),
              cari: cari.value));
        break;
      case "tahun_ini":
        tglMasuk.value = DateTime(DateTime.now().year);
        tglKeluar.value = DateTime(DateTime.now().year, 12,
            DateTime(now.year + 1, 1, 1).subtract(Duration(days: 1)).day);
        if (refreshController.value.position != null) {
          refreshController.value.requestRefresh();
        }
        bookingBloc.value
          ..add(BookingAdminGetListEvent(
              refresh: true,
              isAdmin: true,
              status: tab.value,
              bookingTglMasuk: DateTimeUtil.onlyDate(tglMasuk.value),
              bookingTglKeluar: DateTimeUtil.onlyDate(tglKeluar.value),
              cari: cari.value));
        break;
      case "custom":
        customCalendar();
        break;
    }
  }

  void customCalendar() {
    showDialog(
        context: Get.context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                  child: Text("Tutup"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Simpan"),
                  onPressed: () {
                    Navigator.pop(context);
                    if (refreshController.value.position != null) {
                      refreshController.value.requestRefresh();
                    }
                    bookingBloc.value
                      ..add(BookingAdminGetListEvent(
                          refresh: true,
                          isAdmin: true,
                          status: tab.value,
                          bookingTglMasuk:
                              DateTimeUtil.onlyDate(tglMasuk.value),
                          bookingTglKeluar:
                              DateTimeUtil.onlyDate(tglKeluar.value),
                          cari: cari.value));
                  },
                )
              ],
              title: Text("Pilih Tanggal Awal dan Akhir"),
              content: Parent(
                style: ParentStyle()..height(150),
                child: Column(
                  children: [
                    Parent(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => Txt(DateTimeUtil.toDateHumanize(
                                tglMasuk.value.toString())),
                          ),
                          IconButton(
                            icon: Icon(Icons.calendar_today,
                                color: Colors.blueAccent),
                            onPressed: () {
                              tglMasukCalendar(context);
                            },
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Parent(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => Txt(DateTimeUtil.toDateHumanize(
                                tglKeluar.value.toString())),
                          ),
                          IconButton(
                            icon: Icon(Icons.calendar_today,
                                color: Colors.blueAccent),
                            onPressed: () {
                              tglKeluarCalendar(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  void tglMasukCalendar(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Tanggal Awal"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
              content: Container(
                width: Get.width,
                height: 350,
                child: Container(
                  width: Get.width,
                  height: 250,
                  child: Card(
                    child: SfDateRangePicker(
                      selectionMode: DateRangePickerSelectionMode.single,
                      initialSelectedDate: tglMasuk.value,
                      view: DateRangePickerView.month,
                      monthViewSettings:
                          DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        tglMasuk.value = args.value;
                        tglKeluar.value = args.value;
                      },
                    ),
                  ),
                ),
              ),
            ));
  }

  void tglKeluarCalendar(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Tanggal Akhir"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
              content: Container(
                width: Get.width,
                height: 350,
                child: Container(
                  width: Get.width,
                  height: 250,
                  child: Card(
                    child: SfDateRangePicker(
                      selectionMode: DateRangePickerSelectionMode.single,
                      initialSelectedDate: (tglKeluar.value),
                      minDate: tglMasuk.value,
                      view: DateRangePickerView.month,
                      monthViewSettings:
                          DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        tglKeluar.value = args.value;
                      },
                    ),
                  ),
                ),
              ),
            ));
  }

  void search() {
    TextEditingController cariController = TextEditingController();
    cariController.text = "BK";
    showDialog(
        context: Get.context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                  child: Text("Tutup"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Cari"),
                  onPressed: () {
                    Navigator.pop(context);
                    cari.value = cariController.text;
                    if (refreshController.value.position != null) {
                      refreshController.value.requestRefresh();
                    }
                  },
                )
              ],
              title: Text("Pencarian"),
              content: Parent(
                style: ParentStyle()..height(80),
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: MyInputComp(
                        controller: cariController,
                        title: "No Booking",
                        validator: (value) {
                          if (value.isEmpty) {
                            return "No Booking tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
