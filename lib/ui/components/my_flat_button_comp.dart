import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';

class MyFlatButtonComp extends StatelessWidget {
  final String title;
  final Function onTap;
  final Color color;

  const MyFlatButtonComp({this.title, this.onTap, this.color});
  @override
  Widget build(BuildContext context) {
    Color color = this.color ?? Constants.textColor;
    return Parent(
      gesture: Gestures()..onTap(onTap),
      child: Txt("$title",
          style: TxtStyle()
            ..textColor(color)
            ..fontSize(15.sp)
            ..textAlign.center()),
      style: ParentStyle()..width(0.8.sw),
    );
  }
}
