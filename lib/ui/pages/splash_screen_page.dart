import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/controllers/splash_screen_controller.dart';

import '../../constants.dart';

class SplashScreenPage extends StatelessWidget {
  final controller = Get.put(SplashScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Parent(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: "icon",
                    child: Image.asset(
                      "assets/images/icon.png",
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Txt(
                        "Wholesale",
                        style: TxtStyle()
                          ..textColor(Constants.textColor)
                          ..fontSize(14.sp)
                          ..fontWeight(FontWeight.bold),
                      ),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      Txt(
                        "Versi 1.0",
                        style: TxtStyle()
                          ..fontSize(14.sp)
                          ..textColor(Constants.textColor),
                      ),
                    ],
                  ),
                )
              ],
            ),
            style: ParentStyle()
              ..width(1.sw)
              ..height(1.sh)
              ..padding(vertical: 0.05.sh, horizontal: 0.05.sw)));
  }
}
