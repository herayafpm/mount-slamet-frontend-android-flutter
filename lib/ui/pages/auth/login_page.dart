import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mount_slamet/bloc/auth/login/login_bloc.dart';
import 'package:mount_slamet/controllers/auth/login_controller.dart';
import 'package:mount_slamet/models/user_model.dart';
import 'package:mount_slamet/ui/components/my_button_comp.dart';
import 'package:mount_slamet/ui/components/my_flat_button_comp.dart';
import 'package:mount_slamet/ui/components/my_input_comp.dart';
import 'package:mount_slamet/ui/templates/auth_template.dart';
import 'package:mount_slamet/utils/toast_util.dart';

import '../../../constants.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
        title: "Sign In",
        body: BlocProvider(
          create: (context) => LoginBloc(),
          child: LoginView(),
        ));
  }
}

class LoginView extends StatelessWidget {
  final controller = Get.put(LoginController());
  LoginBloc bloc;
  @override
  Widget build(BuildContext context) {
    controller.key = GlobalKey<FormState>();
    bloc = BlocProvider.of<LoginBloc>(context);
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoginStateLoading) {
          controller.isLoading.value = true;
        } else {
          controller.isLoading.value = false;
          if (state is LoginStateSuccess) {
            var boxUser = await Hive.openBox("user_model");
            var userModel = UserModel.createFromJson(state?.data['data']);
            try {
              boxUser.putAt(0, userModel);
            } catch (e) {
              boxUser.add(userModel);
            }
            controller.emailController.text = "";
            controller.passwordController.text = "";
            Get.offAllNamed("/home");
            if (!userModel.isAdmin &&
                (userModel.userAlamat.isEmpty ||
                    userModel.userNoTelp.isEmpty ||
                    userModel.userNoTelpOt.isEmpty)) {
              Get.offNamedUntil(
                  "/home/akun/ubah_profile", ModalRoute.withName('/home'));
              ToastUtil.success(message: "Harap Lengkapi data diri");
            }
          } else if (state is LoginStateError) {
            ToastUtil.error(message: state.errors['message'] ?? '');
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
              validator: (value) {
                if (value.isEmpty) {
                  return "Email tidak boleh kosong";
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return "password tidak boleh kosong";
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
                title: "Sign In",
                color: Colors.blue,
                onTap: (controller.isLoading.value)
                    ? () {}
                    : () {
                        if (controller.key.currentState.validate()) {
                          controller.login(bloc);
                        }
                      })),
            SizedBox(
              height: 20,
            ),
            MyFlatButtonComp(
                color: Colors.blueAccent,
                title: "Forget Password?",
                onTap: () {
                  Get.toNamed("/auth/forget_password");
                }),
            SizedBox(
              height: 20,
            ),
            // Parent(
            //   gesture: Gestures()
            //     ..onTap(() {
            //       controller.loginGoogle();
            //     }),
            //   style: ParentStyle()
            //     ..background.color(Color(0xffffb8b8))
            //     ..padding(vertical: 10, horizontal: 5)
            //     ..borderRadius(all: 5)
            //     ..elevation(2),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       FaIcon(
            //         FontAwesomeIcons.googlePlusG,
            //         color: Color(0xffff3838),
            //         size: 20.sp,
            //       ),
            //       SizedBox(
            //         width: 10,
            //       ),
            //       Txt(
            //         "Sign In with Google",
            //         style: TxtStyle()
            //           ..textColor(Color(0xffff3838))
            //           ..bold()
            //           ..fontSize(14.sp),
            //       )
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 0.02.sh,
            // ),
            Parent(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Parent(
                    child: Txt("Don't have an account?",
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
                        Get.toNamed("/auth/register");
                      }),
                    child: Txt("Create One",
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
