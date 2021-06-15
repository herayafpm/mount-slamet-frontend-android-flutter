import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/bloc/user/notification/notification_bloc.dart';
import 'package:mount_slamet/controllers/notification_controller.dart';
import 'package:mount_slamet/models/notification_model.dart';
import 'package:mount_slamet/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../constants.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NotificationBloc()..add(NotificationGetListEvent(refresh: true)),
      child: NotificationView(),
    );
  }
}

class NotificationView extends StatelessWidget {
  final controller = Get.put(NotificationController());
  NotificationBloc bloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(NotificationGetListEvent(refresh: true));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(NotificationGetListEvent());
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<NotificationBloc>(context);
    return ScreenUtilInit(
        designSize: Size(Constants.screenWidth, Constants.screenHeight),
        builder: () => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Txt(
                  "Notifikasi",
                  style: TxtStyle()..textColor(Colors.black87),
                ),
                iconTheme: IconThemeData(color: Colors.black87),
              ),
              body: BlocConsumer<NotificationBloc, NotificationState>(
                  listener: (context, state) {
                if (state is NotificationStateError) {
                  ToastUtil.error(message: state.errors['message'] ?? "");
                }
              }, builder: (context, state) {
                if (state is NotificationListLoaded) {
                  NotificationListLoaded stateData = state;
                  if (stateData.notification != null &&
                      stateData.notification.length > 0) {
                    return Column(
                      children: [
                        Container(
                          height: 50,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              child: Txt(
                                "Baca Semua",
                                style: TxtStyle()
                                  ..textColor(Constants.textColor),
                              ),
                              onPressed: () {
                                bloc..add(NotificationBacaSemuaEvent());
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: SmartRefresher(
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
                              itemCount: stateData.notification.length,
                              itemBuilder: (BuildContext context, int index) {
                                NotificationModel notif =
                                    stateData.notification[index];
                                return ListTile(
                                  leading: Icon(Icons.notifications),
                                  title: Text(
                                    "${notif.notificationTitle}",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    "${notif.notificationBody}",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  tileColor: (notif.notificationRead)
                                      ? Colors.transparent
                                      : Colors.grey[100],
                                  onTap: () {
                                    bloc
                                      ..add(NotificationBacaEvent(
                                          notif.notificationId));
                                    controller.detailNotif(
                                        notif.notificationTitle,
                                        notif.notificationBody);
                                  },
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    );
                  }
                  return emptyState();
                } else if (state is NotificationInitial) {
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
          bloc..add(NotificationGetListEvent(refresh: true));
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
          bloc..add(NotificationGetListEvent(refresh: true));
        }),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.refresh),
          Text(
            "Belum ada notifikasi",
          ),
        ],
      ),
    );
  }
}
