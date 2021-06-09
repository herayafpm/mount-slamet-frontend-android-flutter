import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mount_slamet/services/dio_service.dart';
import 'package:mount_slamet/utils/response_util.dart';
import 'package:path_provider/path_provider.dart';

abstract class BookingRepository {
  // booking
  static Future<Map<String, dynamic>> bookingAll(
      {int limit = 10, int offset = 0, int bookingStatus}) async {
    try {
      Dio dio = await DioService.withAuth();
      Response response = await dio.get(
          "/admin/booking?limit=$limit&offset=$offset&booking_status=$bookingStatus");
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
      Response response = await dio.get("/admin/booking/detail/$noOrder");
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

  static Future<Map<String, dynamic>> bookingKonfirmasi(String noOrder) async {
    try {
      Dio dio = await DioService.withAuth();
      Response response = await dio.post("/admin/booking/konfirmasi/$noOrder");
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

  static Future<Map<String, dynamic>> bookingLaporan(
      String tglAwal, String tglAkhir) async {
    try {
      Dio dio = await DioService.withAuth();
      dio.options.responseType = ResponseType.bytes;
      Response response = await dio.post("/admin/booking/laporan", data: {
        "tgl_awal": tglAwal,
        "tgl_akhir": tglAkhir,
      });
      var tempDir = await getTemporaryDirectory();
      String savePath =
          tempDir.path + "/" + response.headers.value("Filename") ??
              "laporan.pdf";
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      return ResponseUtil.success("Berhasil mendownload laporan");
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
