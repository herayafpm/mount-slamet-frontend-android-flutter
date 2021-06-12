import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  TextEditingController jumlahPendakiController = TextEditingController();
  TextEditingController tglAwalController = TextEditingController();
  TextEditingController tglAkhirController = TextEditingController();
  final showPass = false.obs;
  final isLoading = false.obs;
  GlobalKey<FormState> key = GlobalKey<FormState>();
}
