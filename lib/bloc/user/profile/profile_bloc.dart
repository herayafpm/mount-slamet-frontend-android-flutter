import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mount_slamet/repositories/user/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileUbahEvent) {
      yield ProfileStateLoading();
      Map<String, dynamic> res =
          await ProfileRepository.ubahProfile(event.user);
      if (res['statusCode'] == 400 || res['data']['status'] == false) {
        yield ProfileStateError(res['data']);
      } else if (res['statusCode'] == 200 && res['data']['status'] == true) {
        yield ProfileStateSuccess(res['data']);
      } else {
        yield ProfileStateError(res['data']);
      }
    } else if (event is ProfileUbahPasswordEvent) {
      yield ProfileStateLoading();
      Map<String, dynamic> res =
          await ProfileRepository.ubahPassword(event.password);
      if (res['statusCode'] == 400 || res['data']['status'] == false) {
        yield ProfileStateError(res['data']);
      } else if (res['statusCode'] == 200 && res['data']['status'] == true) {
        yield ProfileStateSuccess(res['data']);
      } else {
        yield ProfileStateError(res['data']);
      }
    }
  }
}
