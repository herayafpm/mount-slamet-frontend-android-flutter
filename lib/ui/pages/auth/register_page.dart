import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/bloc/auth/register/register_bloc.dart';
import 'package:mount_slamet/controllers/auth/register_controller.dart';
import 'package:mount_slamet/ui/components/my_button_comp.dart';
import 'package:mount_slamet/ui/components/my_input_comp.dart';
import 'package:mount_slamet/ui/templates/auth_template.dart';
import 'package:mount_slamet/utils/toast_util.dart';

import '../../../constants.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
        title: "Create Account",
        body: BlocProvider(
          create: (context) => RegisterBloc(),
          child: RegisterView(),
        ));
  }
}

class RegisterView extends StatelessWidget {
  final controller = Get.put(RegisterController());
  RegisterBloc bloc;
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<RegisterBloc>(context);
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) async {
        if (state is RegisterStateLoading) {
          controller.isLoading.value = true;
        } else {
          controller.isLoading.value = false;
          if (state is RegisterStateSuccess) {
            controller.namaController.text = "";
            controller.emailController.text = "";
            controller.passwordController.text = "";
            controller.password2Controller.text = "";
            ToastUtil.success(message: state.data['message'] ?? '');
            Get.back();
          } else if (state is RegisterStateError) {
            ToastUtil.error(
                message: state.errors['data']['user_nama'] ??
                    state.errors['data']['user_email'] ??
                    state.errors['data']['user_password'] ??
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
              prefixIcon: Icon(Icons.person),
              title: "Nama",
              validator: (value) {
                if (value.isEmpty) {
                  return "Nama tidak boleh kosong";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
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
              height: 20,
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
              height: 20,
            ),
            Obx(() => MyButtonComp(
                isLoading: controller.isLoading.value,
                title: "Create",
                color: Colors.blue,
                onTap: (controller.isLoading.value)
                    ? () {}
                    : () {
                        if (controller.key.currentState.validate()) {
                          controller.register(bloc);
                        }
                      })),
            SizedBox(
              height: 0.02.sh,
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            Parent(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Parent(
                    child: Txt("Have account?",
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
                        Get.back();
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
