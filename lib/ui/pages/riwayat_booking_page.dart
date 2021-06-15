import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/bloc/booking/booking_bloc.dart';
import 'package:mount_slamet/models/booking_model.dart';
import 'package:mount_slamet/utils/date_time_util.dart';
import 'package:mount_slamet/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../constants.dart';

class RiwayatBookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BookingBloc()..add(BookingGetListEvent(refresh: true)),
      child: RiwayatBookingView(),
    );
  }
}

class RiwayatBookingView extends StatelessWidget {
  BookingBloc bloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(BookingGetListEvent(refresh: true));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(BookingGetListEvent());
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<BookingBloc>(context);
    return ScreenUtilInit(
        designSize: Size(Constants.screenWidth, Constants.screenHeight),
        builder: () => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Txt(
                  "Riwayat Booking",
                  style: TxtStyle()..textColor(Colors.black87),
                ),
                iconTheme: IconThemeData(color: Colors.black87),
              ),
              body: BlocConsumer<BookingBloc, BookingState>(
                  listener: (context, state) {
                if (state is BookingStateError) {
                  ToastUtil.error(message: state.errors['message'] ?? "");
                }
              }, builder: (context, state) {
                if (state is BookingListLoaded) {
                  BookingListLoaded stateData = state;
                  if (stateData.booking != null &&
                      stateData.booking.length > 0) {
                    return SmartRefresher(
                      controller: _refreshController,
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
                          Icon leading;
                          if (booking.bookingStatusIs("proses")) {
                            leading = Icon(
                              Icons.watch_later_outlined,
                              color: Colors.blueAccent,
                            );
                          } else if (booking.bookingStatusIs("konfirmasi")) {
                            leading = Icon(
                              Icons.check,
                              color: Colors.greenAccent,
                            );
                          } else if (booking.bookingStatusIs("dibatalkan")) {
                            leading = Icon(
                              Icons.highlight_remove_outlined,
                              color: Colors.redAccent,
                            );
                          }
                          return ListTile(
                            leading: leading,
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
            ));
  }

  Widget loadingState() {
    return Parent(
      style: ParentStyle()
        ..ripple(true, splashColor: Colors.blueAccent)
        ..width(1.sw),
      gesture: Gestures()
        ..onTap(() {
          bloc..add(BookingGetListEvent(refresh: true));
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
          bloc..add(BookingGetListEvent(refresh: true));
        }),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.refresh),
          Text(
            "Belum booking",
          ),
        ],
      ),
    );
  }
}
