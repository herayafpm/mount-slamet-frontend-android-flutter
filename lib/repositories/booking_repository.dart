import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mount_slamet/services/dio_service.dart';
import 'package:mount_slamet/utils/response_util.dart';

abstract class BookingRepository {
  // booking
  static Future<Map<String, dynamic>> bookingAll(
      {int limit = 10, int offset = 0}) async {
    try {
      Dio dio = await DioService.withAuth();
      Response response = await dio.get("booking?limit=$limit&offset=$offset");
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

  static Future<Map<String, dynamic>> bookingDetail(String noOrder) async {
    try {
      Dio dio = await DioService.withAuth();
      Response response = await dio.get("booking/detail/$noOrder");
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

  static Future<Map<String, dynamic>> bookingBatalkan(String noOrder) async {
    try {
      Dio dio = await DioService.withAuth();
      Response response = await dio.post("booking/batalkan/$noOrder");
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

  static Future<Map<String, dynamic>> booking(
      Map<String, dynamic> booking) async {
    try {
      Dio dio = await DioService.withAuth();
      Response response = await dio.post("booking", data: booking);
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

  static Future<Map<String, dynamic>> bookingHariIni() async {
    try {
      Dio dio = await DioService.withAuth();
      Response response = await dio.get("booking/hari_ini");
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

  static Future<Map<String, dynamic>> bookingCekKetersediaan(
      Map<String, dynamic> cek) async {
    try {
      Dio dio = await DioService.withAuth();
      Response response = await dio.post("booking/cek_ketersediaan", data: cek);
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
