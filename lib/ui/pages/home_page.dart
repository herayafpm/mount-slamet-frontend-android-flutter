import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/bloc/booking/booking_bloc.dart';
import 'package:mount_slamet/controllers/booking_controller.dart';
import 'package:mount_slamet/controllers/home_controller.dart';
import 'package:mount_slamet/ui/components/my_button_comp.dart';
import 'package:mount_slamet/utils/date_time_util.dart';
import 'package:mount_slamet/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../constants.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingBloc()..add(BookingHariIniBlocEvent()),
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  final controller = Get.put(HomeController());
  final bookingController = Get.put(BookingController());
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  BookingBloc bloc;
  void _refreshApp() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    controller.updateUser();
    controller.updateFCM();
    bloc..add(BookingHariIniBlocEvent());
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    bookingController.key = GlobalKey<FormState>();
    bloc = BlocProvider.of<BookingBloc>(context);
    return ScreenUtilInit(
        designSize: Size(Constants.screenWidth, Constants.screenHeight),
        builder: () => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: Txt(
                  "Mount Slamet",
                  style: TxtStyle()..textColor(Colors.black87),
                ),
                iconTheme: IconThemeData(color: Colors.black87),
                actions: [
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () async {
                      if (_refreshController.position != null) {
                        _refreshController.requestRefresh();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_none),
                    onPressed: () {
                      Get.toNamed("/home/notifikasi");
                    },
                  ),
                ],
              ),
              drawer: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors
                      .white, //This will change the drawer background to blue.
                  //other styles
                ),
                child: Drawer(
                  // Add a ListView to the drawer. This ensures the user can scroll
                  // through the options in the drawer if there isn't enough vertical
                  // space to fit everything.

                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.user,
                              size: 60.sp,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Obx(() => Txt(
                                  controller
                                      .userModel.value.userNama.capitalizeFirst,
                                  style: TxtStyle()
                                    ..textColor(Colors.white70)
                                    ..bold()
                                    ..fontSize(20.sp),
                                )),
                            Obx(() => (controller.userModel.value.isAdmin)
                                ? Txt(
                                    controller
                                        .userModel.value.role.capitalizeFirst,
                                    style: TxtStyle()
                                      ..textColor(Colors.white70)
                                      ..bold()
                                      ..fontSize(15.sp),
                                  )
                                : Container())
                          ],
                        ),
                      ),
                      Txt(
                        "Menu",
                        style: TxtStyle()..padding(left: 10, top: 10),
                      ),
                      Obx(() => (!controller.userModel.value.isAdmin)
                          ? controller.tileDefault(
                              title: "Riwayat Booking",
                              icon: Icon(Icons.receipt_long_sharp),
                              onTap: () {
                                Navigator.pop(context);
                                Get.toNamed("/home/booking/riwayat");
                              })
                          : Container()),
                      Obx(() => (controller.userModel.value.isAdmin)
                          ? controller.tileDefault(
                              title: "Data Booking",
                              icon: Icon(Icons.receipt_long_sharp),
                              onTap: () {
                                Navigator.pop(context);
                                Get.toNamed("/home/admin/booking/riwayat");
                              })
                          : Container()),
                      controller.tileDefault(
                          title: "Akun",
                          icon: Icon(Icons.person),
                          onTap: () {
                            Navigator.pop(context);
                            Get.toNamed("/home/akun");
                          }),
                      controller.tileDefault(
                          title: "Informasi",
                          icon: Icon(Icons.article),
                          onTap: () {
                            Navigator.pop(context);
                            Get.toNamed("/home/informasi");
                          }),
                      controller.tileDefault(
                          title: "About",
                          icon: Icon(Icons.info),
                          onTap: () {
                            Navigator.pop(context);
                            controller.about();
                          }),
                      controller.tileDefault(
                          title: "Logout",
                          icon: Icon(Icons.power_settings_new),
                          onTap: () {
                            Navigator.pop(context);
                            controller.confirmLogout();
                          }),
                    ],
                  ),
                ),
              ),
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/images/night-landscape-background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SmartRefresher(
                  onRefresh: _refreshApp,
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: false,
                  header: WaterDropMaterialHeader(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: SafeArea(
                    child: SingleChildScrollView(
                        child: BlocListener<BookingBloc, BookingState>(
                      listener: (context, state) {
                        if (state is BookingStateLoading) {
                          controller.isLoading.value = true;
                        } else if (state is BookingHariIniStateSuccess) {
                          controller.isLoading.value = false;
                          controller.jumlahBooking.value =
                              state.data['data']['jumlah_booking'] ?? 0;
                          controller.sisaSeat.value =
                              state.data['data']['sisa_seat'] ?? 0;
                          controller.jumlahPendaki.value =
                              state.data['data']['jumlah_pendaki'] ?? 50;
                        } else if (state
                            is BookingCekKetersediaanStateSuccess) {
                          bookingController.isLoading.value = false;
                          ToastUtil.success(
                              message: state.data['message'] ?? "", time: 3);
                          Get.toNamed("/home/booking");
                        } else if (state is BookingLaporanStateSuccess) {
                          bookingController.isLoading.value = false;
                          ToastUtil.success(
                              message: state.data['message'] ?? "", time: 3);
                        } else if (state is BookingStateError) {
                          bookingController.isLoading.value = false;
                          ToastUtil.error(
                              message: state.errors['message'] ?? "", time: 8);
                        } else {
                          bookingController.isLoading.value = false;
                        }
                      },
                      child: Parent(
                        style: ParentStyle()
                          ..padding(vertical: 20, horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Txt("Hi, ",
                                    style: TxtStyle()
                                      ..fontSize(20.sp)
                                      ..textColor(Colors.white)),
                                Obx(() => Txt(
                                      controller.userModel.value.userNama
                                          .capitalizeFirst,
                                      style: TxtStyle()
                                        ..fontSize(20.sp)
                                        ..bold()
                                        ..textColor(Colors.white),
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Parent(
                              style: ParentStyle()
                                ..background.color(Colors.lightBlue)
                                ..width(1.sw)
                                ..borderRadius(all: 10)
                                ..padding(vertical: 20),
                              child: Column(
                                children: [
                                  Txt(
                                    "Jumlah Booking Hari Ini",
                                    style: TxtStyle()
                                      ..textColor(Colors.white)
                                      ..fontSize(20.sp)
                                      ..bold(),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Obx(() => Txt(
                                                controller.jumlahBooking.value
                                                    .toString(),
                                                style: TxtStyle()
                                                  ..fontSize(35.sp)
                                                  ..textColor(
                                                      Colors.greenAccent)
                                                  ..bold(),
                                              )),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Parent(
                                            style: ParentStyle()
                                              ..height(1)
                                              ..background.color(Colors.white)
                                              ..width(1.sw / 5),
                                            child: Container(),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Obx(
                                            () => Txt(
                                              controller.jumlahPendaki.value
                                                  .toString(),
                                              style: TxtStyle()
                                                ..fontSize(20.sp)
                                                ..textColor(Colors.white),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Txt(
                                        "Orang",
                                        style: TxtStyle()
                                          ..fontSize(20.sp)
                                          ..textColor(Colors.white)
                                          ..bold(),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Txt("Tersisa: ",
                                          style: TxtStyle()
                                            ..textColor(Colors.white)
                                            ..fontSize(18.sp)
                                            ..padding(left: 20)),
                                      Obx(() => Txt(
                                          controller.sisaSeat.value.toString(),
                                          style: TxtStyle()
                                            ..textColor(Colors.greenAccent)
                                            ..fontSize(20.sp)
                                            ..bold())),
                                      Txt(" Orang",
                                          style: TxtStyle()
                                            ..textColor(Colors.white)
                                            ..fontSize(18.sp))
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Column(children: [
                              SizedBox(height: 20),
                              Obx(
                                () => Txt(
                                    (controller.userModel.value.isAdmin)
                                        ? "Laporan"
                                        : "Booking Sekarang",
                                    style: TxtStyle()
                                      ..textColor(Colors.black87)
                                      ..fontSize(16.sp)),
                              ),
                              SizedBox(height: 10),
                              Form(
                                  key: bookingController.key,
                                  child: Column(children: [
                                    Obx(() =>
                                        (!controller.userModel.value.isAdmin)
                                            ? Txt("Jumlah Pendaki",
                                                style: TxtStyle()
                                                  ..textColor(Colors.black87)
                                                  ..alignment.centerLeft()
                                                  ..fontSize(14.sp))
                                            : Container()),
                                    SizedBox(height: 10),
                                    Obx(
                                      () => (controller.userModel.value.isAdmin)
                                          ? Container()
                                          : Parent(
                                              style: ParentStyle()
                                                ..background.color(Colors.white)
                                                ..padding(
                                                    horizontal: 8, vertical: 8)
                                                ..borderRadius(all: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onLongPressStart:
                                                        (_) async {
                                                      bookingController.isTapMin
                                                          .value = true;
                                                      do {
                                                        if (bookingController
                                                                .jumlah.value >
                                                            1) {
                                                          bookingController
                                                              .jumlah.value--;
                                                        } else {
                                                          bookingController
                                                              .isTapMin
                                                              .value = false;
                                                        }
                                                        await Future.delayed(
                                                            Duration(
                                                                milliseconds:
                                                                    100));
                                                      } while (bookingController
                                                          .isTapMin.value);
                                                    },
                                                    onLongPressEnd: (_) =>
                                                        bookingController
                                                            .isTapMin
                                                            .value = false,
                                                    onTap: () {
                                                      if (bookingController
                                                              .jumlah.value >
                                                          1) {
                                                        bookingController
                                                            .jumlah.value--;
                                                      }
                                                    },
                                                    child: Icon(Icons.remove,
                                                        color:
                                                            Colors.blueAccent),
                                                  ),
                                                  Obx(() => Txt(
                                                        "${bookingController.jumlah.value}",
                                                        style: TxtStyle()
                                                          ..textColor(
                                                              Colors.black54)
                                                          ..fontSize(15.sp),
                                                      )),
                                                  GestureDetector(
                                                      onLongPressStart:
                                                          (_) async {
                                                        bookingController
                                                            .isTapPlus
                                                            .value = true;
                                                        do {
                                                          if (bookingController
                                                                  .jumlah
                                                                  .value <
                                                              controller
                                                                  .jumlahPendaki
                                                                  .value) {
                                                            bookingController
                                                                .jumlah.value++;
                                                          } else {
                                                            bookingController
                                                                .isTapPlus
                                                                .value = false;
                                                          }
                                                          await Future.delayed(
                                                              Duration(
                                                                  milliseconds:
                                                                      100));
                                                        } while (
                                                            bookingController
                                                                .isTapPlus
                                                                .value);
                                                      },
                                                      onLongPressEnd: (_) =>
                                                          bookingController
                                                              .isTapPlus
                                                              .value = false,
                                                      onTap: () {
                                                        if (bookingController
                                                                .jumlah.value <
                                                            controller
                                                                .jumlahPendaki
                                                                .value) {
                                                          bookingController
                                                              .jumlah.value++;
                                                        }
                                                      },
                                                      child: Icon(Icons.add,
                                                          color: Colors
                                                              .blueAccent))
                                                ],
                                              ),
                                            ),
                                    ),
                                    SizedBox(height: 10),
                                    Txt("Tanggal Masuk",
                                        style: TxtStyle()
                                          ..textColor(Colors.black87)
                                          ..alignment.centerLeft()
                                          ..fontSize(14.sp)),
                                    SizedBox(height: 10),
                                    Parent(
                                      style: ParentStyle()
                                        ..background.color(Colors.white)
                                        ..padding(horizontal: 8)
                                        ..borderRadius(all: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Obx(
                                            () => Txt(
                                                DateTimeUtil.toDateHumanize(
                                                    bookingController
                                                        .tglMasuk.value
                                                        .toString())),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                                Icons.calendar_today_outlined,
                                                color: Colors.blueAccent),
                                            onPressed: () {
                                              tglMasukCalendar(context);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Txt("Tanggal Pulang",
                                        style: TxtStyle()
                                          ..textColor(Colors.black87)
                                          ..alignment.centerLeft()
                                          ..fontSize(14.sp)),
                                    SizedBox(height: 10),
                                    Parent(
                                      style: ParentStyle()
                                        ..background.color(Colors.white)
                                        ..padding(horizontal: 8)
                                        ..borderRadius(all: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Obx(
                                            () => Txt(
                                                DateTimeUtil.toDateHumanize(
                                                    bookingController
                                                        .tglKeluar.value
                                                        .toString())),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                                Icons.calendar_today_outlined,
                                                color: Colors.blueAccent),
                                            onPressed: () {
                                              tglKeluarCalendar(context);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Obx(() => MyButtonComp(
                                        isLoading:
                                            bookingController.isLoading.value,
                                        title:
                                            (controller.userModel.value.isAdmin)
                                                ? "Download"
                                                : "Cek Ketersediaan",
                                        color: Colors.blue,
                                        onTap: (bookingController
                                                .isLoading.value)
                                            ? () {}
                                            : () {
                                                if (controller
                                                    .userModel.value.isAdmin) {
                                                  bookingController
                                                      .laporan(bloc);
                                                } else {
                                                  if (!controller.userModel
                                                          .value.isAdmin &&
                                                      (controller
                                                              .userModel
                                                              .value
                                                              .userAlamat
                                                              .isEmpty ||
                                                          controller
                                                              .userModel
                                                              .value
                                                              .userNoTelp
                                                              .isEmpty ||
                                                          controller
                                                              .userModel
                                                              .value
                                                              .userNoTelpOt
                                                              .isEmpty)) {
                                                    Get.offNamedUntil(
                                                        "/home/akun/ubah_profile",
                                                        ModalRoute.withName(
                                                            '/home'));
                                                    ToastUtil.success(
                                                        message:
                                                            "Harap Lengkapi data diri");
                                                  } else {
                                                    bookingController
                                                        .cekKetersediaan(bloc);
                                                  }
                                                }
                                              })),
                                  ]))
                            ]),
                          ],
                        ),
                      ),
                    )),
                  ),
                ),
              ),
            ));
  }

  void tglMasukCalendar(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Tanggal Masuk"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
              content: Container(
                width: 1.sw,
                height: 350,
                child: Container(
                  width: 1.sw,
                  height: 250,
                  child: Card(
                    child: SfDateRangePicker(
                      selectionMode: DateRangePickerSelectionMode.single,
                      initialSelectedDate: bookingController.tglMasuk.value,
                      minDate: (controller.userModel.value.isAdmin)
                          ? null
                          : DateTime.now(),
                      view: DateRangePickerView.month,
                      monthViewSettings:
                          DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        bookingController.tglMasuk.value = args.value;
                        bookingController.tglKeluar.value = args.value;
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
              title: Text("Tanggal Pulang"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
              content: Container(
                width: 1.sw,
                height: 350,
                child: Container(
                  width: 1.sw,
                  height: 250,
                  child: Card(
                    child: SfDateRangePicker(
                      selectionMode: DateRangePickerSelectionMode.single,
                      initialSelectedDate: (bookingController.tglKeluar.value),
                      minDate: bookingController.tglMasuk.value,
                      view: DateRangePickerView.month,
                      monthViewSettings:
                          DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        bookingController.tglKeluar.value = args.value;
                      },
                    ),
                  ),
                ),
              ),
            ));
  }
}
