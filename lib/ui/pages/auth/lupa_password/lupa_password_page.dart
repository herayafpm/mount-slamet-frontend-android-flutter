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

class LupaPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      title: "Forget Password",
      body: BlocProvider(
        create: (context) => LupaPasswordBloc(),
        child: LupaPasswordView(),
      ),
    );
  }
}

class LupaPasswordView extends StatelessWidget {
  final controller = Get.put(LupaPasswordController());
  LupaPasswordBloc bloc;
  @override
  Widget build(BuildContext context) {
    controller.key = GlobalKey<FormState>();
    bloc = BlocProvider.of<LupaPasswordBloc>(context);
    return BlocListener<LupaPasswordBloc, LupaPasswordState>(
      listener: (context, state) {
        if (state is LupaPasswordStateLoading) {
          controller.isLoading.value = true;
        } else {
          controller.isLoading.value = false;
          if (state is LupaPasswordStateSuccess) {
            Get.toNamed("/auth/forget_password/cek_kode");
            ToastUtil.success(message: state.data['message'] ?? '');
          } else if (state is LupaPasswordStateError) {
            ToastUtil.error(
                message: state.errors['data']['user_email'] ??
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
              type: TextInputType.emailAddress,
              controller: controller.emailController,
              prefixIcon: Icon(Icons.email),
              title: "Email",
              validator: (String value) {
                if (value.isEmpty) {
                  return "Email tidak boleh kosong";
                }
                if (!value.isEmail) {
                  return "Email tidak valid";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Obx(() => MyButtonComp(
                  isLoading: controller.isLoading.value,
                  title: "Kirim",
                  color: Colors.blue,
                  onTap: (controller.isLoading.value)
                      ? () {}
                      : () {
                          if (controller.key.currentState.validate()) {
                            controller.lupa(bloc);
                          }
                        },
                )),
            SizedBox(
              height: 20,
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
