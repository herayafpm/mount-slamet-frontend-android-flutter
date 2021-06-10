import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class ToastUtil {
  static void success({String message = "", int time = 1}) {
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: time,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.sp);
  }

  static void error({String message = "", int time = 1}) {
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: time,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.sp);
  }
}
