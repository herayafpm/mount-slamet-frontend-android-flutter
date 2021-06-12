import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/bloc/booking/booking_bloc.dart';
import 'package:mount_slamet/controllers/booking_controller.dart';
import 'package:mount_slamet/controllers/home_controller.dart';
import 'package:mount_slamet/ui/components/my_input_comp.dart';
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
  BookingBloc bloc;
  @override
  Widget build(BuildContext context) {
    bookingController.key = GlobalKey<FormState>();
    bloc = BlocProvider.of<BookingBloc>(context);
    return ScreenUtilInit(
        designSize: Size(Constants.screenWidth, Constants.screenHeight),
        builder: () => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Txt(
                  "Mount Slamet",
                  style: TxtStyle()..textColor(Colors.black87),
                ),
                iconTheme: IconThemeData(color: Colors.black87),
              ),
              drawer: Drawer(
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
                            size: 70.sp,
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
                    controller.tileDefault(
                        title: "Profile",
                        icon: Icon(Icons.person),
                        onTap: () {
                          // Get.toNamed("/home/profile");
                        }),
                    controller.tileDefault(
                        title: "About",
                        icon: Icon(Icons.info),
                        onTap: () {
                          controller.about();
                        }),
                    controller.tileDefault(
                        title: "Logout",
                        icon: Icon(Icons.power_settings_new),
                        onTap: () {
                          controller.confirmLogout();
                        }),
                  ],
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                    child: BlocListener<BookingBloc, BookingState>(
                  listener: (context, state) {
                    if (state is BookingStateLoading) {
                      controller.isLoading.value = true;
                    } else if (state is BookingHariIniStateSuccess) {
                      controller.jumlahBooking.value =
                          state.data['data']['jumlah_booking'] ?? 0;
                      controller.sisaSeat.value =
                          state.data['data']['sisa_seat'] ?? 0;
                      controller.jumlahPendaki.value =
                          state.data['data']['jumlah_pendaki'] ?? 50;
                    }
                  },
                  child: Parent(
                    style: ParentStyle()..padding(vertical: 20, horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Txt(
                              "Hi, ",
                              style: TxtStyle()..fontSize(20.sp),
                            ),
                            Obx(() => Txt(
                                  controller
                                      .userModel.value.userNama.capitalizeFirst,
                                  style: TxtStyle()
                                    ..fontSize(20.sp)
                                    ..bold(),
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
                            ..height(220)
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
                                              ..textColor(Colors.greenAccent)
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
                                  Txt(controller.sisaSeat.value.toString(),
                                      style: TxtStyle()
                                        ..textColor(Colors.greenAccent)
                                        ..fontSize(20.sp)
                                        ..bold()),
                                  Txt(" Orang",
                                      style: TxtStyle()
                                        ..textColor(Colors.white)
                                        ..fontSize(18.sp))
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Txt("Booking Sekarang",
                            style: TxtStyle()
                              ..textColor(Colors.black87)
                              ..fontSize(16.sp)),
                        SizedBox(height: 10),
                        Form(
                            key: bookingController.key,
                            child: Column(children: [
                              MyInputComp(
                                controller:
                                    bookingController.jumlahPendakiController,
                                prefixIcon: Icon(Icons.people),
                                type: TextInputType.number,
                                title: "Jumlah Pendaki",
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Jumlah Pendaki tidak boleh kosong";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 0.03.sh,
                              ),
                              TextButton(
                                  onPressed: () {
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
                                                      selectionMode:
                                                          DateRangePickerSelectionMode
                                                              .range,
                                                      view: DateRangePickerView
                                                          .month,
                                                      monthViewSettings:
                                                          DateRangePickerMonthViewSettings(
                                                              firstDayOfWeek:
                                                                  1),
                                                      onSelectionChanged:
                                                          (DateRangePickerSelectionChangedArgs
                                                              args) {
                                                        print("Date " +
                                                            args.value
                                                                .toString());
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ));
                                  },
                                  child: Text("Pilih Tanggal Masuk"))
                            ]))
                      ],
                    ),
                  ),
                )),
              ),
            ));
  }
}
