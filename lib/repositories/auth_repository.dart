import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mount_slamet/services/dio_service.dart';
import 'package:mount_slamet/utils/response_util.dart';

abstract class AuthRepository {
  // base_url + "/auth"
  static Future<Map<String, dynamic>> login(
      String userEmail, String userPassword) async {
    try {
      Response response = await DioService.init().post("/auth", data: {
        "user_email": userEmail,
        "user_password": userPassword,
      });
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

  static Future<Map<String, dynamic>> loginWithGoogle(String authKey) async {
    try {
      Response response = await DioService.init().post("/auth", data: {
        "user_auth_key": authKey,
        "auth_tipe": "google",
      });
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

  // base_url + "/auth"
  // base_url + "/auth/lupa_password"
  static Future<Map<String, dynamic>> lupaPassword(String userEmail) async {
    try {
      Response response =
          await DioService.init().post("/auth/lupa_password", data: {
        "user_email": userEmail,
      });
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

  static Future<Map<String, dynamic>> lupaPasswordCekKode(
      String userEmail, int kodeOtp) async {
    try {
      Response response =
          await DioService.init().post("/auth/lupa_password/cek_kode", data: {
        "user_email": userEmail,
        "kode_otp": kodeOtp,
      });
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

  static Future<Map<String, dynamic>> lupaPasswordUbah(
      String userEmail, int kodeOtp, String userPassword) async {
    try {
      Response response = await DioService.init()
          .post("/auth/lupa_password/ubah_password", data: {
        "user_email": userEmail,
        "kode_otp": kodeOtp,
        "user_password": userPassword,
      });
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
