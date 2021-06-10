import 'dart:async';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mount_slamet/models/user_model.dart';

class SplashScreenController extends GetxController {
  final obj = ''.obs;
  @override
  void onInit() async {
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
        }
      } catch (e) {
        Get.offAllNamed("/auth/login");
      }
    });
  }
}
