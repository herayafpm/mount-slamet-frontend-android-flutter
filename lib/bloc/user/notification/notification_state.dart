part of 'notification_bloc.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

// ignore: must_be_immutable
class NotificationListLoaded extends NotificationState {
  List<NotificationModel> notification;
  bool hasReachMax;

  NotificationListLoaded({this.notification, this.hasReachMax});
  NotificationListLoaded copyWith(
      {List<NotificationModel> notification, bool hasReachMax}) {
    return NotificationListLoaded(
        notification: notification ?? this.notification,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }
}

class NotificationStateError extends NotificationState {
  final Map<String, dynamic> errors;

  NotificationStateError(this.errors);
}
