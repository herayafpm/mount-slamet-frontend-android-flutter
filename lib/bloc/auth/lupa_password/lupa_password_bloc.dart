import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mount_slamet/repositories/auth_repository.dart';

part 'lupa_password_event.dart';
part 'lupa_password_state.dart';

class LupaPasswordBloc extends Bloc<LupaPasswordEvent, LupaPasswordState> {
  LupaPasswordBloc() : super(LupaPasswordInitial());

  @override
  Stream<LupaPasswordState> mapEventToState(
    LupaPasswordEvent event,
  ) async* {
    if (event is LupaPasswordBlocEvent) {
      yield LupaPasswordStateLoading();
      Map<String, dynamic> res =
          await AuthRepository.lupaPassword(event.userEmail);
      if (res['statusCode'] == 400 || res['data']['status'] == false) {
        yield LupaPasswordStateError(res['data']);
      } else if (res['statusCode'] == 200 && res['data']['status'] == true) {
        yield LupaPasswordStateSuccess(res['data']);
      } else {
        yield LupaPasswordStateError(res['data']);
      }
    } else if (event is CekKodeEvent) {
      yield LupaPasswordStateLoading();
      Map<String, dynamic> res = await AuthRepository.lupaPasswordCekKode(
          event.userEmail, event.kodeOtp);
      if (res['statusCode'] == 400 || res['data']['status'] == false) {
        yield LupaPasswordStateError(res['data']);
      } else if (res['statusCode'] == 200 && res['data']['status'] == true) {
        yield LupaPasswordCekTokenSuccess(res['data']);
      } else {
        yield LupaPasswordStateError(res['data']);
      }
    } else if (event is UbahPasswordEvent) {
      yield LupaPasswordStateLoading();
      Map<String, dynamic> res = await AuthRepository.lupaPasswordUbah(
          event.userEmail, event.kodeOtp, event.userPassword);
      if (res['statusCode'] == 400 || res['data']['status'] == false) {
        yield LupaPasswordStateError(res['data']);
      } else if (res['statusCode'] == 200 && res['data']['status'] == true) {
        yield LupaPasswordStateSuccess(res['data']);
      } else {
        yield LupaPasswordStateError(res['data']);
      }
    }
  }
}
