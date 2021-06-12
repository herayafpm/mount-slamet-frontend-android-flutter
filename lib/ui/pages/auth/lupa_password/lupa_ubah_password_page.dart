import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/bloc/auth/lupa_password/lupa_password_bloc.dart';
import 'package:mount_slamet/controllers/auth/lupa_password_controller.dart';
import 'package:mount_slamet/ui/components/my_button_comp.dart';
import 'package:mount_slamet/ui/components/my_input_comp.dart';
import 'package:mount_slamet/ui/templates/auth_template.dart';
import 'package:mount_slamet/utils/toast_util.dart';

import '../../../../constants.dart';

class LupaUbahPasswordPage extends StatelessWidget {
  final controller = Get.put(LupaPasswordController());
  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      onBack: () {
        Get.back();
      },
      title: "Change Password",
      body: BlocProvider(
        create: (context) => LupaPasswordBloc(),
        child: LupaUbahPasswordView(),
      ),
    );
  }
}

class LupaUbahPasswordView extends StatelessWidget {
  final controller = Get.find<LupaPasswordController>();
  LupaPasswordBloc bloc;
  @override
  Widget build(BuildContext context) {
    controller.ubahPasswordkey = GlobalKey<FormState>();
    bloc = BlocProvider.of<LupaPasswordBloc>(context);
    return BlocListener<LupaPasswordBloc, LupaPasswordState>(
      listener: (context, state) {
        if (state is LupaPasswordStateLoading) {
          controller.isLoading.value = true;
        } else {
          controller.isLoading.value = false;
          if (state is LupaPasswordStateSuccess) {
            Get.offAllNamed("/auth/login");
            controller.emailController.text = "";
            controller.passwordController.text = "";
            controller.password2Controller.text = "";
            controller.kodeOTPController.text = "";
            ToastUtil.success(message: state.data['message'] ?? '');
          } else if (state is LupaPasswordStateError) {
            ToastUtil.error(
                message: state.errors['data']['user_password'] ??
                    state.errors['data']['kode_otp'] ??
                    state.errors['message'] ??
                    '');
          }
        }
      },
      child: Form(
        key: controller.ubahPasswordkey,
        child: Column(
          children: [
            Obx(() => MyInputComp(
                  prefixIcon: Icon(Icons.lock),
                  obsecure: !controller.showPass.value,
                  controller: controller.passwordController,
                  title: "Password",
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "password tidak boleh kosong";
                    }
                    if (value.length < 6) {
                      return "password min 6 karakter";
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
              height: 0.04.sh,
            ),
            Obx(() => MyInputComp(
                  prefixIcon: Icon(Icons.lock),
                  obsecure: !controller.showPass.value,
                  controller: controller.password2Controller,
                  title: "Confirm Password",
                  validator: (value) {
                    if (value.isEmpty) {
                      return "konfirmasi password tidak boleh kosong";
                    }
                    if (value.length < 6) {
                      return "konfirmasi password min 6 karakter";
                    }
                    if (value != controller.passwordController.text) {
                      return "konfirmasi password harus sama dengan Password";
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
              height: 0.04.sh,
            ),
            Obx(() => MyButtonComp(
                  isLoading: controller.isLoading.value,
                  title: "Change",
                  color: Colors.blue,
                  onTap: (controller.isLoading.value)
                      ? () {}
                      : () {
                          if (controller.ubahPasswordkey.currentState
                              .validate()) {
                            controller.ubahPassword(bloc);
                          }
                        },
                )),
            SizedBox(
              height: 0.02.sh,
            ),
            Parent(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Parent(
                    child: Txt("Remember?",
                        style: TxtStyle()
                          ..textColor(Constants.textColor)
                          ..fontSize(15.sp)
                          ..textAlign.center()),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Parent(
                    gesture: Gestures()
                      ..onTap(() {
                        Get.offAllNamed("/auth/login");
                      }),
                    child: Txt("Login",
                        style: TxtStyle()
                          ..textColor(Colors.blueAccent)
                          ..fontSize(15.sp)
                          ..textAlign.center()),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
