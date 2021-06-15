import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mount_slamet/bloc/auth/lupa_password/lupa_password_bloc.dart';
import 'package:mount_slamet/bloc/user/profile/profile_bloc.dart';
import 'package:mount_slamet/models/user_model.dart';

class UserController extends GetxController {
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
  TextEditingController noTelpOtController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  final isLoading = false.obs;
  final showPass = false.obs;

  @override
  void onInit() {
    updateUser();
    super.onInit();
  }

  void updateUser() async {
    try {
      var boxUser = await Hive.openBox("user_model");
      UserModel user = boxUser.getAt(0);
      if (user != null) {
        namaController.text = user.userNama;
        alamatController.text = user.userAlamat;
        noTelpController.text = user.userNoTelp;
        noTelpOtController.text = user.userNoTelpOt;
      }
    } catch (e) {
      Get.offAllNamed("/auth/login");
    }
  }

  void ubahProfile(ProfileBloc bloc) {
    isLoading.value = !isLoading.value;
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_nama'] = namaController.text;
    data['user_alamat'] = alamatController.text;
    data['user_no_telp'] = noTelpController.text;
    data['user_no_telp_ot'] = noTelpOtController.text;
    bloc..add(ProfileUbahEvent(data));
  }

  void ubahPassword(ProfileBloc bloc) {
    isLoading.value = !isLoading.value;
    bloc..add(ProfileUbahPasswordEvent(passwordController.text));
  }

  void ubahProfileClear() {
    namaController.text = "";
    alamatController.text = "";
    noTelpController.text = "";
    noTelpOtController.text = "";
  }
}
