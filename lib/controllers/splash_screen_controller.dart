import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mount_slamet/models/user_model.dart';
import 'package:mount_slamet/utils/toast_util.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreenController extends GetxController {
  final obj = ''.obs;
  @override
  void onInit() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    splash();
    super.onInit();
  }

  Future splash() async {
    return Timer(Duration(seconds: 2), () async {
      try {
        var boxUser = await Hive.openBox("user_model");
        UserModel user = boxUser.getAt(0);
        if (user != null) {
          Get.offAllNamed("/home");
          if (!user.isAdmin &&
              (user.userAlamat.isEmpty ||
                  user.userNoTelp.isEmpty ||
                  user.userNoTelpOt.isEmpty)) {
            Get.offNamedUntil(
                "/home/akun/ubah_profile", ModalRoute.withName('/home'));
            ToastUtil.success(message: "Harap Lengkapi data diri");
          }
        }
      } catch (e) {
        Get.offAllNamed("/auth/login");
      }
    });
  }
}
