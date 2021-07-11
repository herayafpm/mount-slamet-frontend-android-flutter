import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mount_slamet/repositories/blog_repository.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  BlogBloc() : super(BlogInitial());

  @override
  Stream<BlogState> mapEventToState(
    BlogEvent event,
  ) async* {
    if (event is GetInformasiBlogEvent) {
      yield BlogStateLoading();
      Map<String, dynamic> res = await BlogRepository.informasi();
      if (res['statusCode'] == 400 || res['data']['status'] == false) {
        yield BlogStateError(res['data']);
      } else if (res['statusCode'] == 200 && res['data']['status'] == true) {
        yield BlogStateSuccess(res['data']);
      } else {
        yield BlogStateError(res['data']);
      }
    }
  }
}
