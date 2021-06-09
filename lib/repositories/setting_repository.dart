import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mount_slamet/services/dio_service.dart';
import 'package:mount_slamet/utils/response_util.dart';

abstract class SettingRepository {
  // setting
  static Future<Map<String, dynamic>> settingAll() async {
    try {
      Dio dio = await DioService.withAuth();
      Response response = await dio.get("/setting");
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

  static Future<Map<String, dynamic>> updateSetting(
      Map<String, dynamic> setting) async {
    try {
      Dio dio = await DioService.withAuth();
      Response response = await dio.put("/setting", data: setting);
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
  // end booking
}
