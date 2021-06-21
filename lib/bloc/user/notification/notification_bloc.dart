import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mount_slamet/models/notification_model.dart';
import 'package:mount_slamet/repositories/user/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial());

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is NotificationGetListEvent) {
      List<NotificationModel> notification = [];
      if (state is NotificationInitial || event.refresh) {
        Map<String, dynamic> res =
            await NotificationRepository.notifAll(limit: 10, offset: 0);
        if (res['statusCode'] == 200 && res['data']['status'] == true) {
          var jsonObject = res['data']['data'] as List;
          notification = jsonObject
              .map<NotificationModel>(
                  (e) => NotificationModel.createFromJson(e))
              .toList();
          yield NotificationListLoaded(
              notification: notification, hasReachMax: false);
        } else if (res['statusCode'] == 400) {
          yield NotificationStateError(res['data']);
        } else {
          yield NotificationStateError(res['data']);
        }
      } else if (state is NotificationListLoaded) {
        NotificationListLoaded notificationListLoaded =
            state as NotificationListLoaded;
        Map<String, dynamic> res = await NotificationRepository.notifAll(
            limit: 10, offset: notificationListLoaded.notification.length);
        if (res['statusCode'] == 200 && res['data']['status'] == true) {
          var jsonObject = res['data']['data'] as List;
          if (jsonObject.length == 0) {
            yield notificationListLoaded.copyWith(hasReachMax: true);
          } else {
            notification = jsonObject
                .map<NotificationModel>(
                    (e) => NotificationModel.createFromJson(e))
                .toList();
            yield NotificationListLoaded(
                notification:
                    notificationListLoaded.notification + notification,
                hasReachMax: false);
          }
        } else if (res['statusCode'] == 400) {
          yield NotificationStateError(res['data']);
        } else {
          yield NotificationStateError(res['data']);
        }
      }
    } else if (event is NotificationBacaSemuaEvent) {
      Map<String, dynamic> res = await NotificationRepository.notifReadAll();
      if (res['statusCode'] == 200 && res['data']['status'] == true) {
        this..add(NotificationGetListEvent(refresh: true));
      } else if (res['statusCode'] == 400) {
        yield NotificationStateError(res['data']);
      } else {
        yield NotificationStateError(res['data']);
      }
    } else if (event is NotificationBacaEvent) {
      Map<String, dynamic> res =
          await NotificationRepository.notifRead(event.id);
      if (res['statusCode'] == 200 && res['data']['status'] == true) {
        this..add(NotificationGetListEvent(refresh: true));
      } else if (res['statusCode'] == 400) {
        yield NotificationStateError(res['data']);
      } else {
        yield NotificationStateError(res['data']);
      }
    }
  }
}
