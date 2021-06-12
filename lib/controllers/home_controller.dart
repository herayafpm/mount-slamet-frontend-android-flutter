import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mount_slamet/constants.dart';
import 'package:mount_slamet/models/user_model.dart';
import 'package:mount_slamet/repositories/user/profile_repository.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeController extends GetxController {
  final userModel = UserModel().obs;
  var jumlahBooking = 0.obs;
  var sisaSeat = 0.obs;
  var jumlahPendaki = 50.obs;
  var isLoading = false.obs;

  @override
  void onInit() async {
    try {
      var boxUser = await Hive.openBox("user_model");
      UserModel user = boxUser.getAt(0);
      if (user != null) {
        userModel.value = user;
      }
      print("data user " + userModel.value.userNama);
    } catch (e) {
      Get.offAllNamed("/auth/login");
    }
    try {
      OSDeviceState device = await OneSignal.shared.getDeviceState();
      String onesignalUserId = device.userId;
      await ProfileRepository.updateFCM(onesignalUserId);
    } catch (e) {}
    super.onInit();
  }

  Widget tileDefault(
      {String title = "", Function onTap, Icon icon, Color color}) {
    return ListTile(
      title: Text("$title",
          style:
              TextStyle(fontSize: 14.sp, color: color ?? Constants.textColor)),
      tileColor: Colors.white,
      leading: icon ?? Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  void about() {
    showAboutDialog(
      context: Get.context,
      applicationName: "Mount Slamet",
      applicationVersion: "1.0",
      children: [Text("Terima kasih telah menggunakan aplikasi ini")],
    );
  }

  void confirmLogout() {
    showDialog(
        context: Get.context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                  child: Text("Tidak"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Ya"),
                  onPressed: () {
                    logout();
                  },
                )
              ],
              title: Text("Konfirmasi"),
              content: Text("Yakin ingin mengakhiri sesi?"),
            ));
  }

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

  void logout() async {
    Get.offAllNamed("/auth/login");
    try {
      var boxUser = await Hive.openBox("user_model");
      boxUser.deleteAt(0);
    } catch (e) {
      print("data $e");
    }
  }
}
