import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/bloc/auth/lupa_password/lupa_password_bloc.dart';
import 'package:mount_slamet/constants.dart';
import 'package:mount_slamet/controllers/auth/lupa_password_controller.dart';
import 'package:mount_slamet/ui/components/my_button_comp.dart';
import 'package:mount_slamet/ui/components/my_input_comp.dart';
import 'package:mount_slamet/ui/templates/auth_template.dart';
import 'package:mount_slamet/utils/toast_util.dart';

class CekKodePage extends StatelessWidget {
  final controller = Get.put(LupaPasswordController());
  @override
  Widget build(BuildContext context) {
    controller.kirimUlangTimer.value = 60;
    controller.setTimerPeriodic();
    return AuthTemplate(
      title: "Masukkan Kode OTP",
      onBack: () {
        Get.back();
      },
      body: BlocProvider(
        create: (context) => LupaPasswordBloc(),
        child: CekKodeView(),
      ),
    );
  }
}

class CekKodeView extends StatelessWidget {
  final controller = Get.find<LupaPasswordController>();
  LupaPasswordBloc bloc;
  @override
  Widget build(BuildContext context) {
    controller.cekKodeOTPkey = GlobalKey<FormState>();
    bloc = BlocProvider.of<LupaPasswordBloc>(context);
    return BlocListener<LupaPasswordBloc, LupaPasswordState>(
      listener: (context, state) {
        if (state is LupaPasswordStateLoading) {
          controller.isLoading.value = true;
        } else {
          controller.isLoading.value = false;
          if (state is LupaPasswordCekTokenSuccess) {
            Get.toNamed("/auth/forget_password/change_password");
          } else if (state is LupaPasswordStateSuccess) {
            controller.kirimUlangTimer.value = 60;
            ToastUtil.success(message: state.data['message'] ?? '');
          } else if (state is LupaPasswordStateError) {
            ToastUtil.error(
                message: state.errors['data']['kode_otp'] ??
                    state.errors['message'] ??
                    '');
          }
        }
      },
      child: Form(
        key: controller.cekKodeOTPkey,
        child: Column(
          children: [
            MyInputComp(
              type: TextInputType.number,
              controller: controller.kodeOTPController,
              title: "Kode OTP",
              validator: (String value) {
                if (value.isEmpty) {
                  return "kode tidak boleh kosong";
                }
                if (value.length != 6) {
                  return "kode harus sama dengan 6 karakter";
                }
                return null;
              },
            ),
            SizedBox(
              height: 0.04.sh,
            ),
            Obx(() => MyButtonComp(
                  isLoading: controller.isLoading.value,
                  title: "Kirim",
                  color: Colors.blue,
                  onTap: (controller.isLoading.value)
                      ? () {}
                      : () {
                          if (controller.cekKodeOTPkey.currentState
                              .validate()) {
                            controller.cekKode(bloc);
                          }
                        },
                )),
            SizedBox(
              height: 0.02.sh,
            ),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Parent(
                      child: Txt(
                          (controller.kirimUlangTimer.value > 0)
                              ? "Belum menerima email? kirim ulang ${controller.kirimUlangTimer.value}s"
                              : "Belum menerima email? ",
                          style: TxtStyle()
                            ..textColor(Constants.textColor)
                            ..fontSize(15.sp)
                            ..textAlign.center()),
                    ),
                    (controller.kirimUlangTimer.value <= 0)
                        ? Parent(
                            gesture: Gestures()
                              ..onTap(() {
                                if (controller.kirimUlangTimer.value <= 0) {
                                  controller.lupa(bloc);
                                }
                              }),
                            child: Txt("Kirim Ulang",
                                style: TxtStyle()
                                  ..textColor(Colors.blueAccent)
                                  ..fontSize(15.sp)),
                          )
                        : Container(),
                  ],
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
