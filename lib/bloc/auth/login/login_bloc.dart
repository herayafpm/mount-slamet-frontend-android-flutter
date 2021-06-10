import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mount_slamet/repositories/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginBlocEvent) {
      yield LoginStateLoading();
      Map<String, dynamic> res =
          await AuthRepository.login(event.userEmail, event.userPassword);
      if (res['statusCode'] == 400 || res['data']['status'] == false) {
        yield LoginStateError(res['data']);
      } else if (res['statusCode'] == 200) {
        yield LoginStateSuccess(res['data']);
      } else {
        yield LoginStateError(res['data']);
      }
    } else if (event is LoginWithGoogleBlocEvent) {
      yield LoginStateLoading();
      Map<String, dynamic> res =
          await AuthRepository.loginWithGoogle(event.userAuthKey);
      if (res['statusCode'] == 400 || res['data']['status'] == false) {
        yield LoginStateError(res['data']);
      } else if (res['statusCode'] == 200) {
        yield LoginStateSuccess(res['data']);
      } else {
        yield LoginStateError(res['data']);
      }
    }
  }
}
