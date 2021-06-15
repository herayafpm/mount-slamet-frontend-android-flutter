import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mount_slamet/bloc/auth/lupa_password/lupa_password_bloc.dart';
import 'package:mount_slamet/bloc/user/profile/profile_bloc.dart';
import 'package:mount_slamet/constants.dart';
import 'package:mount_slamet/controllers/home_controller.dart';
import 'package:mount_slamet/controllers/user_controller.dart';
import 'package:mount_slamet/models/user_model.dart';
import 'package:mount_slamet/ui/components/my_button_comp.dart';
import 'package:mount_slamet/ui/components/my_input_comp.dart';
import 'package:mount_slamet/ui/components/my_input_multi_line_comp.dart';
import 'package:mount_slamet/ui/templates/auth_template.dart';
import 'package:mount_slamet/utils/toast_util.dart';

class UbahProfilePage extends StatelessWidget {
  final controller = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      title: "Ubah Profile",
      onBack: () {
        Get.back();
      },
      body: BlocProvider(
        create: (context) => ProfileBloc(),
        child: UbahProfileView(),
      ),
    );
  }
}

class UbahProfileView extends StatelessWidget {
  final controller = Get.find<UserController>();
  final homeController = Get.find<HomeController>();
  ProfileBloc bloc;
  @override
  Widget build(BuildContext context) {
    controller.key = GlobalKey<FormState>();
    bloc = BlocProvider.of<ProfileBloc>(context);
    controller.namaController.text = homeController.userModel.value.userNama;
    controller.alamatController.text =
        homeController.userModel.value.userAlamat;
    controller.noTelpController.text =
        homeController.userModel.value.userNoTelp;
    controller.noTelpOtController.text =
        homeController.userModel.value.userNoTelpOt;
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileStateLoading) {
          controller.isLoading.value = true;
        } else {
          controller.isLoading.value = false;
          if (state is ProfileStateSuccess) {
            print("data user" + state.data['data'].toString());
            var boxUser = await Hive.openBox("user_model");
            UserModel userModel = homeController.userModel.value;
            userModel.userNama = state.data['data']['user_nama'];
            userModel.userAlamat = state.data['data']['user_alamat'];
            userModel.userNoTelp = state.data['data']['user_no_telp'];
            userModel.userNoTelpOt = state.data['data']['user_no_telp_ot'];
            try {
              boxUser.putAt(0, userModel);
            } catch (e) {}
            homeController.updateUser();
            controller.ubahProfileClear();
            ToastUtil.success(message: state.data['message'] ?? '');
            Get.back();
          } else if (state is ProfileStateError) {
            ToastUtil.error(
                message: state.errors['data']['user_nama'] ??
                    state.errors['data']['user_alamat'] ??
                    state.errors['data']['user_no_telp'] ??
                    state.errors['data']['user_no_telp_ot'] ??
                    state.errors['message'] ??
                    '');
          }
        }
      },
      child: Form(
        key: controller.key,
        child: Column(
          children: [
            MyInputComp(
              controller: controller.namaController,
              title: "Nama Lengkap",
              validator: (String value) {
                if (value.isEmpty) {
                  return "kode tidak boleh kosong";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            MyInputMultiLineComp(
              controller: controller.alamatController,
              title: "Alamat (Sesuai KTP)",
              validator: (String value) {
                if (value.isEmpty) {
                  return "alamat tidak boleh kosong";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            MyInputComp(
              type: TextInputType.phone,
              controller: controller.noTelpController,
              title: "No Telp",
              validator: (String value) {
                if (value.isEmpty) {
                  return "no telp tidak boleh kosong";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            MyInputComp(
              type: TextInputType.phone,
              controller: controller.noTelpOtController,
              title: "No Telp Orang Tua",
              validator: (String value) {
                if (value.isEmpty) {
                  return "no telp orang tua tidak boleh kosong";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Obx(() => MyButtonComp(
                  isLoading: controller.isLoading.value,
                  title: "Ubah",
                  color: Colors.blue,
                  onTap: (controller.isLoading.value)
                      ? () {}
                      : () {
                          if (controller.key.currentState.validate()) {
                            controller.ubahProfile(bloc);
                          }
                        },
                )),
          ],
        ),
      ),
    );
  }
}
