import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/bloc/booking/booking_bloc.dart';
import 'package:mount_slamet/bloc/user/profile/profile_bloc.dart';
import 'package:mount_slamet/controllers/booking_controller.dart';
import 'package:mount_slamet/controllers/home_controller.dart';
import 'package:mount_slamet/controllers/user_controller.dart';
import 'package:mount_slamet/ui/components/my_button_comp.dart';
import 'package:mount_slamet/ui/components/my_input_comp.dart';
import 'package:mount_slamet/ui/components/my_input_multi_line_comp.dart';
import 'package:mount_slamet/ui/templates/auth_template.dart';
import 'package:mount_slamet/utils/toast_util.dart';

class BookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      title: "Data Ketua",
      onBack: () {
        Get.back();
      },
      body: BlocProvider(
        create: (context) => BookingBloc(),
        child: BookingView(),
      ),
    );
  }
}

class BookingView extends StatelessWidget {
  final controller = Get.find<BookingController>();
  final homeController = Get.find<HomeController>();
  BookingBloc bloc;
  @override
  Widget build(BuildContext context) {
    controller.key = GlobalKey<FormState>();
    bloc = BlocProvider.of<BookingBloc>(context);
    controller.namaController.text = homeController.userModel.value.userNama;
    controller.alamatController.text =
        homeController.userModel.value.userAlamat;
    controller.noTelpController.text =
        homeController.userModel.value.userNoTelp;
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) async {
        if (state is BookingStateLoading) {
          controller.isLoading.value = true;
        } else {
          controller.isLoading.value = false;
          if (state is BookingStateSuccess) {
            ToastUtil.success(message: state.data['message'] ?? '');
            Get.back();
          } else if (state is BookingStateError) {
            ToastUtil.error(
                message: state.errors['data']['booking_nama'] ??
                    state.errors['data']['booking_alamat'] ??
                    state.errors['data']['booking_no_telp'] ??
                    state.errors['data']['booking_jml_anggota'] ??
                    state.errors['data']['booking_tgl_masuk'] ??
                    state.errors['data']['booking_tgl_keluar'] ??
                    state.errors['message'] ??
                    '');
          }
        }
      },
      child: Form(
        key: controller.key,
        child: Column(
          children: [
            MyInputComp(
              controller: controller.namaController,
              title: "Nama Lengkap",
              validator: (String value) {
                if (value.isEmpty) {
                  return "kode tidak boleh kosong";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            MyInputMultiLineComp(
              controller: controller.alamatController,
              title: "Alamat (Sesuai KTP)",
              validator: (String value) {
                if (value.isEmpty) {
                  return "alamat tidak boleh kosong";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            MyInputComp(
              type: TextInputType.phone,
              controller: controller.noTelpController,
              title: "No Telp",
              validator: (String value) {
                if (value.isEmpty) {
                  return "no telp tidak boleh kosong";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Obx(() => MyButtonComp(
                  isLoading: controller.isLoading.value,
                  title: "Booking",
                  color: Colors.blue,
                  onTap: (controller.isLoading.value)
                      ? () {}
                      : () {
                          if (controller.key.currentState.validate()) {
                            controller.booking(bloc);
                          }
                        },
                )),
          ],
        ),
      ),
    );
  }
}
