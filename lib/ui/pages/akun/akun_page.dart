import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/controllers/home_controller.dart';

import '../../../constants.dart';

class AkunPage extends StatelessWidget {
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(Constants.screenWidth, Constants.screenHeight),
        builder: () => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.blue,
                title: Txt(
                  "Akun",
                  style: TxtStyle()..textColor(Colors.white),
                ),
                iconTheme: IconThemeData(color: Colors.white),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Parent(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.user,
                            size: 60.sp,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Obx(() => Txt(
                                homeController
                                    .userModel.value.userNama.capitalizeFirst,
                                style: TxtStyle()
                                  ..textColor(Colors.white70)
                                  ..bold()
                                  ..fontSize(20.sp),
                              )),
                          Obx(() => (homeController.userModel.value.isAdmin)
                              ? Txt(
                                  homeController
                                      .userModel.value.role.capitalizeFirst,
                                  style: TxtStyle()
                                    ..textColor(Colors.white70)
                                    ..bold()
                                    ..fontSize(15.sp),
                                )
                              : Container())
                        ],
                      ),
                      style: ParentStyle()
                        ..background.color(Colors.blue)
                        ..width(1.sw)
                        ..padding(vertical: 20, horizontal: 20),
                    ),
                    ListTile(
                      title: Txt("Ubah Profile"),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        Get.toNamed("/home/akun/ubah_profile");
                      },
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      title: Txt("Ubah Password"),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        Get.toNamed("/home/akun/ubah_password");
                      },
                    ),
                    Divider(
                      height: 1,
                    ),
                  ],
                ),
              ),
            ));
  }
}
