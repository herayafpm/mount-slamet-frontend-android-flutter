import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mount_slamet/models/user_model.dart';

class AuthInterceptor extends Interceptor {
  // int _maxCharactersPerLine = 200;
  Dio dio;
  AuthInterceptor({@required this.dio});
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    dio.interceptors.requestLock.lock();
    var usermodelBox = await Hive.openBox("user_model");
    UserModel user = usermodelBox.getAt(0);
    //Set the token to headers
    options.contentType = "application/json;charset=UTF-8";
    options.headers["Authorization"] = "Bearer " + user.token;
    dio.interceptors.requestLock.unlock();
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // print(
    //     "<-- ${response.statusCode} ${response.request?.method} ${response.request?.path}");
    // String responseAsString = response.data.toString();
    // if (responseAsString.length > _maxCharactersPerLine) {
    //   int iterations =
    //       (responseAsString.length / _maxCharactersPerLine).floor();
    //   for (int i = 0; i <= iterations; i++) {
    //     int endingIndex = i * _maxCharactersPerLine + _maxCharactersPerLine;
    //     if (endingIndex > responseAsString.length) {
    //       endingIndex = responseAsString.length;
    //     }
    //     print(
    //         responseAsString.substring(i * _maxCharactersPerLine, endingIndex));
    //   }
    // } else {
    //   print(response.data);
    // }
    // print("<-- END HTTP");

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // print("<-- Error -->");
    // print(err.error);
    // print(err.message);
    return super.onError(err, handler);
  }
}
