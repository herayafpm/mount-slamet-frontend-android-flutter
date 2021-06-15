import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final _obj = ''.obs;
  void detailNotif(String title, String body) {
    showDialog(
        context: Get.context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
              title: Text("$title"),
              content: Text("$body"),
            ));
  }
}
