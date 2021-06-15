import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/bloc/user/profile/profile_bloc.dart';
import 'package:mount_slamet/controllers/home_controller.dart';
import 'package:mount_slamet/controllers/user_controller.dart';
import 'package:mount_slamet/ui/components/my_button_comp.dart';
import 'package:mount_slamet/ui/components/my_input_comp.dart';
import 'package:mount_slamet/ui/templates/auth_template.dart';
import 'package:mount_slamet/utils/toast_util.dart';

class UbahPasswordPage extends StatelessWidget {
  final controller = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      title: "Ubah Password",
      onBack: () {
        Get.back();
      },
      body: BlocProvider(
        create: (context) => ProfileBloc(),
        child: UbahPasswordView(),
      ),
    );
  }
}

class UbahPasswordView extends StatelessWidget {
  final controller = Get.find<UserController>();
  final homeController = Get.find<HomeController>();
  ProfileBloc bloc;
  @override
  Widget build(BuildContext context) {
    controller.key = GlobalKey<FormState>();
    bloc = BlocProvider.of<ProfileBloc>(context);
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileStateLoading) {
          controller.isLoading.value = true;
        } else {
          controller.isLoading.value = false;
          if (state is ProfileStateSuccess) {
            ToastUtil.success(message: state.data['message'] ?? '');
            Get.back();
          } else if (state is ProfileStateError) {
            ToastUtil.error(message: state.errors['message'] ?? '');
          }
        }
      },
      child: Form(
        key: controller.key,
        child: Column(
          children: [
            Obx(() => MyInputComp(
                  prefixIcon: Icon(Icons.lock),
                  obsecure: !controller.showPass.value,
                  controller: controller.passwordController,
                  title: "Password",
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "password baru tidak boleh kosong";
                    }
                    if (value.length < 6) {
                      return "password baru min 6 karakter";
                    }
                    return null;
                  },
                  icon: Parent(
                      gesture: Gestures()
                        ..onTap(() {
                          controller.showPass.value =
                              !controller.showPass.value;
                        }),
                      child: (!controller.showPass.value)
                          ? Icon(
                              Icons.visibility,
                            )
                          : Icon(
                              Icons.visibility_off,
                            )),
                )),
            SizedBox(
              height: 20,
            ),
            Obx(() => MyInputComp(
                  prefixIcon: Icon(Icons.lock),
                  obsecure: !controller.showPass.value,
                  controller: controller.password2Controller,
                  title: "Confirm Password",
                  validator: (value) {
                    if (value.isEmpty) {
                      return "konfirmasi password baru tidak boleh kosong";
                    }
                    if (value.length < 6) {
                      return "konfirmasi password baru min 6 karakter";
                    }
                    if (value != controller.passwordController.text) {
                      return "konfirmasi password baru harus sama dengan Password Baru";
                    }
                    return null;
                  },
                  icon: Parent(
                      gesture: Gestures()
                        ..onTap(() {
                          controller.showPass.value =
                              !controller.showPass.value;
                        }),
                      child: (!controller.showPass.value)
                          ? Icon(
                              Icons.visibility,
                            )
                          : Icon(
                              Icons.visibility_off,
                            )),
                )),
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
                            controller.ubahPassword(bloc);
                          }
                        },
                )),
          ],
        ),
      ),
    );
  }
}
