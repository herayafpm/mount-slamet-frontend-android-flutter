import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyButtonComp extends StatelessWidget {
  final String title;
  final Function onTap;
  final bool isLoading;
  final Color color;

  MyButtonComp(
      {this.title,
      this.onTap,
      this.isLoading = false,
      this.color = const Color(0xFF3EA8C2)});
  @override
  Widget build(BuildContext context) {
    return Parent(
      gesture: Gestures()..onTap(onTap),
      child: Center(
          child: (isLoading)
              ? CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )
              : Txt("$title",
                  style: TxtStyle()
                    ..textColor(Colors.white)
                    ..fontSize(15.sp)
                    ..bold())),
      style: ParentStyle()
        ..width(Get.width * 0.9)
        ..height(Get.height * 0.06)
        ..background.color((isLoading) ? color.withOpacity(0.5) : color)
        ..elevation((isLoading) ? 0 : 1)
        ..padding(horizontal: 20, vertical: 10)
        ..borderRadius(all: 5)
        ..ripple(true, splashColor: Colors.white),
    );
  }
}
