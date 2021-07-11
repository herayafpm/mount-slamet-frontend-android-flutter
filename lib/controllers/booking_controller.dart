import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/bloc/booking/booking_bloc.dart';
import 'package:mount_slamet/repositories/blog_repository.dart';
import 'package:mount_slamet/utils/date_time_util.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class BookingController extends GetxController {
  TextEditingController jumlahPendakiController = TextEditingController();
  TextEditingController tglAwalController = TextEditingController();
  TextEditingController tglAkhirController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
  final showPass = false.obs;
  final isLoading = false.obs;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  var jumlah = 1.obs;
  var tglMasuk =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var tglKeluar =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var isTapMin = false.obs;
  var isTapPlus = false.obs;
  void cekKetersediaan(BookingBloc bloc) {
    isLoading.value = !isLoading.value;
    bloc
      ..add(BookingCekKetersediaanBlocEvent(
          jumlah.value,
          DateTimeUtil.convert(tglMasuk.value),
          DateTimeUtil.convert(tglKeluar.value)));
  }

  final persetujuan = "Persetujuan".obs;

  @override
  void onInit() async {
    Map<String, dynamic> blog = await BlogRepository.informasi();
    persetujuan.value = blog['data']['data']['blog_isi'] ?? "";
    super.onInit();
  }

  void laporan(BookingBloc bloc) {
    isLoading.value = !isLoading.value;
    bloc
      ..add(BookingLaporanBlocEvent(DateTimeUtil.convert(tglMasuk.value),
          DateTimeUtil.convert(tglKeluar.value)));
  }

  void booking(BookingBloc bloc) {
    showDialog(
        context: Get.context,
        builder: (context) => AlertDialog(
              title: Text("Persetujuan"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Batal"),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      isLoading.value = !isLoading.value;
                      Map<String, dynamic> data = new Map<String, dynamic>();
                      data['booking_nama'] = namaController.text;
                      data['booking_alamat'] = alamatController.text;
                      data['booking_no_telp'] = noTelpController.text;
                      data['booking_jml_anggota'] = jumlah.value;
                      data['booking_tgl_masuk'] =
                          DateTimeUtil.convert(tglMasuk.value);
                      data['booking_tgl_keluar'] =
                          DateTimeUtil.convert(tglKeluar.value);
                      bloc..add(BookingProsesEvent(data));
                    },
                    child: Text("Ya, Setuju"))
              ],
              content: SingleChildScrollView(
                child: Html(
                    data: """${persetujuan.value ?? ""}""",
                    onImageTap: (String url, RenderContext context,
                        Map<String, String> attributes, dom.Element element) {
                      _launchURL(url);
                      //open image in webview, or launch image in browser, or any other logic here
                    },
                    onLinkTap: (String url, RenderContext context,
                        Map<String, String> attributes, dom.Element element) {
                      _launchURL(url);
                    }),
              ),
            ));
  }

  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
