import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/bloc/auth/register/register_bloc.dart';

class RegisterController extends GetxController {
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  final showPass = false.obs;
  final isLoading = false.obs;

  void register(RegisterBloc bloc) {
    isLoading.value = !isLoading.value;
    Map<String, dynamic> user = new Map<String, dynamic>();
    user['user_nama'] = namaController.text;
    user['user_email'] = emailController.text;
    user['user_password'] = passwordController.text;
    bloc..add(RegisterBlocEvent(user));
  }
}
