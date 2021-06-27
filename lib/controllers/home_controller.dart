import 'package:flutter/foundation.dart';
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
    updateUser();
    updateFCM();
    super.onInit();
  }

  void updateFCM() async {
    try {
      OSDeviceState device = await OneSignal.shared.getDeviceState();
      String onesignalUserId = device.userId;
      await ProfileRepository.updateFCM(onesignalUserId);
    } catch (e) {}
  }

  void updateUser() async {
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
    addLicenses();
    showAboutDialog(
        context: Get.context,
        applicationName: "Mount Slamet",
        applicationVersion: "1.0",
        children: [Text("Terima kasih telah menggunakan aplikasi ini")],
        applicationIcon: SizedBox(
          width: Get.height / 20,
          child: Image.asset(
            "assets/images/logo.png",
            fit: BoxFit.contain,
          ),
        ));
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

  void logout() async {
    Get.offAllNamed("/auth/login");
    try {
      var boxUser = await Hive.openBox("user_model");
      boxUser.deleteAt(0);
    } catch (e) {
      print("data $e");
    }
  }

  // Actually add the licenses
  Stream<LicenseEntry> licenses() async* {
    yield FlutterLicense([
      'Night landscape background Free Vector'
    ], [
      LicenseParagraph(
          'Designed by kjpargeter / Freepik' +
              '\n\nhttps://www.freepik.com/free-vector/night-landscape-background_3021359.htm',
          0)
    ]);

    //Add the following line to add more licenses in the future
    //yield FlutterLicense([''],[LicenseParagraph('',0)]);
  }

  void addLicenses() {
    LicenseRegistry.addLicense(licenses);
  }
}

class FlutterLicense extends LicenseEntry {
  final packages;
  final paragraphs;

  FlutterLicense(this.packages, this.paragraphs);
}
