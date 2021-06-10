import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mount_slamet/bloc/auth/login/login_bloc.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  final showPass = false.obs;
  final isLoading = false.obs;
  final userAuthKey = "".obs;

  void login(LoginBloc bloc) {
    isLoading.value = !isLoading.value;
    bloc..add(LoginBlocEvent(emailController.text, passwordController.text));
  }

  void loginWithGoogle(LoginBloc bloc) {
    isLoading.value = !isLoading.value;
    bloc..add(LoginWithGoogleBlocEvent(userAuthKey.value));
  }

  Future loginGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          '261294496538-n2i66pjniqa04jo6o5hncn25n1u10vl3.apps.googleusercontent.com',
      scopes: <String>[
        'email',
      ],
    );
    try {
      await _googleSignIn.signIn().then((result) {
        result.authentication.then((googleKey) {
          print("google login access" + googleKey.accessToken);
        });
      });
    } catch (error) {
      print(error);
    }
  }
}
