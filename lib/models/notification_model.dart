import 'package:mount_slamet/utils/date_time_util.dart';

class NotificationModel {
  int notificationId;
  String notificationTitle;
  String notificationBody;
  bool notificationRead;
  DateTime notificationCreated;

  NotificationModel({
    this.notificationId = 0,
    this.notificationTitle = "",
    this.notificationBody = "",
    this.notificationRead = false,
    this.notificationCreated,
  });

  factory NotificationModel.createFromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: int.parse(json['notification_id']),
      notificationTitle: json['notification_title'],
      notificationBody: json['notification_body'],
      notificationRead: json['notification_read'] == "1",
      notificationCreated: DateTimeUtil.toDate(json['notification_created']),
    );
  }
}
