import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/bloc/booking/booking_bloc.dart';
import 'package:mount_slamet/controllers/detail_booking_controller.dart';
import 'package:mount_slamet/controllers/home_controller.dart';
import 'package:mount_slamet/models/booking_model.dart';
import 'package:mount_slamet/ui/components/my_button_comp.dart';
import 'package:mount_slamet/utils/date_time_util.dart';
import 'package:mount_slamet/utils/toast_util.dart';

import '../../constants.dart';

class DetailBookingPage extends StatelessWidget {
  BookingModel booking;
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    booking = Get.arguments;
    return BlocProvider(
      create: (context) => BookingBloc(),
      child: DetailBookingView(
        booking: booking,
        homeController: homeController,
      ),
    );
  }
}

class DetailBookingView extends StatelessWidget {
  final controller = Get.put(DetailBookingController());
  final BookingModel booking;
  final HomeController homeController;

  DetailBookingView({Key key, this.booking, this.homeController})
      : super(key: key);
  BookingBloc bloc;

  @override
  Widget build(BuildContext context) {
    controller.noOrder.value = booking.bookingNoOrder;
    bloc = BlocProvider.of<BookingBloc>(context);
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingStateLoading) {
          controller.isLoading.value = true;
        } else {
          controller.isLoading.value = false;
          if (state is BookingStateSuccess) {
            ToastUtil.success(message: state.data['message'] ?? '');
            Get.back();
          } else if (state is BookingStateError) {
            ToastUtil.error(message: state.errors['message'] ?? '');
          }
        }
      },
      child: ScreenUtilInit(
          designSize: Size(Constants.screenWidth, Constants.screenHeight),
          builder: () => Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Txt(
                    booking.bookingNoOrder,
                    style: TxtStyle()..textColor(Colors.black87),
                  ),
                  iconTheme: IconThemeData(color: Colors.black87),
                ),
                body: ListView(
                  children: [
                    ListTile(
                      title: Text("No Order"),
                      subtitle: Text(booking.bookingNoOrder),
                    ),
                    ListTile(
                      title: Text("Jumlah Anggota"),
                      subtitle: Text(booking.bookingJmlAnggota.toString()),
                    ),
                    ListTile(
                      title: Text("Tanggal Masuk"),
                      subtitle: Text(DateTimeUtil.toDateHumanize(
                          booking.bookingTglMasuk.toString())),
                    ),
                    ListTile(
                      title: Text("Tanggal Keluar"),
                      subtitle: Text(DateTimeUtil.toDateHumanize(
                          booking.bookingTglKeluar.toString())),
                    ),
                    Divider(),
                    Txt(
                      "Data Ketua",
                      style: TxtStyle()
                        ..textAlign.center()
                        ..fontSize(16.sp),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Nama"),
                      subtitle: Text(booking.bookingNama),
                    ),
                    ListTile(
                      title: Text("Alamat"),
                      subtitle: Text(booking.bookingAlamat),
                    ),
                    ListTile(
                      title: Text("No Telp"),
                      subtitle: Text(booking.bookingNoTelp),
                    ),
                    Obx(() => (homeController.userModel.value.isAdmin ||
                                DateTimeUtil.toDate(DateTime.now().toString())
                                    .isBefore(DateTimeUtil.toDate(
                                        booking.bookingTglMasuk.toString()))) &&
                            booking.bookingStatusIs("proses")
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(() => MyButtonComp(
                                isLoading: controller.isLoading.value,
                                outLine: true,
                                title: "Batalkan",
                                color: Colors.blue,
                                onTap: (controller.isLoading.value)
                                    ? () {}
                                    : () {
                                        controller.batalkanBooking(bloc);
                                      })),
                          )
                        : Container()),
                    Obx(() => homeController.userModel.value.isAdmin &&
                            (booking.bookingStatusIs("proses"))
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(() => MyButtonComp(
                                isLoading: controller.isLoading.value,
                                title: "Konfirmasi",
                                color: Colors.blue,
                                onTap: (controller.isLoading.value)
                                    ? () {}
                                    : () {
                                        controller.konfirmasiBooking(bloc);
                                      })),
                          )
                        : Container()),
                    Obx(() => homeController.userModel.value.isAdmin &&
                            (booking.bookingStatusIs("konfirmasi"))
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(() => MyButtonComp(
                                isLoading: controller.isLoading.value,
                                title: "Selesai",
                                color: Colors.blue,
                                onTap: (controller.isLoading.value)
                                    ? () {}
                                    : () {
                                        controller.selesaikanBooking(bloc);
                                      })),
                          )
                        : Container()),
                  ],
                ),
              )),
    );
  }
}
