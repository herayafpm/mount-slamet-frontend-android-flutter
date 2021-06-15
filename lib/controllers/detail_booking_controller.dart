import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/bloc/booking/booking_bloc.dart';

class DetailBookingController extends GetxController {
  var noOrder = "".obs;
  var isLoading = false.obs;
  void batalkanBooking(BookingBloc bloc) {
    showDialog(
        context: Get.context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                  child: Text("Tidak"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Ya"),
                  onPressed: () {
                    isLoading.value = !isLoading.value;
                    Navigator.pop(context);
                    bloc..add(BookingBatalkanEvent(noOrder.value));
                  },
                )
              ],
              title: Text("Batalkan"),
              content: Text("Yakin ingin membatalkan data ini?"),
            ));
  }

  void konfirmasiBooking(BookingBloc bloc) {
    showDialog(
        context: Get.context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                  child: Text("Tidak"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Ya"),
                  onPressed: () {
                    isLoading.value = !isLoading.value;
                    Navigator.pop(context);
                    bloc..add(BookingKonfirmasiEvent(noOrder.value));
                  },
                )
              ],
              title: Text("Konfirmasi"),
              content: Text("Yakin ingin mengkonfirmasi data ini?"),
            ));
  }
}
