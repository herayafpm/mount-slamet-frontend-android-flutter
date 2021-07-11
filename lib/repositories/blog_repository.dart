import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mount_slamet/services/dio_service.dart';
import 'package:mount_slamet/utils/response_util.dart';

abstract class BlogRepository {
  static Future<Map<String, dynamic>> informasi() async {
    try {
      Response response = await DioService.init().get("blog/data");
      Map<String, dynamic> data = Map<String, dynamic>();
      data['statusCode'] = response.statusCode;
      data['data'] = response.data;
      return data;
    } on SocketException catch (e) {
      return ResponseUtil.errorClient(e.message);
    } on DioError catch (e) {
      return ResponseUtil.errorClient(e.message);
    } catch (e) {
      return ResponseUtil.errorClient(e.toString());
    }
  }
}
