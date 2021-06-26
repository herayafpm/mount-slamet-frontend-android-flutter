import 'dart:developer';

import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/bloc/booking/booking_bloc.dart';
import 'package:mount_slamet/controllers/admin_booking_controller.dart';
import 'package:mount_slamet/models/booking_model.dart';
import 'package:mount_slamet/utils/date_time_util.dart';
import 'package:mount_slamet/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../constants.dart';

class RiwayatAdminBookingPage extends StatelessWidget {
  final controller = Get.put(AdminBookingController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: Status.values.length,
      child: ScreenUtilInit(
          designSize: Size(Constants.screenWidth, Constants.screenHeight),
          builder: () => Scaffold(
                appBar: AppBar(
                  title: Txt(
                    "Data Booking",
                    style: TxtStyle()..textColor(Colors.black87),
                  ),
                  iconTheme: IconThemeData(color: Colors.black87),
                  bottom: TabBar(
                    tabs: Status.values
                        .map((e) => Tab(
                              child: Txt(e.toString().split(".")[1],
                                  style: TxtStyle()..textColor(Colors.black87)),
                            ))
                        .toList(),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: controller.search,
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.calendar_today),
                      onSelected: controller.updateDataDate,
                      itemBuilder: (BuildContext context) {
                        return {'Hari Ini', 'Bulan Ini', 'Tahun Ini', 'Custom'}
                            .map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ],
                ),
                body: TabBarView(
                  children: Status.values
                      .map((e) => RiwayatBookingView(
                            tabIndex: e.index,
                          ))
                      .toList(),
                ),
              )),
    );
  }
}

class RiwayatBookingView extends StatelessWidget {
  final int tabIndex;
  final controller = Get.find<AdminBookingController>();
  RiwayatBookingView({this.tabIndex});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingBloc()
        ..add(BookingAdminGetListEvent(
            refresh: true,
            isAdmin: true,
            status: tabIndex,
            bookingTglMasuk: DateTimeUtil.onlyDate(controller.tglMasuk.value),
            bookingTglKeluar: DateTimeUtil.onlyDate(controller.tglKeluar.value),
            cari: controller.cari.value)),
      child: RiwayatAdminBookingTab(tabIndex: tabIndex),
    );
  }
}

class RiwayatAdminBookingTab extends StatelessWidget {
  final controller = Get.find<AdminBookingController>();
  final int tabIndex;
  RiwayatAdminBookingTab({this.tabIndex});
  BookingBloc bloc;
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc
      ..add(BookingAdminGetListEvent(
          refresh: true,
          isAdmin: true,
          status: tabIndex,
          bookingTglMasuk: DateTimeUtil.onlyDate(controller.tglMasuk.value),
          bookingTglKeluar: DateTimeUtil.onlyDate(controller.tglKeluar.value),
          cari: controller.cari.value));
    controller.refreshController.value.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    bloc
      ..add(BookingAdminGetListEvent(
          isAdmin: true,
          status: tabIndex,
          bookingTglMasuk: DateTimeUtil.onlyDate(controller.tglMasuk.value),
          bookingTglKeluar: DateTimeUtil.onlyDate(controller.tglKeluar.value),
          cari: controller.cari.value));
    controller.refreshController.value.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    controller.refreshController.value =
        RefreshController(initialRefresh: false);
    bloc = BlocProvider.of<BookingBloc>(context);
    controller.bookingBloc.value = bloc;
    return Parent(
      style: ParentStyle()
        ..width(1.sw)
        ..height(1.sh),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: Obx(() => Txt(controller.title.value
                        .toLowerCase()
                        .replaceAll(" ", "_") !=
                    "custom"
                ? controller.title.value
                : "Tanggal : " +
                    (DateTimeUtil.onlyDate(controller.tglMasuk.value) +
                        (controller.tglMasuk.value
                                    .compareTo(controller.tglKeluar.value) ==
                                0
                            ? ""
                            : " Sampai " +
                                (DateTimeUtil.onlyDate(
                                    controller.tglKeluar.value)))))),
          ),
          Divider(),
          Flexible(
            flex: 1,
            child: BlocConsumer<BookingBloc, BookingState>(
                listener: (context, state) {
              if (state is BookingStateError) {
                ToastUtil.error(message: state.errors['message'] ?? "");
              }
            }, builder: (context, state) {
              if (state is BookingListLoaded) {
                BookingListLoaded stateData = state;
                if (stateData.booking != null && stateData.booking.length > 0) {
                  return SmartRefresher(
                    controller: controller.refreshController.value,
                    enablePullDown: true,
                    enablePullUp: true,
                    header: WaterDropMaterialHeader(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 0, top: 0),
                      itemCount: stateData.booking.length,
                      itemBuilder: (BuildContext context, int index) {
                        BookingModel booking = stateData.booking[index];
                        return ListTile(
                          title: Text(
                            "${booking.bookingNoOrder}",
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            "${DateTimeUtil.toDateHumanize(booking.bookingTglMasuk.toString())} - ${DateTimeUtil.toDateHumanize(booking.bookingTglKeluar.toString())}",
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Get.toNamed("/home/booking/riwayat/detail",
                                arguments: booking);
                          },
                        );
                      },
                    ),
                  );
                }
                return emptyState();
              } else if (state is BookingStateLoading ||
                  state is BookingInitial) {
                return loadingState();
              }
              return emptyState();
            }),
          ),
        ],
      ),
    );
  }

  Widget loadingState() {
    return Parent(
      style: ParentStyle()
        ..ripple(true, splashColor: Colors.blueAccent)
        ..width(1.sw),
      gesture: Gestures()
        ..onTap(() {
          controller.cari.value = "";
          controller.tglMasuk.value = DateTime.now();
          controller.tglKeluar.value = DateTime.now();
          controller.title.value = "Hari Ini";
          bloc
            ..add(BookingAdminGetListEvent(
                refresh: true,
                isAdmin: true,
                status: tabIndex,
                bookingTglMasuk:
                    DateTimeUtil.onlyDate(controller.tglMasuk.value),
                bookingTglKeluar:
                    DateTimeUtil.onlyDate(controller.tglKeluar.value),
                cari: controller.cari.value));
        }),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text(
            "Mengambil Data",
          ),
        ],
      ),
    );
  }

  Widget emptyState() {
    return Parent(
      style: ParentStyle()
        ..ripple(true, splashColor: Colors.blueAccent)
        ..width(1.sw),
      gesture: Gestures()
        ..onTap(() {
          controller.cari.value = "";
          controller.tglMasuk.value = DateTime.now();
          controller.tglKeluar.value = DateTime.now();
          controller.title.value = "Hari Ini";
          bloc
            ..add(BookingAdminGetListEvent(
                refresh: true,
                isAdmin: true,
                status: tabIndex,
                bookingTglMasuk:
                    DateTimeUtil.onlyDate(controller.tglMasuk.value),
                bookingTglKeluar:
                    DateTimeUtil.onlyDate(controller.tglKeluar.value),
                cari: controller.cari.value));
        }),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.refresh),
          Text(
            "Belum Ada yang booking",
          ),
        ],
      ),
    );
  }
}
