part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class NotificationGetListEvent extends NotificationEvent {
  final bool refresh;

  NotificationGetListEvent({this.refresh = false});
}

class NotificationBacaEvent extends NotificationEvent {
  final int id;

  NotificationBacaEvent(this.id);
}

class NotificationBacaSemuaEvent extends NotificationEvent {}
