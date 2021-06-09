import 'package:flutter/material.dart';

/// Ini adalah class static data atau data yang tidak mungkin berubah, kecuali dirubah sendiri
/// * [baseUrl] berisi halaman url untuk API
/// * [oneSignalKey] berisi key one signal
/// * [screenWidth] berisi nilai lebar ukuran layar hp default
/// * [screenHeight] berisi nilai tinggi ukuran layar hp default
/// * [textColor] berisi warna utama tulisan
/// * [inputColor] berisi warna utama isian
/// * [bgColor] berisi warna main background
/// * [bgColor2] berisi warna secondary background
abstract class Constants {
  /// [baseUrl] nilai defaultnya adalah `https://mount-slamet.heraya.my.id`
  static String baseUrl = "https://mount-slamet.heraya.my.id";

  /// [oneSignalKey]
  static String oneSignalKey = "51e7eef2-a967-4a81-bc21-970c99cd5a0e";

  /// [screenWidth] nilai defaultnya adalah `360`
  static double screenWidth = 360;

  /// [screenHeight] nilai defaultnya adalah `640`
  static double screenHeight = 640;

  static List<String> statuses = ["Proses", "Konfirmasi", "Batal"];

  /// [textColor] nilai defaultnya adalah `#156778`
  static Color textColor = Color(0xFF156778);

  /// [inputColor] nilai defaultnya adalah `#535353`
  static Color inputColor = Color(0xFF535353);

  /// [bgColor] nilai defaultnya adalah `#3A9AD9`
  static Color bgColor = Color(0xFF3A9AD9);

  /// [bgColor2] nilai defaultnya adalah `#F8F8F8`
  static Color bgColor2 = Color(0xFFF8F8F8);
}
