import 'package:dio/dio.dart';
import 'package:mount_slamet/constants.dart';
import 'package:mount_slamet/interceptors/auth_interceptor.dart';
import 'package:mount_slamet/interceptors/logging_interceptor.dart';

abstract class DioService {
  static Dio init() {
    Dio dio = new Dio();
    dio.options.baseUrl = Constants.baseUrl;
    dio.options.connectTimeout = 15000;
    dio.options.receiveTimeout = 3000;
    dio.options.validateStatus = (_) => true;
    dio.options.responseType = ResponseType.json;
    dio.interceptors.add(LoggingInterceptor());
    return dio;
  }

  static Future<Dio> withAuth() async {
    Dio dio = new Dio();
    dio.options.baseUrl = Constants.baseUrl;
    dio.options.connectTimeout = 15000;
    dio.options.receiveTimeout = 15000;
    dio.options.validateStatus = (_) => true;
    dio.options.responseType = ResponseType.json;
    dio.interceptors.addAll([LoggingInterceptor(), AuthInterceptor(dio: dio)]);
    return dio;
  }
}
